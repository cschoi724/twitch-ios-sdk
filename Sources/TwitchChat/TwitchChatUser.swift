//
//  TwitchChatUser.swift
//
//
//  Created by cschoi on 12/13/23.
//

import Foundation

public struct TwitchChatUser: Hashable {
    public let id: String
    public let loginId: String
    public let userType: TwitchUserType
    public let badges: [TwitchChatBadge]
    public let color: String
    public let displayName: String
    public let subscriber: Bool
    public let turbo: Bool
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id.hashValue)
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    init(
        id: String,
        loginId: String = "",
        userType: TwitchUserType = .normal,
        badges: [TwitchChatBadge] = [],
        color: String = "",
        displayName: String = "",
        subscriber: Bool = false,
        turbo: Bool = false
    ) {
        self.id = id
        self.loginId = loginId
        self.userType = userType
        self.badges = badges
        self.color = color
        self.displayName = displayName
        self.subscriber = subscriber
        self.turbo = turbo
    }
}
