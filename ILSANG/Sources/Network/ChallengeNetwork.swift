//
//  ChallengeNetwork.swift
//  ILSANG
//
//  Created by Lee Jinhee on 6/26/24.
//

import Alamofire
import Foundation

final class ChallengeNetwork {
    private let network: Network
    private let url: String

    init(network: Network = Network(), url: String =  APIManager.makeURL(CustomerTarget(path: ""))) {
        self.network = network
        self.url = url
    }
    
    func getRandomChallenges(page: Int, size: Int = 10) async -> Result<ResponseWithPage<[Challenge]>, Error> {
        let parameters: Parameters = ["page": page, "size": size]
        return await Network.requestData(url: url+"randomChallenge", method: .get, parameters: parameters, withToken: true)
    }
    
    func getChallenges(page: Int) async -> Result<ResponseWithPage<[Challenge]>, Error> {
        let parameters: Parameters = ["userDataOnly": true, "page": page, "size": "10"]
        return await Network.requestData(url: url+"challenge", method: .get, parameters: parameters, withToken: true)
    }
    
    func postChallenge(questId: String, imageId: String) async -> Result<ResponseWithEmpty, Error> {
        let bodyData: [String: Any] = [
            "questId": questId,
            "receiptImageId": imageId
        ]
        
        guard let jsonData = bodyData.convertToJsonData() else {
            return .failure(NetworkError.requestFailed("Fail to convert data"))
        }
        return await Network.requestData(url: url+"challenge", method: .post, parameters: nil, body: jsonData, withToken: true)
    }
    
    func deleteChallenge(challengeId: String) async -> Bool {
        let parameters: Parameters = ["challengeId": challengeId]
        let res: Result<ResponseWithoutData, Error> = await Network.requestData(url: url+"challenge", method: .delete, parameters: parameters, withToken: true)
        switch res {
        case .success:
            Log(res)
            return true
        case .failure:
            Log(res)
            return false
        }
    }
}
