//
//  TwitchCommandDTO.swift
//  SPLE
//
//  Created by cschoi on 2023/02/22.
//

import Foundation

struct TwitchCommandDTO: Codable {
    let command: String
    let channel: String
    let botCommand: String
    let botCommandParams: String
    let isCapRequestEnabled: Bool
    
    enum CodingKeys: CodingKey {
        case command
        case channel
        case botCommand
        case botCommandParams
        case isCapRequestEnabled
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.command = (try? container.decode(String.self, forKey: .command)) ?? ""
        self.channel = (try? container.decode(String.self, forKey: .channel)) ?? ""
        self.botCommand = (try? container.decode(String.self, forKey: .botCommand)) ?? ""
        self.botCommandParams = (try? container.decode(String.self, forKey: .botCommandParams)) ?? ""
        self.isCapRequestEnabled = (try? container.decode(Bool.self, forKey: .isCapRequestEnabled)) ?? false
    }
}
