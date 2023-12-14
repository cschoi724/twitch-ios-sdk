//
//  TwitchUserDTO.swift
//  SPLE
//
//  Created by cschoi on 2022/12/14.
//

import Foundation
struct TwitchUserDTO: Codable {
    let id: String
    let login: String
    let display_name: String
    let type: String
    let broadcaster_type: String
    let description: String
    let profile_image_url: String
    let offline_image_url: String
    let view_count: String
    let email: String
    let created_at: String
    
    enum CodingKeys: CodingKey {
        case id
        case login
        case display_name
        case type
        case broadcaster_type
        case description
        case profile_image_url
        case offline_image_url
        case view_count
        case email
        case created_at
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = (try? container.decode(String.self, forKey: .id)) ?? ""
        self.login = (try? container.decode(String.self, forKey: .login)) ?? ""
        self.display_name = (try? container.decode(String.self, forKey: .display_name)) ?? ""
        self.type = (try? container.decode(String.self, forKey: .type)) ?? ""
        self.broadcaster_type = (try? container.decode(String.self, forKey: .broadcaster_type)) ?? ""
        self.description = (try? container.decode(String.self, forKey: .description)) ?? ""
        self.profile_image_url = (try? container.decode(String.self, forKey: .profile_image_url)) ?? ""
        self.offline_image_url = (try? container.decode(String.self, forKey: .offline_image_url)) ?? ""
        self.view_count = (try? container.decode(String.self, forKey: .view_count)) ?? ""
        self.email = (try? container.decode(String.self, forKey: .email)) ?? ""
        self.created_at = (try? container.decode(String.self, forKey: .created_at)) ?? ""
    }
}
