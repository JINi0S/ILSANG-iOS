//
//  SettingView.swift
//  ILSANG
//
//  Created by Kim Andrew on 5/29/24.
//

import SwiftUI

struct SettingView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var logoutAlert = false
    
    private let settingList: [Setting] = [
        Setting(title: "고객센터", type: .navigate),
        Setting(title: "약관 및 정책", type: .navigate),
        Setting(title: "현재 버전", type: .info("v.0.0.1")),
        Setting(title: "로그아웃", type: .alert),
        Setting(title: "회원 탈퇴", titleColor: .subRed, type: .navigate)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationTitleView(title: "설정", isSeparatorHidden: true) {
                dismiss()
            }
            
            List(settingList) { item in
                Group {
                    switch item.type {
                    case .navigate:
                        NavigationLink(destination: destinationView(for: item)) {
                            settingListItemView(title: item.title, titleColor: item.titleColor)
                        }
                    case .alert:
                        Button {
                            logoutAlert.toggle()
                        } label: {
                            settingListItemView(title: item.title, titleColor: item.titleColor)
                        }
                    case .info(let subInfo):
                        settingListItemView(title: item.title, titleColor: item.titleColor, subInfo: subInfo)
                    }
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
        }
        .navigationBarBackButtonHidden()
        .overlay {
            if logoutAlert {
                SettingAlertView(
                    alertType: .Logout,
                    onCancel: { logoutAlert = false },
                    onConfirm: {
                        Task {
                            // 로그아웃 함수 호출
                            let result = await LogoutNetwork().getLogout()
                            print(result)
                            // TODO: 로그아웃 로직 추가 확인 필요
                            UserService.shared.isLogin = false
                        }
                    }
                )
            }
        }
    }
    
    private func settingListItemView(title: String, titleColor: Color, subInfo: String = "") -> some View {
        HStack {
            Text(title)
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(titleColor)
            Spacer()
            Text(subInfo)
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(.gray200)
        }
        .frame(height: 36)
    }
    
    //특정 Setting에 따라서 뷰를 다르게 호출
    @ViewBuilder
    private func destinationView(for item: Setting) -> some View {
        switch item.title {
        case "고객센터":
            CustomerServiceView()
        case "약관 및 정책":
            TermsAndPolicyView()
        case "회원 탈퇴":
            DeleteAccountView()
        default:
            Text("")
        }
    }
}

#Preview {
    SettingView()
}
