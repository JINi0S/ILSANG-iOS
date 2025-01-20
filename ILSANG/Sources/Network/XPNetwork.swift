//
//  XPNetwork.swift
//  ILSANG
//
//  Created by Kim Andrew on 6/21/24.
//

import Foundation
import Alamofire

final class XPNetwork {
    private let HistoryUrl = APIManager.makeURL(CustomerTarget(path: "xpHistory"))
    private let StatsUrl = APIManager.makeURL(CustomerTarget(path: "xpStats"))
    
    func getXpHistory(page: Int, size: Int) async -> Result<Response<[XpLog]>,Error> {
        let parameters: Parameters = ["page": page, "size": size]
        return await Network.requestData(url: HistoryUrl + "", method: .get, parameters: parameters, withToken: true)
    }
    
    func getXpStats() async -> Result<Response<XpStats>,Error> {
        return await Network.requestData(url: StatsUrl, method: .get, parameters: nil, withToken: true)
    }
}
