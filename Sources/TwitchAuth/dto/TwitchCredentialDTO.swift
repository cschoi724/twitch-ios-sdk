//
//  TwitchCredentialDTO.swift
//  SPLE
//
//  Created by cschoi on 2022/12/14.
//

import Foundation
struct TwitchCredentialDTO: Codable {
    /*
     "access_token": "rfx2uswqe8l4g1mkagrvg5tv0ks3",
      "expires_in": 14124,
      "refresh_token": "5b93chm6hdve3mycz05zfzatkfdenfspp1h1ar2xxdalen01",
      "scope": [
        "channel:moderate",
        "chat:edit",
        "chat:read"
      ],
      "token_type": "bearer"
     */
    let access_token: String
    let expires_in: Int
    let refresh_token: String
    let scope: [String]
    let token_type: String
    
    enum CodingKeys: CodingKey {
        case access_token
        case expires_in
        case refresh_token
        case scope
        case token_type
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.access_token = (try? container.decode(String.self, forKey: .access_token)) ?? ""
        self.expires_in = (try? container.decode(Int.self, forKey: .expires_in)) ?? 0
        self.refresh_token = (try? container.decode(String.self, forKey: .refresh_token)) ?? ""
        self.scope = (try? container.decode([String].self, forKey: .scope)) ?? []
        self.token_type = (try? container.decode(String.self, forKey: .token_type)) ?? ""
    }
}
