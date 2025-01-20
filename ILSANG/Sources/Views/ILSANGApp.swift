//
//  ILSANGApp.swift
//  ILSANG
//
//  Created by Lee Jinhee on 5/19/24.
//

import SwiftUI

@main
struct ILSANGApp: App {
    @AppStorage("isLogin") var isLogin = Bool()
    
    @State private var isTutorialVisible = Bool()
    @State private var isSplashScreenVisible = true
    
    init() {
        setTabBarAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if isSplashScreenVisible {
                    SplashScreenView()
                } else if !isLogin {
                    LoginView(vm: LoginViewModel())
                } else {
                    MainTabView()
                        .fullScreenCover(isPresented: $isTutorialVisible, content: {
                            TutorialView()
                        })
                    }
            }
            .onChange(of: isLogin, { _, newValue in // 로그인 후 튜토리얼 UI 표시
                if newValue {
                    isTutorialVisible = true
                }
            })
            .task {
                await runAppStartup()
            }
        }
    }
    
    @MainActor
    private func runAppStartup() async {
        // 1. 스플래시 화면 표시
        try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.5초 대기
        
        // 2. 로그인 상태 확인
        if isLogin {
            let _ = await UserService.shared.login()
        }
        
        // 3. 스플래시 화면 종료
        isSplashScreenVisible = false
    }
    
    func setTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor(.white)
        appearance.shadowColor = UIColor(.grayDD)
        appearance.stackedItemPositioning = .centered
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

struct SplashScreenView: View {
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            VStack {
                Image(.logo) /// 런치스크린에서 사용한 이미지
                    .resizable()
                    .scaledToFit()
                    .frame(width: 172, height: 172)
                    .offset(y: -8)
                    .ignoresSafeArea()
            }
        }
    }
}

public func Log<T>(_ object: T?, filename: String = #file, line: Int = #line, funcName: String = #function) {
#if DEBUG
    if let obj = object {
        print("\(filename.components(separatedBy: "/").last ?? "")(\(line)) : \(funcName) : \(obj)")
    } else {
        print("\(filename.components(separatedBy: "/").last ?? "")(\(line)) : \(funcName) : nil")
    }
#endif
}
