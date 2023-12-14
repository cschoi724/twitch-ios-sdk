//
//  TwitchChatBadge.swift
//
//
//  Created by cschoi on 12/13/23.
//

import Foundation

public class TwitchChatBadge {
    public enum Name: String {
        case admin
        case bits
        case broadcaster
        case moderator
        case subscriber
        case staff
        case turbo
        case vip
        case partner
        // 다른 Twitch 배지 이름 추가 가능
    }
    
    public let name: Name
    public let version: String?
    
    init(name: Name, version: String? = nil) {
        self.name = name
        self.version = version
    }
}
