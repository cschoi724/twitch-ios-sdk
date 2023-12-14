//
//  APIManager.swift
//
//
//  Created by cschoi on 12/14/23.
//

import Alamofire
import Foundation

public class APIManager {
    public static let shared = APIManager()
    public var session :Session!
    
    public init() {
        initSession()
    }
}

extension APIManager {
    private func initSession() {
        let apiSessionConfiguration : URLSessionConfiguration = .default
        self.session = Session(configuration: apiSessionConfiguration)
    }
    
    public func request<T: Codable>(_ HTTPMethod: Alamofire.HTTPMethod,
                                    _ url: String,
                                    parameters: [String: Any]? = nil,
                                    headers: [String: String]? = nil,
                                    completion: @escaping  (Result<T, Error>) -> Void) {
        session.request(
            url,
            method: HTTPMethod,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers:(headers != nil ? HTTPHeaders(headers!):nil)
        )
        .responseDecodable(of: T?.self) { response in
            switch response.result {
            case .success(let result):
                if let data = result {
                    completion(.success(data))
                } else {
                    completion(.failure(TwitchSDKError.responseSerializationFailed))
                }
            case .failure(let error):
                completion(.failure(TwitchSDKError.networkError(error: error)))
            }
        }
    }
}
