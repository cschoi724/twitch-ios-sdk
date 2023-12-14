//
//  TwitchUserState.swift
//
//
//  Created by cschoi on 12/13/23.
//

import Foundation

struct TwitchuserState {
    // @badge-info=;badges=;color=;display-name=젤라빈;emote-sets=0;id=cce93a25-f704-4cf1-89bc-8cf8af68232a;mod=0;subscriber=0;user-type= :tmi.twitch.tv USERSTATE #portialyn
    let id: String
    let loginId: String
    let userType: TwitchUserType
    let badges: [TwitchChatBadge]
    let color: String
    let displayName: String
    let subscriber: Bool
    let turbo: Bool
}
