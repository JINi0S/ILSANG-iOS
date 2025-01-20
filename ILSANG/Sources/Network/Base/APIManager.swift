//
//  APIManager.swift
//  ILSANG
//
//  Created by Lee Jinhee on 6/16/24.
//

import Foundation

final class APIManager {
    static let baseURL = EnvironmentConfig.rootURL + ":" + EnvironmentConfig.port
    
    ///개발용 토큰
    static let authDevelopToken =    "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOiJhMTFjNDQxMS0xOTU0LTRiMWEtYjg0Ny0zYWY4NjU5MTNiM2YiLCJ1c2VyVHlwZSI6IkNVU1RPTUVSIn0.tM8UzimEvBVOH3hC-Put8J3iVU-QAeXlteRmcFjFHus"
    
    static func makeURL(_ target: APITarget) -> String {
        baseURL + "/api/" + target.type + "/" + target.path
    }
}


enum EnvironmentConfig {
    // MARK: - Keys
    enum Keys {
        enum Plist {
            static let rootURL = "ROOT_URL"
            static let port = "PORT"
        }
    }

    // MARK: - Plist
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()

    // MARK: - Plist values
    static let rootURL: String = {
        guard let rootURLstring = EnvironmentConfig.infoDictionary[Keys.Plist.rootURL] as? String else {
            fatalError("Root URL not set in plist for this environment")
        }
   
        return rootURLstring
    }()

    static let port: String = {
        guard let port = EnvironmentConfig.infoDictionary[Keys.Plist.port] as? String else {
            fatalError("Port not set in plist for this environment")
        }
        return port
    }()
}
