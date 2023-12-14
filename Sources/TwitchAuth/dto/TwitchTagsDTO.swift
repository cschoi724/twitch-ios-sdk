//
//  TwitchTagsDTO.swift
//  SPLE
//
//  Created by cschoi on 2023/02/22.
//

import Foundation

struct TwitchTagsDTO: Codable {
    let badges: TwitchBadgesDTO!
    let color: String
    let displayName: String
    let emoteOnly: String
    let emotes: [String: [TwitchEmotePositionDTO]]
    let id: String
    let mode: String
    let roomId: String
    let subscriber: String
    let turbo: String
    let tmiSentTs: String
    let userId: String
    let userType: String
 
    enum CodingKeys: CodingKey {
        case badges
        case color
        case displayName
        case emoteOnly
        case emotes
        case id
        case mode
        case roomId
        case subscriber
        case turbo
        case tmiSentTs
        case userId
        case userType
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.badges = (try? container.decodeIfPresent(TwitchBadgesDTO.self, forKey: .badges))
        self.color = (try? container.decode(String.self, forKey: .color)) ?? ""
        self.displayName = (try? container.decode(String.self, forKey: .displayName)) ?? ""
        self.emoteOnly = (try? container.decode(String.self, forKey: .emoteOnly)) ?? ""
        self.emotes = (try? container.decode([String: [TwitchEmotePositionDTO]].self, forKey: .emotes)) ?? [:]
        self.id = (try? container.decode(String.self, forKey: .id)) ?? ""
        self.mode = (try? container.decode(String.self, forKey: .mode)) ?? ""
        self.roomId = (try? container.decode(String.self, forKey: .roomId)) ?? ""
        self.subscriber = (try? container.decode(String.self, forKey: .subscriber)) ?? ""
        self.turbo = (try? container.decode(String.self, forKey: .turbo)) ?? ""
        self.tmiSentTs = (try? container.decode(String.self, forKey: .tmiSentTs)) ?? ""
        self.userId = (try? container.decode(String.self, forKey: .userId)) ?? ""
        self.userType = (try? container.decode(String.self, forKey: .userType)) ?? ""
    }
}

/*
 
 
 "badges": {
          "staff": "1",
          "broadcaster": "1",
          "turbo": "1"
       },
       "color": "#FF0000",
       "display-name": "PetsgomOO",
       "emote-only": "1",
       "emotes": {
          "33": [
             {
                "startPosition": "0",
                "endPosition": "7"
             }
          ]
       },
       "id": "c285c9ed-8b1b-4702-ae1c-c64d76cc74ef",
       "mod": "0",
       "room-id": "81046256",
       "subscriber": "0",
       "turbo": "0",
       "tmi-sent-ts": "1550868292494",
       "user-id": "81046256",
       "user-type": "staff"
 */
