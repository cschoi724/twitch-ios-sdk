//
//  TwitchBadgesDTO.swift
//  SPLE
//
//  Created by cschoi on 2023/02/22.
//

import Foundation

struct TwitchBadgesDTO: Codable {
    let admin: Bool
    let bits: Bool
    let broadcaster: Bool
    let moderator: Bool
    let subscriber: Bool
    let staff: Bool
    let turbo: Bool
}
