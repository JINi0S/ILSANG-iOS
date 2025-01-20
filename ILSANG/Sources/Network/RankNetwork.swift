//
//  RankNetwork.swift
//  ILSANG
//
//  Created by Lee Jinhee on 1/17/25.
//

import Alamofire

final class RankNetwork {
    private let openRankUrl = APIManager.makeURL(OpenTarget(path: "v1/rank/top-users"))
    private let statRankUrl = APIManager.makeURL(CustomerTarget(path: "rank"))
    
    func getTopUserRank() async -> Result<Response<[TopRank]>, Error> {
        let parameters: Parameters = ["limit": 10]
        return await Network.requestData(url: openRankUrl, method: .get, parameters: parameters, withToken: false)
    }
    
    func getRankByStat(xpstat: String) async -> Result<Response<[StatRank]>, Error> {
        let parameters: Parameters = ["xpType":xpstat, "size": 20]
        return await Network.requestData(url: statRankUrl, method: .get, parameters: parameters, withToken: true)
    }
}
