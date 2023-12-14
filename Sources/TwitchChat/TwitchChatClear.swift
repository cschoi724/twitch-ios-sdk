//
//  TwitchChatClear.swift
//
//
//  Created by cschoi on 12/13/23.
//

import Foundation

struct TwitchClearChat {
    // @room-id=12345678;target-user-id=87654321;tmi-sent-ts=1642715756806 :tmi.twitch.tv CLEARCHAT #dallas :ronni
    // @room-id=12345678;tmi-sent-ts=1642715695392 :tmi.twitch.tv CLEARCHAT #dallas
    // @ban-duration=350;room-id=12345678;target-user-id=87654321;tmi-sent-ts=1642719320727 :tmi.twitch.tv CLEARCHAT #dallas :ronni
    // @room-id=701887537;target-user-id=884213867;tmi-sent-ts=1677122293976 :tmi.twitch.tv CLEARCHAT #dohun87 :dohun8832
    /*
     ban-duration :   Optional. The message includes this tag if the user was put in a timeout. The tag contains the duration of the timeout, in seconds.
     room-id :   The ID of the channel where the messages were removed from.
     target-user-id :   Optional. The ID of the user that was banned or put in a timeout. The user was banned if the message doesn’t include the ban-duration tag.
     tmi-sent-ts :   The UNIX timestamp.
     */
    let roomId: String
    let targetUserId: String
    let duration: Int
    let sendDate: Date
    
    init(
        roomId: String,
        targetUserId: String,
        duration: Int,
        sendDate: Date
    ) {
        self.roomId = roomId
        self.targetUserId = targetUserId
        self.duration = duration
        self.sendDate = sendDate
    }
}
