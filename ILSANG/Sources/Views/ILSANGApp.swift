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
    
    init() {
        setTabBarAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            if !isLogin {
                LoginView(vm: LoginViewModel())
            } else {
                MainTabView()
                    .task {
                        if isLogin {
                            await handleLogin()
                        }
                    }
            }
        }
    }
    
    @MainActor
    private func handleLogin() async {
        do {
            isLogin = try await UserService.shared.login()
        } catch {
            isLogin = false
        }
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

public func Log<T>(_ object: T?, filename: String = #file, line: Int = #line, funcName: String = #function) {
#if DEBUG
    if let obj = object {
        print("\(filename.components(separatedBy: "/").last ?? "")(\(line)) : \(funcName) : \(obj)")
    } else {
        print("\(filename.components(separatedBy: "/").last ?? "")(\(line)) : \(funcName) : nil")
    }
#endif
}
