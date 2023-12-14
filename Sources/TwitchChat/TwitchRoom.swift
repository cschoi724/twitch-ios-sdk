//
//  TwitchRoom.swift
//
//
//  Created by cschoi on 12/13/23.
//

import Foundation

public class TwitchRoom {
    public var connection: TwitchChatConnection
    public var roomState: TwitchRoomState?
    public var user: TwitchChatUser?
    
    public var userList: [TwitchChatUser]
    public var banUserList: [TwitchChatUser]
    public var messages: [TwitchChatMessage]
    
    init(
        connection: TwitchChatConnection,
        roomState: TwitchRoomState? = nil,
        user: TwitchChatUser? = nil,
        userList: [TwitchChatUser] = [],
        banUserList: [TwitchChatUser] = [],
        messages: [TwitchChatMessage] = []
    ) {
        self.connection = connection
        self.roomState = roomState
        self.user = user
        self.userList = userList
        self.banUserList = banUserList
        self.messages = messages
    }
}
