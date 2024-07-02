//
//  Network.swift
//  ILSANG
//
//  Created by Lee Jinhee on 6/12/24.
//

import Alamofire
import Foundation
import UIKit

final class Network {
    static let retryLimit = 3
    static let retryDelay: TimeInterval = 1
    static let requestTimeout: TimeInterval = 30
    
    private static func buildURL(url: String, parameters: Parameters? = nil, page: Int? = nil, size: Int? = nil) -> URL? {
        var components = URLComponents(string: url)
        var queryItems = [URLQueryItem]()

        if let parameters = parameters {
            for (key, value) in parameters {
                queryItems.append(URLQueryItem(name: key, value: "\(value)"))
            }
        }

        if let page = page {
            queryItems.append(URLQueryItem(name: "page", value: "\(page)"))
        }
        
        if let size = size {
            queryItems.append(URLQueryItem(name: "size", value: "\(size)"))
        }
        
        components?.queryItems = queryItems
        return components?.url
    }
    
    private static func buildHeaders(withToken: Bool, contentType: ContentType = .json) -> HTTPHeaders {
        var headers: HTTPHeaders = ["accept": "application/json", "Content-Type": contentType.toString]
        if withToken {
            headers.add(.authorization(APIManager.authDevelopToken))
        }
        return headers
    }
    
    static func requestData<T: Decodable>(url: String, method: HTTPMethod, parameters: Parameters?, body: Data? = nil, withToken: Bool, page: Int? = nil, size: Int? = nil) async -> Result<T, Error> {
        guard let fullPath = buildURL(url: url, parameters: parameters, page: page, size: size) else {
            return .failure(NetworkError.invalidURL)
        }
        
        let headers = buildHeaders(withToken: withToken)
        
        let request: DataRequest
        if let body = body {
            var urlRequest = URLRequest(url: fullPath)
            urlRequest.method = method
            urlRequest.headers = headers
            urlRequest.httpBody = body
            request = AF.request(urlRequest)
        } else {
            request = AF.request(fullPath, method: method, encoding: parameters != nil ? URLEncoding.queryString : JSONEncoding.default, headers: headers)
        }
        
        let response = await request.validate(statusCode: 200..<300)
            .serializingDecodable(T.self)
            .response
        
        switch response.result {
        case .success(let res):
            return .success(res)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    static func requestImage(url: String, withToken: Bool) async -> Result<UIImage, Error> {
        guard let fullPath = buildURL(url: url) else {
            return .failure(NetworkError.invalidURL)
        }
        
        let headers = buildHeaders(withToken: withToken)
        
        let request: DataRequest
        request = AF.request(fullPath, method: .get, headers: headers)
        
        let response = await request.validate(statusCode: 200..<300)
            .serializingData()
            .response
        
        switch response.result {
        case .success(let imageData):
            guard let image = UIImage(data: imageData) else {
                return .failure(NetworkError.invalidImageData)
            }
            return .success(image)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    static func postImage(url: String, image: UIImage, withToken: Bool, parameters: Parameters) async -> Result<ImageEntity, Error> {
        guard let fullPath = buildURL(url: url, parameters: parameters) else {
            return .failure(NetworkError.invalidURL)
        }
        
        let headers = buildHeaders(withToken: withToken, contentType: .multipart)
        
        var urlRequest = URLRequest(url: fullPath)
        urlRequest.method = .post
        urlRequest.headers = headers
        urlRequest.timeoutInterval = requestTimeout
        
        // 이미지 압축 & 다운샘플링
        var uiImage = image
        var currentCompressionQuality: CGFloat = 0.5
        if image.size.width > 3000 || image.size.height > 3000 {
            guard let downSampledImage = image.downSample(scale: 0.8) else {
                return .failure(NetworkError.invalidImageData)
            }
            uiImage = downSampledImage
        }
        
        // 이미지 업로드 실패 시 currentCompressionQuality 줄이면서 retryLimit만큼 재시도
        for attempt in 1...self.retryLimit {
            let imageData = uiImage.jpegData(compressionQuality: currentCompressionQuality) ?? Data()
            
            let response = await AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(imageData,
                                         withName: "file",
                                         fileName: "image.png",
                                         mimeType: "image/jpeg")
            }, with: urlRequest)
                .serializingDecodable(Response<ImageEntity>.self)
                .response
            
            switch response.result {
            case .success(let res):
                if let statusCode = response.response?.statusCode {
                    return handleStatusCode(statusCode, data: res.data)
                } else {
                    return .failure(NetworkError.unknownError)
                }
            case .failure(let error):
                if attempt < retryLimit {
                    try? await Task.sleep(nanoseconds: UInt64(self.retryDelay * 1_000_000_000))
                    currentCompressionQuality = (currentCompressionQuality * 5) / 10
                } else {
                    return .failure(NetworkError.requestFailed(error.localizedDescription))
                }
            }
        }
        return .failure(NetworkError.unknownError)
    }
    
    private static func handleStatusCode<T>(_ statusCode: Int, data: T?) -> Result<T, Error> {
        switch statusCode {
        case 200..<300:
            if let data = data {
                return .success(data)
            } else {
                return .failure(NetworkError.unknownError)
            }
        case 400..<500:
            return .failure(NetworkError.clientError)
        case 500..<600:
            return .failure(NetworkError.serverError)
        default:
            return .failure(NetworkError.unknownStatusCode(statusCode))
        }
    }
}

extension Network {
    enum ContentType {
        case json
        case multipart
        
        var toString: String {
            switch self {
            case .json:
                "application/json"
            case .multipart:
                "multipart/form-data"
            }
        }
    }
    
    enum NetworkError: Error {
        case invalidURL
        case invalidImageData
        case clientError
        case serverError
        case requestFailed(String)
        case unknownError
        case unknownStatusCode(Int)
    }
}