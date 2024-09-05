//
//  AppleLoginButtonView.swift
//  TeamFair
//
//  Created by apple on 2023/07/27.
//

import SwiftUI
import AuthenticationServices

struct AppleLoginButtonView: View {
    @ObservedObject var vm: LoginViewModel
    
    var body: some View {
        SignInWithAppleButton { request in
            request.requestedScopes = [.email]
            request.nonce = sha256(randomNonceString())
        } onCompletion: { result in
            switch result {
            case .success(let authResult):
                vm.loginWithApple(credential: authResult.credential)
            case .failure(let error):
                Log(error.localizedDescription)
            }
        }
        .frame(width: 270, height: 50)
        
        .overlay {
            HStack {
                Image(LoginButton.apple.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18)
                Spacer()
                Text(LoginButton.apple.labelText)
                    .foregroundColor(LoginButton.apple.accentColor)
                    .font(.custom(LoginButton.apple.fontName, size: 14))
                Spacer()
            }
            .padding(.horizontal, 18)
            .frame(width: 270, height: 50)
            .background(LoginButton.apple.backgroundColor)
            .allowsHitTesting(false)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
