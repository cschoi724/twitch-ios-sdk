//
//  TwitchMessageParser.swift
//
//
//  Created by cschoi on 12/13/23.
//

import Foundation

protocol TwitchMessageParser {
    func parseChatMessage(twitchMessage: TwitchMessage) -> TwitchChatMessage
    func parseRoomState(twitchMessage: TwitchMessage) -> TwitchRoomState
    func parseChatUser(twitchMessage: TwitchMessage) -> TwitchChatUser
    func parseClearChat(twitchMessage: TwitchMessage) -> TwitchClearChat
    func parseNotice(twitchMessage: TwitchMessage) -> TwitchNotice
    func parseClearMsg(twitchMessage: TwitchMessage) -> TwitchClearMsg
    func parseUserNotice(twitchMessage: TwitchMessage) -> TwitchUserNotice
}

class DefaultTwitchMessageParser: TwitchMessageParser {
    func parseChatMessage(twitchMessage: TwitchMessage) -> TwitchChatMessage {
        let tags = twitchMessage.tags
        // let prefix = twitchMessage.prefix
        let channel = twitchMessage.channel ?? "" // .arguments[0]
        let message = twitchMessage.message ?? "" // .arguments[1]

        let id = tags["id"] ?? ""
        let roomId = tags["room-id"] ?? ""
        let user = parseChatUser(twitchMessage: twitchMessage)
        let emotes = parseEmotes(from: tags["emotes"], in: message)
        let timestamp = Date(timeIntervalSince1970: Double(tags["tmi-sent-ts"] ?? "0") ?? 0)
        
        return TwitchChatMessage(
            id: id,
            roomId: roomId,
            channel: channel,
            user: user,
            emotes: emotes,
            message: message,
            timestamp: timestamp
        )
    }
    
    func parsUserState() {
        // @badge-info=;badges=;color=;display-name=젤라빈;emote-sets=0;id=44bf1cdc-db8c-4085-8847-9f120d8a16d5;mod=0;subscriber=0;user-type= :tmi.twitch.tv USERSTATE #portialyn
    }
    
    func parseChatUser(twitchMessage: TwitchMessage) -> TwitchChatUser {
        let tags = twitchMessage.tags
        
        let prefix = twitchMessage.prefix
        let loginId = prefix?.components(separatedBy: "!").first ?? ""
        
        return TwitchChatUser(
            id: tags["user-id"] ?? "",
            loginId: loginId,
            userType: parseUserType(tags["user-type"]),
            badges: parseBadges(from: tags["emotes"]),
            color: tags["color"] ?? "",
            displayName: tags["display-name"] ?? tags["login"] ?? "",
            subscriber: (tags["subscriber"] ?? "") == "1",
            turbo: (tags["turbo"] ?? "") == "1"
        )
    }
    
    func parseRoomState(twitchMessage: TwitchMessage) -> TwitchRoomState {
        // @emote-only=0;followers-only=0;r9k=0;slow=0;subs-only=0
        let tags = twitchMessage.tags
        let id = tags["user-id"] ?? ""
        let channel = twitchMessage.channel ?? ""
        let emoteOnly = Int(tags["emote-only"] ?? "0") ?? 0
        let followerOnly = Int(tags["followers-only"] ?? "0") ?? 0
        let r9k = Int(tags["r9k"] ?? "0") ?? 0
        let slow = Int(tags["slow"] ?? "0") ?? 0
        let subscriberOnly = Int(tags["subs-only"] ?? "0") ?? 0
        
        return TwitchRoomState(
            id: id,
            channel: channel,
            emoteOnly: emoteOnly,
            followerOnly: followerOnly,
            r9k: r9k,
            slow: slow,
            subscriberOnly: subscriberOnly
        )
    }
    
    func parseNotice(twitchMessage: TwitchMessage) -> TwitchNotice {
        // @msg-id=whisper_restricted;target-user-id=12345678 :tmi.twitch.tv NOTICE #bar :Your settings prevent you from sending this whisper.
        let tags = twitchMessage.tags
        let msgId = tags["msg-id"] ?? ""
        let targetUserId = tags["target-user-id"] ?? ""
        let channel = twitchMessage.channel ?? ""// twitchMessage.arguments[0]
        let message = twitchMessage.message ?? "" // twitchMessage.arguments[1]
        
        return TwitchNotice(
            msgId: msgId,
            targetUserId: targetUserId,
            channel: channel,
            message: message
        )
    }
    
    func parseClearChat(twitchMessage: TwitchMessage) -> TwitchClearChat {
        // @room-id=12345678;target-user-id=87654321;tmi-sent-ts=1642715756806 :tmi.twitch.tv CLEARCHAT #dallas :ronni
        // @ban-duration=350;room-id=12345678;target-user-id=87654321;tmi-sent-ts=1642719320727 :tmi.twitch.tv CLEARCHAT #dallas :ronni
        let tags = twitchMessage.tags
        let roomId = tags["room-id"] ?? ""
        let targetUserId = tags["target-user-id"] ?? ""
        let duration = Int(tags["ban-duration"] ?? "0") ?? 0
        let sendDate = Date(timeIntervalSince1970: Double(tags["tmi-sent-ts"] ?? "0") ?? 0)
        
        return TwitchClearChat(
            roomId: roomId,
            targetUserId: targetUserId,
            duration: duration,
            sendDate: sendDate
        )
    }
    
    func parseClearMsg(twitchMessage: TwitchMessage) -> TwitchClearMsg {
        // @login=ronni;room-id=;target-msg-id=abc-123-def;tmi-sent-ts=1642720582342 :tmi.twitch.tv CLEARMSG #dallas :HeyGuys
        let tags = twitchMessage.tags
        let login = tags["login"] ?? ""
        let roomId = tags["room-id"] ?? ""
        let targetMsgId = tags["target-msg-id"] ?? ""
        let sendDate = Date(timeIntervalSince1970: Double(tags["tmi-sent-ts"] ?? "0") ?? 0)
        
        return TwitchClearMsg(
            login: login,
            roomId: roomId,
            targetMsgId: targetMsgId,
            sendDate: sendDate
        )
    }
    
    func parseUserNotice(twitchMessage: TwitchMessage) -> TwitchUserNotice {
        let tags = twitchMessage.tags
        let channel = twitchMessage.channel ?? ""
        let message = twitchMessage.message ?? ""

        let msgId = tags["msg-id"] ?? ""
        let msgParams = parseMsgParam(tags)
        let systemMsg = tags["system-msg"] ?? ""
        let id = tags["id"] ?? ""
        let login = tags["login"] ?? ""
        let roomId = tags["room-id"] ?? ""
        let user = parseChatUser(twitchMessage: twitchMessage)
        let emotes = parseEmotes(from: tags["emotes"], in: message)
        let timestamp = Date(timeIntervalSince1970: Double(tags["tmi-sent-ts"] ?? "0") ?? 0)
        
        return TwitchUserNotice(
            msgId: msgId,
            msgParams: msgParams,
            login: login,
            systemMsg: systemMsg,
            id: id,
            roomId: roomId,
            channel: channel,
            user: user,
            emotes: emotes,
            message: message,
            timestamp: timestamp
        )
    }
}

extension DefaultTwitchMessageParser {
    private func parseBadges(from rawString: String?) -> [TwitchChatBadge] {
        guard let rawString = rawString else {
            return []
        }
        
        return rawString.split(separator: ",")
            .compactMap { badgeString -> TwitchChatBadge? in
                let components = badgeString.split(separator: "/")
                guard components.count == 2,
                      let badgeName = TwitchChatBadge.Name(rawValue: String(components[0])) else {
                    return nil
                }
                let badgeVersion = String(components[1])
                return TwitchChatBadge(name: badgeName, version: badgeVersion)
            }
    }
    private func parseEmotes(from emoteString: String?, in message: String) -> [TwitchChatEmote] {
        // emotes=25:0-4,12-16/1902:6-10;
        guard let emoteString = emoteString else {
            return []
        }
        let emotePairs = emoteString.components(separatedBy: "/")
        var emotes: [TwitchChatEmote] = []
        
        for emotePair in emotePairs {
            let components = emotePair.components(separatedBy: ":")
            
            guard components.count == 2,
                  let emoteID = components.first,
                  let rangesString = components.last else {
                continue
            }
            
            let ranges = rangesString.components(separatedBy: ",")
            for range in ranges {
                let rangeComponents = range.components(separatedBy: "-")
                guard rangeComponents.count == 2,
                      let startIndex = Int(rangeComponents[0]),
                      let endIndex = Int(rangeComponents[1]) else {
                    continue
                }
                
                let emote = TwitchChatEmote(id: emoteID, indices: [startIndex, endIndex])
                emotes.append(emote)
            }
        }
        
        // emotes 를 시작 위치를 기준으로 정렬
        emotes.sort { $0.indices[0] < $1.indices[0] }
        
        return emotes
    }
   
    private func parseUserType(_ rawMessage: String?) -> TwitchUserType {
        guard let rawMessage = rawMessage else {
            return .normal
        }
        if rawMessage.contains("broadcaster") {
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
    
    private func parseMsgParam(_ tags: [String: String]) -> [String: String] {
        var msgParms: [String: String] = [:]
        tags.forEach {
            if $0.key.contains("msg-param") {
                msgParms.updateValue($0.value, forKey: $0.key)
            }
        }
        
        return msgParms
    }
}
