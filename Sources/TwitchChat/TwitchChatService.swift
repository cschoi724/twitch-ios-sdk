//
//  TwitchChatService.swift
//
//
//  Created by cschoi on 12/13/23.
//

import Foundation

public protocol TwitchChatService {
    var delegate: TwitchChatDelegate? { get set }
    
    func join(_ channel: String, id: String, pass: String)
    func part()
    func sendChat(_ message: String)
    // func sendChat(_ message: String, ack: ((TwitchChatMessage)->Void)?)
}

public protocol TwitchChatDelegate: AnyObject {
    func roomJoined(_ room: TwitchRoom, byUser user: TwitchChatUser)
    func roomParted(_ room: TwitchRoom)
    func room(_ room: TwitchRoom, joinedUser loginId: String)
    func room(_ room: TwitchRoom, partedUser loginId: String)
    func room(_ room: TwitchRoom, send message: TwitchChatMessage)
    func room(_ room: TwitchRoom, receive message: TwitchChatMessage)
    func room(_ room: TwitchRoom, notice message: TwitchNotice)
    func room(_ room: TwitchRoom, userNotice message: TwitchUserNotice)
    func room(_ room: TwitchRoom, changed state: TwitchRoomState)
    func room(_ room: TwitchRoom, clearChat userId: String)
    func room(_ room: TwitchRoom, clearMsg msgId: String)
}

class DefaultTwitchChatService: TwitchChatService {
    private var client: WSClient
    private let messageParser: TwitchMessageParser
    public weak var delegate: TwitchChatDelegate?
    private var room: TwitchRoom!
    private var sendText: String?
    
    init(
        config: WebSocketConfiguration,
        messageParser: TwitchMessageParser = DefaultTwitchMessageParser()
    ) {
        self.messageParser = messageParser
        self.client = DefaultWebSocketClient(config: config)
        self.client.delegate = self
    }
    
    func sendCommand(_ command: TwitchChatCommand) -> String {
        return command.execute
    }
    
    func join(_ channel: String, id: String, pass: String) {
        let connection = TwitchChatConnection(channel: channel, name: id, token: pass)
        self.room = TwitchRoom(connection: connection)
        self.client.connect()
    }
    
    func part() {
        if let room = self.room {
            client.write(sendCommand(.part(channel: room.connection.channel)))
            delegate?.roomParted(room)
            self.room = nil
        }
        client.disconnect()
        
        /*client.write(sendCommand(.part(channel: room.connection.channel)))
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.5,
            execute: { [weak self] in
                guard let self = self else { return }
                self.delegate?.roomParted(self.room)
                self.client.disconnect()
                self.room = nil
            }
        )*/
    }
    
    func sendChat(_ message: String) {
        guard let room = self.room else { return }
        sendText = message
        client.write(sendCommand(.privmsg(channel: room.connection.channel, text: message)))
    }
}

extension DefaultTwitchChatService: WSClientDelegate {
    func clientConnected(_ client: WSClient) {
        guard let room = self.room else { return }
        client.write(sendCommand(.cap))
        client.write(sendCommand(.pass(token: room.connection.token)))
        client.write(sendCommand(.nick(userName: room.connection.name)))
        client.write(sendCommand(.join(channel: room.connection.channel)))
    }
    
    func clientDisconnected(_ client: WSClient) {}
    
    func client(_ client: WSClient, error: Error?) { }
    
    func clientReconnected(_ client: WSClient) { }
    
    func client(_ client: WSClient, message rawMessage: String) {
        for component in rawMessage.components(separatedBy: "\r\n") {
            parseMessage(component)
        }
    }
    
    func parseMessage(_ rawMessage: String) {
        // print(rawMessage)
        guard let room = self.room else { return }
        guard let twitchMessage = TwitchMessage(rawMessage: rawMessage) else {
            return
        }
        let command = TwitchIRCCommand(rawValue: twitchMessage.command)
        switch command {
        case .CLEARCHAT:
            let clearChat = messageParser.parseClearChat(twitchMessage: twitchMessage)
            delegate?.room(room, clearChat: clearChat.targetUserId)
        case .CLEARMSG:
            let clearMsg = messageParser.parseClearMsg(twitchMessage: twitchMessage)
            delegate?.room(room, clearMsg: clearMsg.targetMsgId)
        case .GLOBALUSERSTATE:
            let user = messageParser.parseChatUser(twitchMessage: twitchMessage)
            self.room.user = user
            delegate?.roomJoined(room, byUser: user)
        case .NOTICE:
            let notice = messageParser.parseNotice(twitchMessage: twitchMessage)
            delegate?.room(room, notice: notice)
        case .PRIVMSG:
            let chatMessage = messageParser.parseChatMessage(twitchMessage: twitchMessage)
            delegate?.room(room, receive: chatMessage)
        case .ROOMSTATE:
            let roomState = messageParser.parseRoomState(twitchMessage: twitchMessage)
            self.room.roomState = roomState
            delegate?.room(room, changed: roomState)
        case .USERNOTICE:
            let userNotice = messageParser.parseUserNotice(twitchMessage: twitchMessage)
            if userNotice.msgId.contains("announcement") {
                delegate?.room(room, userNotice: userNotice)
            }
        case .USERSTATE:
            var chatMessage = messageParser.parseChatMessage(twitchMessage: twitchMessage)
            if let roomUser = self.room.user,
               roomUser.displayName == chatMessage.user.displayName {
                if let text = sendText,
                   chatMessage.id.isEmpty == false {
                    chatMessage.message = text
                    delegate?.room(room, send: chatMessage)
                }
            }
        case .HOSTTARGET:
            break
        case .WHISPER:
            break
        case .PING:
            client.write(sendCommand(.pong(text: twitchMessage.message ?? "")))
        case .RECONNECT:
            break
        case .JOIN:
            if let id = twitchMessage.loginId {
                delegate?.room(room, joinedUser: id)
            }
        case .PART:
            if let id = twitchMessage.loginId {
                delegate?.room(room, partedUser: id)
            }
        case .LOGINSUCCESS:
            break
        case .UNKNOWN:
            break
        }
    }
}
