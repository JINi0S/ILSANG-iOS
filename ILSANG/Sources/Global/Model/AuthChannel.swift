//
//  AuthChannel.swift
//  ILSANG
//
//  Created by Lee Jinhee on 7/11/24.
//

enum AuthChannel {
    case Kakao
    case Apple
    case Google
    
    var stringValue: String {
        switch self {
        case .Kakao:
            "KAKAO"
        case .Apple:
            "APPLE"
        case .Google:
            "GOOGLE"
        }
    }
    
    static func fromString(value: String) -> AuthChannel? {
        switch value {
        case "KAKAO":
            return .Kakao
        case "APPLE":
            return .Apple
        case "GOOGLE":
            return .Google
        default:
            return nil
        }
    }
}
