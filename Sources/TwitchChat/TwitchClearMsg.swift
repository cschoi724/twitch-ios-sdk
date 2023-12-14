//
//  TwitchClearMsg.swift
//
//
//  Created by cschoi on 12/13/23.
//

import Foundation

struct TwitchClearMsg {
    // @login=ronni;room-id=;target-msg-id=abc-123-def;tmi-sent-ts=1642720582342 :tmi.twitch.tv CLEARMSG #dallas :HeyGuys
   /*
    login    The name of the user who sent the message.
    room-id    Optional. The ID of the channel (chat room) where the message was removed from.
    target-msg-id    A UUID that identifies the message that was removed.
    tmi-sent-ts    The UNIX timestamp.
    */
    var login: String
    var roomId: String
    var targetMsgId: String
    var sendDate: Date
    
    init(
        login: String,
        roomId: String,
        targetMsgId: String,
        sendDate: Date
    ) {
        self.login = login
        self.roomId = roomId
        self.targetMsgId = targetMsgId
        self.sendDate = sendDate
    }
}
