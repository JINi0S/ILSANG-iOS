//
//  AuthService.swift
//  ILSANG
//
//  Created by Lee Jinhee on 7/10/24.
//

import AuthenticationServices
import Alamofire

class AuthService {
    let authNetwork: AuthNetwork = AuthNetwork()
    
    // MARK: - LoginView에서 애플로그인 시 사용
    func loginWithApple(credential: ASAuthorizationAppleIDCredential, storedEmail: String) async -> AuthResponse? {
        guard let identityToken = credential.identityToken else {
            Log("ERROR WITH IDENTITYTOKEN")
            return nil
        }
        
        guard let tokenString = String(data: identityToken, encoding: .utf8) else {
            Log("ERROR WITH TOKEN ENCODING")
            return nil
        }
        
        var email = ""
        if let credentialEmail = credential.email, credentialEmail != "" {
            email = credentialEmail
        } else {
            // TODO: TokenString으로 email 받아오기
            email = storedEmail
        }
        
        let result = await authNetwork.login(accessToken: tokenString, email: email, channel: .Apple)
        switch result {
        case .success(let token):
            // TODO: BE 로직 추가 시 refreshToken 관련 확인 필요
            return AuthResponse(
                authToken: token,
                authUser: AuthUser(email: email, accessToken: tokenString, refreshToken: "")
            )
        case .failure(let error):
            Log(error.localizedDescription)
            return nil
        }
    }
    
    /// AuthChannel에 따라  재로그인 시 사용
    func loginWithChannel(user: AuthUser, channel: AuthChannel) async -> AuthResponse? {
        let result = await authNetwork.login(accessToken: user.accessToken, refreshToken: user.refreshToken, email: user.email, channel: channel)
        
        switch result {
        case .success(let authToken):
            return AuthResponse(authToken: authToken, authUser: user)
        case .failure(let error):
            Log(error.localizedDescription)
            return nil
        }
    }
    
    #if DEBUG
    func loginWithTest(email userEmail: String) async -> AuthResponse? {
        let result = await authNetwork.login(accessToken: "", email: userEmail, channel: .Apple)
        switch result {
        case .success(let token):
            return AuthResponse(
                authToken: token,
                authUser: AuthUser(email: userEmail, accessToken: "", refreshToken: "")
            )
        case .failure(let error):
            Log(error.localizedDescription)
            return nil
        }
    }
    #endif
}

struct AwsAuth: Codable {
    let authorization: String?
}
