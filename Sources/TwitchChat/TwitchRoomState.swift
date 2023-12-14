//
//  TwitchRoomState.swift
//
//
//  Created by cschoi on 12/13/23.
//

import Foundation

public struct TwitchRoomState {
    // @emote-only=0;followers-only=0;r9k=0;slow=0;subs-only=0 :tmi.twitch.tv ROOMSTATE #dallas
    public var id: String
    public var channel: String
    public var emoteOnly: Int
    public var followerOnly: Int
    public var r9k: Int
    public var slow: Int
    public var subscriberOnly: Int
    
    init(
        id: String,
        channel: String,
        emoteOnly: Int = 0,
        followerOnly: Int = -1,
        r9k: Int = 0,
        slow: Int = 0,
        subscriberOnly: Int = 0
    ) {
        self.id = id
        self.channel = channel
        self.emoteOnly = emoteOnly
        self.followerOnly = followerOnly
        self.r9k = r9k
        self.slow = slow
        self.subscriberOnly = subscriberOnly
    }
    
    /*
    
    var connection: TwitchChatConnection
    var id: String
    var name: String
    var dateJoined: String
    var dateParted: String
    var topic: String
    var dateTopicChanged: String
    var attributes: [String:Any]
    var memberUsers: Set<TwitchChatUser>
    var bannedUsers: Set<TwitchChatUser>
    var modeAttributes: [String:Any]
    var memberModes: [String:Any]
    var disciplineMemberModes: [String:Any]
    var mode: Int
    var hash: Int
    
    init(connection: TwitchChatConnection,
         id: String = "",
         name: String = "",
         dateJoined: String = "",
         dateParted: String = "",
         topic: String = "",
         dateTopicChanged: String = "",
         attributes: [String : Any] = [:],
         memberUsers: Set<TwitchChatUser> = [],
         bannedUsers: Set<TwitchChatUser> = [],
         modeAttributes: [String : Any] = [:],
         memberModes: [String : Any] = [:],
         disciplineMemberModes: [String : Any] = [:],
         mode: Int = -1,
         hash: Int = -1) {
        self.connection = connection
        self.id = id
        self.name = name
        self.dateJoined = dateJoined
        self.dateParted = dateParted
        self.topic = topic
        self.dateTopicChanged = dateTopicChanged
        self.attributes = attributes
        self.memberUsers = memberUsers
        self.bannedUsers = bannedUsers
        self.modeAttributes = modeAttributes
        self.memberModes = memberModes
        self.disciplineMemberModes = disciplineMemberModes
        self.mode = mode
        self.hash = hash
    }*/
}
