//
//  TwitchMessageDTO.swift
//  SPLE
//
//  Created by cschoi on 2023/02/22.
//

import Foundation

struct TwitchMessageDTO: Codable {
    let tags: TwitchTagsDTO!
    let source: TwitchSourceDTO!
    let command: TwitchCommandDTO!
    let paramester: String
    
    enum CodingKeys: CodingKey {
        case tags
        case source
        case command
        case paramester
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.tags = (try? container.decodeIfPresent(TwitchTagsDTO.self, forKey: .tags))
        self.source = (try? container.decodeIfPresent(TwitchSourceDTO.self, forKey: .source))
        self.command = (try? container.decodeIfPresent(TwitchCommandDTO.self, forKey: .command))
        self.paramester = (try? container.decode(String.self, forKey: .paramester)) ?? ""
    }
}
