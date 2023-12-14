//
//  TwitchRepository.swift
//
//
//  Created by cschoi on 2023/03/03.
//

import Alamofire
import TwitchCommon
import Foundation

protocol TwitchRepository {
    func getInfo(accessToken: String, completion: @escaping (Result<TwitchUserDTO, TwitchSDKError>) -> Void)
    func getToken(code: String, completion: @escaping (Result<TwitchCredentialDTO, TwitchSDKError>) -> Void)
}

class DefaultTwitchRepository: TwitchRepository {
    let config: TwitchAuthConfigration
    
    init(config: TwitchAuthConfigration) {
        self.config = config
    }
    
    func getInfo(accessToken: String, completion: @escaping (Result<TwitchUserDTO, TwitchSDKError>) -> Void) {
        let urlStr = "https://api.twitch.tv/helix/users"
        guard let url = URL(string: urlStr) else {
            completion(.failure(TwitchSDKError.urlGeneration))
            return
        }
        let authorization = "Bearer \(accessToken)"
        let req = AF.request(
            url,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: [
                "Authorization": authorization,
                "Client-Id": config.clientId
            ]
        )
        req.responseDecodable(of: TwitchResponseDTO<[TwitchUserDTO]>.self) { response in
            switch response.result {
            case .success(let result):
                print(result)
                if let userDTO = result.data.first {
                    print("success twitch login")
                    completion(.success(userDTO))
                } else {
                    completion(.failure(TwitchSDKError.responseSerializationFailed))
                }
            case .failure(let error):
                completion(.failure(.networkError(error: error)))
            }
        }
    }
    
    func getToken(code: String, completion: @escaping (Result<TwitchCredentialDTO, TwitchSDKError>) -> Void) {
        // let urlStr = "https://api.twitch.tv/kraken/oauth2/token"
        let urlStr = "https://id.twitch.tv/oauth2/token"
        guard let url = URL(string: urlStr) else {
            completion(.failure(TwitchSDKError.urlGeneration))
            return
        }
        let body: [String: Any] = [
            "Client-ID": config.clientId,
            "client_secret": config.secretKey,
            "code": code,
            "redirect_uri": config.redirectUri,
            "grant_type": "authorization_code"
        ]
        
        let req = AF.request(
            url,
            method: .post,
            parameters: body,
            encoding: JSONEncoding.default
        )
        
        req.responseDecodable(of: TwitchCredentialDTO.self) { response in
            switch response.result {
            case .success(let result):
                print(result)
                completion(.success(result))
            case .failure(let error):
                completion(.failure(.networkError(error: error)))
            }
        }
    }
}
