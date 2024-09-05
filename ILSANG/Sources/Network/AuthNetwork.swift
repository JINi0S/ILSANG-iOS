//
//  AuthNetwork.swift
//  ILSANG
//
//  Created by Lee Jinhee on 7/10/24.
//

import Foundation

final class AuthNetwork {
    private let url = APIManager.makeURL(OpenTarget(path: "login"))
    
    func login(accessToken: String, refreshToken: String = "tokenString", email: String, channel: AuthChannel) async -> Result<String, NetworkError> {
        let body = ["userType": "CUSTOMER",
                    "accessToken": accessToken,
                    "refreshToken": refreshToken,
                    "email": email,
                    "channel": channel.stringValue]
        let bodyData = body.convertToJsonData()
        let response: Result<Response<AwsAuth>, Error> = await Network.requestData(url: url, method: .post, parameters: nil, body: bodyData, withToken: false)
        
        switch response {
        case .success(let res):
            guard let auth = res.data.authorization else {
                return .failure(NetworkError.requestFailed("Invalid Data"))
            }
            return .success(auth)
        case .failure(let error):
            return .failure(.requestFailed(error.localizedDescription))
        }
    }
}
