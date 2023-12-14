//
//  TwitchNotice.swift
//
//
//  Created by cschoi on 12/13/23.
//
import Foundation

public struct TwitchNotice {
    // @msg-id=delete_message_success :tmi.twitch.tv NOTICE #bar :The message from foo is now deleted.
    // @msg-id=whisper_restricted;target-user-id=12345678 :tmi.twitch.tv NOTICE #bar :Your settings prevent you from sending this whisper.
    public let msgId: String
    public let targetUserId: String
    public let channel: String
    public let message: String
    
    init(
        msgId: String,
        targetUserId: String,
        channel: String = "",
        message: String = ""
    ) {
        self.msgId = msgId
        self.targetUserId = targetUserId
        self.channel = channel
        self.message = message
    }
}
