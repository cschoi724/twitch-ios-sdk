//
//  TwitchEmoteDTO.swift
//  SPLE
//
//  Created by cschoi on 2023/02/22.
//

import Foundation

struct TwitchEmotePositionDTO: Codable {
    let startPosition: String
    let endPosition: String
    
    enum CodingKeys: CodingKey {
        case startPosition
        case endPosition
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.startPosition = (try? container.decode(String.self, forKey: .startPosition)) ?? ""
        self.endPosition = (try? container.decode(String.self, forKey: .endPosition)) ?? ""
    }
}
