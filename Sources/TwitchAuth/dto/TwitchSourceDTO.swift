//
//  TwitchSourceDTO.swift
//  SPLE
//
//  Created by cschoi on 2023/02/22.
//

import Foundation

struct TwitchSourceDTO: Codable {
    let nick: String
    let host: String
    
    enum CodingKeys: CodingKey {
        case nick
        case host
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.nick = (try? container.decode(String.self, forKey: .nick)) ?? ""
        self.host = (try? container.decode(String.self, forKey: .host)) ?? ""
    }
}
