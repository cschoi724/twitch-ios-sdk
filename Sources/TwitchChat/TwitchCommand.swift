//
//  TwitchCommand.swift
//
//
//  Created by cschoi on 12/13/23.
//

import Foundation

enum TwitchChatCommand {
    case join(channel: String) // 채널 들어가기
    case pass(token: String)
    case nick(userName: String)
    case privmsg(channel: String, text: String) // 메시지 입력
    case part(channel: String) // 채널 떠나기
    case pong(text: String)
    case cap

    var execute: String {
        switch self {
        case .pass(let token):
            return "PASS oauth:\(token)"
        case .nick(let userName):
            return "NICK \(userName)"
        case .join(let channel):
            return "JOIN #\(channel)"
        case .part(let channel):
            return "PART #\(channel)"
        case .privmsg(let channel, let text):
            return "PRIVMSG #\(channel) :\(text)"
            // PRIVMSG #<channel name> :This is a sample message
            
        case .pong(let text):
            return "PONG :\(text)"
        case .cap:
            return "CAP REQ :twitch.tv/membership twitch.tv/tags twitch.tv/commands"
        }
    }
}
