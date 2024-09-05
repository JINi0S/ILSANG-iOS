//
//  QuestNetwork.swift
//  ILSANG
//
//  Created by Kim Andrew on 7/2/24.
//

import Foundation
import Alamofire

final class QuestNetwork {
    
    private let questUrl: String
    
    init(questUrl: String = APIManager.makeURL(CustomerTarget(path: ""))) {
        self.questUrl = questUrl
    }
    
    func getUncompletedQuest(page: Int) async -> Result<ResponseWithPage<[Quest]>, Error> {
        let parameters: Parameters = ["page": page, "size": "10"]
        return await Network.requestData(url: questUrl+"uncompletedQuest", method: .get, parameters: parameters, withToken: true)
    }
    
    func getCompletedQuest(page: Int) async -> Result<ResponseWithPage<[Quest]>, Error> {
        let parameters: Parameters = ["page": page, "size": "10"]
        return await Network.requestData(url: questUrl+"completedQuest", method: .get, parameters: parameters, withToken: true)
    }
}
