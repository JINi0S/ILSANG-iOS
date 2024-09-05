//
//  XPNetwork.swift
//  ILSANG
//
//  Created by Kim Andrew on 6/21/24.
//

import Foundation
import Alamofire

final class XPNetwork {
    private let url = APIManager.makeURL(CustomerTarget(path: "xpHistory"))
    
    func getXP(page: Int, size: Int) async -> Result<XP,Error> {
        let parameters: Parameters = ["page": page, "size": size]
        return await Network.requestData(url: url + "", method: .get, parameters: parameters, withToken: true)
    }
}
