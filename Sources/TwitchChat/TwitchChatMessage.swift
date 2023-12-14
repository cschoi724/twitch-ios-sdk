//
//  TwitchChatMessage.swift
//
//
//  Created by cschoi on 12/13/23.
//

import Foundation

public struct TwitchChatMessage {
    // @badge-info=;badges=;client-nonce=0a4d6a1b41c9b8f5bd4dc0d2a4f55bc6;color=#0000FF;display-name=dohun8832j;emotes=;first-msg=0;flags=;id=15027008-4377-4d58-a95c-704bdc567ccc;mod=0;returning-chatter=0;room-id=701887537;subscriber=0;tmi-sent-ts=1677136067044;turbo=0;user-id=884570562;user-type= :dohun8832j!dohun8832j@dohun8832j.tmi.twitch.tv PRIVMSG #dohun87 :1232323
    // @badge-info=;badges=moderator/1;client-nonce=d178bc964587f189b508a49f159c8754;color=#0000FF;display-name=dohun8832j;emotes=;first-msg=0;flags=;id=7b188323-54bc-49b1-add4-5d002ca0b790;mod=1;reply-parent-display-name=dohun8832;reply-parent-msg-body=131314;reply-parent-msg-id=99122e77-23c1-46c8-a77a-fc4963111d18;reply-parent-user-id=884213867;reply-parent-user-login=dohun8832;returning-chatter=0;room-id=701887537;subscriber=0;tmi-sent-ts=1677136316644;turbo=0;user-id=884570562;user-type=mod :dohun8832j!dohun8832j@dohun8832j.tmi.twitch.tv PRIVMSG #dohun87 :@dohun8832 12323242425
    public struct ReplyParent {
        public let id: String
        public let userId: String
        public let displayName: String
        public let message: String
        
        init(
            id: String = "",
            userId: String = "",
            displayName: String = "",
            message: String = ""
        ) {
            self.id = id
            self.userId = userId
            self.displayName = displayName
            self.message = message
        }
    }
    
    public let id: String
    public let roomId: String
    public let channel: String
    public var user: TwitchChatUser
    public let emotes: [TwitchChatEmote]
    public var message: String
    public let mention: [String]
    public let timestamp: Date?
    public var replyParent: ReplyParent?
    
    init(
        id: String,
        roomId: String,
        channel: String,
        user: TwitchChatUser,
        emotes: [TwitchChatEmote] = [],
        message: String,
        mention: [String] = [],
        timestamp: Date? = nil,
        replyParent: ReplyParent? = nil
    ) {
        self.id = id
        self.roomId = roomId
        self.channel = channel
        self.user = user
        self.emotes = emotes
        self.message = message
        self.mention = mention
        self.timestamp = timestamp
        self.replyParent = replyParent
    }
    
    /*
     init?(twitchMessage: TwitchMessage){
         let tags = twitchMessage.tags
         let prefix = twitchMessage.prefix
         let channel = twitchMessage.arguments[0]
         let message = twitchMessage.arguments[1]
         let username = tags["display-name"] ?? tags["login"] ?? ""
         let emotes = parseEmotes(from: tags["emotes"] ?? "", with: "")
         let badges = parseBadges(from: tags["badges"] ?? "")
         let userType = parseUserType(tags["user-type"] ?? "")
         let timestamp = Date(timeIntervalSince1970: Double(tags["tmi-sent-ts"] ?? "0")!)
         
         self.channel = channel
         self.username = username
         self.message = message
         self.emotes = emotes
         self.badges = badges
         self.userType = userType
         self.timestamp = timestamp
     }
     
     private func parseBadges(from badgesString: String?) -> [TwitchChatBadge] {
         guard let badgesString = badgesString else {
             return []
         }
         let badges: [TwitchChatBadge] = badgesString.split(separator: ",")
             .compactMap { badgeString in
                 let components = badgeString.split(separator: "/")
                 guard components.count == 2,
                       let badgeName = TwitchChatBadge.Name(rawValue: String(components[0])),
                       let badgeVersion = Int(components[1]) else {
                     return nil
                 }
                 
                 return TwitchChatBadge(name: badgeName, version: badgeVersion)
             }
         
         return badges
     }
     
     private func parseEmotes(from message: String, with emotesString: String?) -> [TwitchEmote] {
         guard let emotesString = emotesString else {
             return []
         }
         
         let emotes: [TwitchEmote] = emotesString.split(separator: "/")
             .compactMap { emote -> TwitchEmote? in
                 let components = emote.split(separator: ":")
                 guard components.count == 2,
                       let emoteID = Int(components[0]),
                       let ranges = components[1].split(separator: ",") as? [Substring] else {
                     return nil
                 }
                 
                 let emoteName = String(message[Range(ranges[0].split(separator: "-").first!...ranges[0].split(separator: "-").last!)])
                 let emoteInstances = ranges.map { range in
                     let startIndex = message.index(message.startIndex, offsetBy: Int(range.split(separator: "-")[0])!)
                     let endIndex = message.index(startIndex, offsetBy: range.count)
                     return TwitchEmoteInstance(name: emoteName, range: startIndex..<endIndex)
                 }
                 
                 return TwitchEmote(id: emoteID, name: emoteName, instances: emoteInstances)
             }
         
         return emotes
     }
     
     func parseUserType(_ rawMessage: String) -> UserType {
         if rawMessage.contains("broadcaster/1") {
             return .broadcaster
         } else if rawMessage.contains("global_mod") {
             return .globalMod
         } else if rawMessage.contains("admin") {
             return .admin
         } else if rawMessage.contains("staff") {
             return .staff
         } else {
             return .normal
         }
     }
     
     */
}
