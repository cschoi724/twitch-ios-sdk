//
//  TwitchUserNotice.swift
//
//
//  Created by cschoi on 12/13/23.
//

import Foundation

public struct TwitchUserNotice {
    // @badge-info=;badges=staff/1,broadcaster/1,turbo/1;color=#008000;display-name=ronni;emotes=;id=db25007f-7a18-43eb-9379-80131e44d633;login=ronni;mod=0;msg-id=resub;msg-param-cumulative-months=6;msg-param-streak-months=2;msg-param-should-share-streak=1;msg-param-sub-plan=Prime;msg-param-sub-plan-name=Prime;room-id=12345678;subscriber=1;system-msg=ronni\shas\ssubscribed\sfor\s6\smonths!;tmi-sent-ts=1507246572675;turbo=1;user-id=87654321;user-type=staff :tmi.twitch.tv USERNOTICE #dallas :Great stream -- keep it up!
    // @badge-info=;badges=staff/1,premium/1;color=#0000FF;display-name=TWW2;emotes=;id=e9176cd8-5e22-4684-ad40-ce53c2561c5e;login=tww2;mod=0;msg-id=subgift;msg-param-months=1;msg-param-recipient-display-name=Mr_Woodchuck;msg-param-recipient-id=55554444;msg-param-recipient-name=mr_woodchuck;msg-param-sub-plan-name=House\sof\sNyoro~n;msg-param-sub-plan=1000;room-id=19571752;subscriber=0;system-msg=TWW2\sgifted\sa\sTier\s1\ssub\sto\sMr_Woodchuck!;tmi-sent-ts=1521159445153;turbo=0;user-id=87654321;user-type=staff :tmi.twitch.tv USERNOTICE #forstycup
    // @badge-info=;badges=turbo/1;color=#9ACD32;display-name=TestChannel;emotes=;id=3d830f12-795c-447d-af3c-ea05e40fbddb;login=testchannel;mod=0;msg-id=raid;msg-param-displayName=TestChannel;msg-param-login=testchannel;msg-param-viewerCount=15;room-id=33332222;subscriber=0;system-msg=15\sraiders\sfrom\sTestChannel\shave\sjoined\n!;tmi-sent-ts=1507246572675;turbo=1;user-id=123456;user-type= :tmi.twitch.tv USERNOTICE #othertestchannel
    // @badge-info=;badges=;color=;display-name=SevenTest1;emotes=30259:0-6;id=37feed0f-b9c7-4c3a-b475-21c6c6d21c3d;login=seventest1;mod=0;msg-id=ritual;msg-param-ritual-name=new_chatter;room-id=87654321;subscriber=0;system-msg=Seventoes\sis\snew\shere!;tmi-sent-ts=1508363903826;turbo=0;user-id=77776666;user-type= :tmi.twitch.tv USERNOTICE #seventoes :HeyGuys
    
    public let msgId: String
    public let msgParams: [String: String]
    public let login: String
    public let systemMsg: String    
    public let id: String
    public let roomId: String
    public let channel: String
    public var user: TwitchChatUser
    public let emotes: [TwitchChatEmote]
    public let message: String
    public let timestamp: Date?
    
    init(
        msgId: String,
        msgParams: [String: String],
        login: String,
        systemMsg: String,
        id: String,
        roomId: String,
        channel: String,
        user: TwitchChatUser,
        emotes: [TwitchChatEmote],
        message: String,
        timestamp: Date?
    ) {
        self.msgId = msgId
        self.msgParams = msgParams
        self.login = login
        self.systemMsg = systemMsg
        self.id = id
        self.roomId = roomId
        self.channel = channel
        self.user = user
        self.emotes = emotes
        self.message = message
        self.timestamp = timestamp
    }
}
