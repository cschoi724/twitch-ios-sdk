//
//  TwitchMessage.swift
//
//
//  Created by cschoi on 12/13/23.
//

import Foundation

struct TwitchMessage {
    let tags: [String: String]
    let prefix: String?
    let loginId: String?
    let command: String
    let channel: String?
    let message: String?
    
    init?(rawMessage: String) {
        // @badge-info=;badges=;color=;display-name=ChatGPT;emotes=;flags=;id=b64a1c01-4b4d-4f4e-9a29-215dca45f862;mod=0;room-id=123456;subscriber=0;tmi-sent-ts=1646139366523;turbo=0;user-id=987654;user-type= :chat!chat@chat.twitch.tv PRIVMSG #channel :Hello World
        // @badges=staff/1,broadcaster/1,turbo/1;color=#FF0000;display-name=PetsgomOO;emote-only=1;emotes=33:0-7;flags=0-7:A.6/P.6,25-36:A.1/I.2;id=c285c9ed-8b1b-4702-ae1c-c64d76cc74ef;mod=0;room-id=81046256;subscriber=0;turbo=0;tmi-sent-ts=1550868292494;user-id=81046256;user-type=staff :petsgomoo!petsgomoo@petsgomoo.tmi.twitch.tv PRIVMSG #petsgomoo :DansGame
        // @msg-id=whisper_restricted;target-user-id=12345678 :tmi.twitch.tv NOTICE #bar :Your settings prevent you from sending this whisper.
        // PING :tmi.twitch.tv
        // @badge-info=;badges=staff/1,premium/1;color=#0000FF;display-name=TWW2;emotes=;id=e9176cd8-5e22-4684-ad40-ce53c2561c5e;login=tww2;mod=0;msg-id=subgift;msg-param-months=1;msg-param-recipient-display-name=Mr_Woodchuck;msg-param-recipient-id=55554444;msg-param-recipient-name=mr_woodchuck;msg-param-sub-plan-name=House\sof\sNyoro~n;msg-param-sub-plan=1000;room-id=19571752;subscriber=0;system-msg=TWW2\sgifted\sa\sTier\s1\ssub\sto\sMr_Woodchuck!;tmi-sent-ts=1521159445153;turbo=0;user-id=87654321;user-type=staff :tmi.twitch.tv USERNOTICE #forstycup
        // @login=ronni;room-id=;target-msg-id=abc-123-def;tmi-sent-ts=1642720582342 :tmi.twitch.tv CLEARMSG #dallas :HeyGuys
        // @badge-info=;badges=moderator/1;client-nonce=d178bc964587f189b508a49f159c8754;color=#0000FF;display-name=dohun8832j;emotes=;first-msg=0;flags=;id=7b188323-54bc-49b1-add4-5d002ca0b790;mod=1;reply-parent-display-name=dohun8832;reply-parent-msg-body=131314;reply-parent-msg-id=99122e77-23c1-46c8-a77a-fc4963111d18;reply-parent-user-id=884213867;reply-parent-user-login=dohun8832;returning-chatter=0;room-id=701887537;subscriber=0;tmi-sent-ts=1677136316644;turbo=0;user-id=884570562;user-type=mod :dohun8832j!dohun8832j@dohun8832j.tmi.twitch.tv PRIVMSG #dohun87 :@dohun8832 12323242425
        /* @badge-info=;badges=;color=;display-name=젤라빈;emote-sets=0;user-id=124426360;user-type= :tmi.twitch.tv GLOBALUSERSTATE


        :jellabean724!jellabean724@jellabean724.tmi.twitch.tv JOIN #runner0608

        @badge-info=;badges=;color=;display-name=젤라빈;emote-sets=0;mod=0;subscriber=0;user-type= :tmi.twitch.tv USERSTATE #runner0608

        @emote-only=0;followers-only=0;r9k=0;room-id=149397653;slow=0;subs-only=0 :tmi.twitch.tv ROOMSTATE #runner0608*/
        // Twitch IRC 프로토콜에 따라 메시지를 파싱하여 DTO 객체를 생성합니다.
        var rawTagsComponent: String?
        var rawSourceComponent: String?
        var rawCommandComponent: String?
        var rawChannelComponent: String?
        var rawMessageComponent: String?
        
        var idx = rawMessage.startIndex
        guard rawMessage.isEmpty == false else { return nil }
        
        if rawMessage[idx] == "@" {  // The message includes tags.
            if let endIndex = rawMessage[idx...].firstIndex(of: " ") {
                let startIdex = idx
                rawTagsComponent = String(rawMessage[startIdex..<endIndex])
                idx = rawMessage.index(endIndex, offsetBy: 1)
            }
        }
        
        if rawMessage[idx] == ":"{
            if let endIndex = rawMessage[idx...].firstIndex(of: " ") {
                let startIdex = idx
                rawSourceComponent = String(rawMessage[startIdex..<endIndex])
                idx = rawMessage.index(endIndex, offsetBy: 1)
            }
        }
        
        if rawCommandComponent == nil {
            if let endIndex = rawMessage[idx...].firstIndex(of: " ") {
                let startIdex = idx
                rawCommandComponent = String(rawMessage[startIdex..<endIndex])
                idx = rawMessage.index(endIndex, offsetBy: 1)
            } else {
                let endIndex = rawMessage[idx...].endIndex
                let startIdex = idx
                rawCommandComponent = String(rawMessage[startIdex..<endIndex])
            }
        }
        
        if rawMessage[idx] == "#"{
            if let endIndex = rawMessage[idx...].firstIndex(of: " ") {
                let startIdex = idx
                rawChannelComponent = String(rawMessage[startIdex..<endIndex])
                idx = rawMessage.index(endIndex, offsetBy: 1)
            } else {
                let endIndex = rawMessage[idx...].endIndex
                let startIdex = idx
                rawChannelComponent = String(rawMessage[startIdex..<endIndex])
            }
        }
        
        if rawMessage[idx] == ":"{
            let endIndex = rawMessage[idx...].endIndex
            let startIdex = idx
            rawMessageComponent = String(rawMessage[startIdex..<endIndex])
        }
        
        guard let unwrappedCommand = rawCommandComponent else {
            return nil
        }
        self.command = unwrappedCommand
        self.prefix = rawSourceComponent?
            .replacingOccurrences(of: ":", with: "")
        self.loginId = self.prefix?.components(separatedBy: "!").first
        self.channel = rawChannelComponent?
            .replacingOccurrences(of: "#", with: "")
        self.message = rawMessageComponent?
            .replacingOccurrences(of: ":", with: "")
        
        if let tagString = rawTagsComponent {
            let tags = tagString.dropFirst().components(separatedBy: ";")
            var tagDict: [String: String] = [:]
            
            for tag in tags {
                let pair = tag.components(separatedBy: "=")
                if pair.count == 2 {
                    tagDict[pair[0]] = pair[1]
                } else {
                    tagDict[pair[0]] = ""
                }
            }
            self.tags = tagDict
        } else {
            self.tags = [:]
        }
    }
}

/*init?(rawMessage: String) {
    //@badge-info=;badges=;color=;display-name=ChatGPT;emotes=;flags=;id=b64a1c01-4b4d-4f4e-9a29-215dca45f862;mod=0;room-id=123456;subscriber=0;tmi-sent-ts=1646139366523;turbo=0;user-id=987654;user-type= :chat!chat@chat.twitch.tv PRIVMSG #channel :Hello World
    //@badges=staff/1,broadcaster/1,turbo/1;color=#FF0000;display-name=PetsgomOO;emote-only=1;emotes=33:0-7;flags=0-7:A.6/P.6,25-36:A.1/I.2;id=c285c9ed-8b1b-4702-ae1c-c64d76cc74ef;mod=0;room-id=81046256;subscriber=0;turbo=0;tmi-sent-ts=1550868292494;user-id=81046256;user-type=staff :petsgomoo!petsgomoo@petsgomoo.tmi.twitch.tv PRIVMSG #petsgomoo :DansGame
    //PING :tmi.twitch.tv
    //Twitch IRC 프로토콜에 따라 메시지를 파싱하여 DTO 객체를 생성합니다.
    let components = rawMessage.components(separatedBy: " ")
    var tagString: String?
    var prefix: String?
    var command: String?
    var channel: String?
    var message: String?
    var arguments: [String] = []
    
    for component in components {
        if component.hasPrefix("@") {
            tagString = component
        } else if component.hasPrefix(":") {
            if prefix == nil{
                prefix = component
            }else if message == nil{
                message = component
            }else{
                arguments.append(component)
            }
        } else if command == nil {
            command = component
        } else if component.hasPrefix("#") {
            channel = component
        }else {
            arguments.append(component)
        }
    }
    
    guard let unwrappedCommand = command else {
        return nil
    }
    
    self.command = unwrappedCommand
    self.prefix = prefix?.replacingOccurrences(of: ":", with: "")
    self.channel = channel?.replacingOccurrences(of: "#", with: "")
    self.message = message?.replacingOccurrences(of: ":", with: "")
    self.arguments = arguments
    
    if let tagString = tagString {
        let tags = tagString.dropFirst().components(separatedBy: ";")
        var tagDict: [String: String] = [:]
        
        for tag in tags {
            let pair = tag.components(separatedBy: "=")
            if pair.count == 2 {
                tagDict[pair[0]] = pair[1]
            } else {
                tagDict[pair[0]] = ""
            }
        }
        
        self.tags = tagDict
    } else {
        self.tags = [:]
    }
}*/

/*
 
 func parseMessage(message:String) -> [String:Any?]?{
     var parsedMessage: [String:Any?] = [:] // Contains the component parts.
     
     // The start index. Increments as we parse the IRC message.
     var idx = 0
     
     // The raw components of the IRC message.
     var rawTagsComponent: String?
     var rawSourceComponent: String?
     var rawCommandComponent: String?
     var rawParametersComponent: String?
     
     // If the message includes tags, get the tags component of the IRC message.
     if message[idx] == "@" {  // The message includes tags.
         if let index = message.firstIndex(of: " "){
             let endIdx = message.distance(
                 from: message.startIndex,
                 to: index
             )
             rawTagsComponent = String(message.slice(1, endIdx))
             idx = endIdx + 1 // Should now point to source colon (:).
         }
     }
     
     // Get the source component (nick and host) of the IRC message.
     // The idx should point to the source part; otherwise, it's a PING command.
     if message[idx] == ":" {
         idx += 1
         let startIdx = message.index(message.startIndex, offsetBy: idx)
         if let index = message[startIdx...].firstIndex(of: " "){
             let endIdx = message.distance(
                 from: message.startIndex,
                 to: index
             )
             rawSourceComponent = String(message.slice(idx, endIdx))
             idx = endIdx + 1 // Should point to the command part of the message.
         }
     }
     
     let startIdx = message.index(message.startIndex, offsetBy: idx)
     if let index = message[startIdx...].firstIndex(of: ":"){ // Looking for the parameters part of the message.
         var endIdx = message.distance(
             from: message.startIndex,
             to: index
         )
         if endIdx == -1{
             endIdx = message.count  // But not all messages include the parameters part.
         }
         
         rawCommandComponent = message.slice(idx, endIdx).trimmingCharacters(in: .whitespaces)
         
         if endIdx != message.count {  // Check if the IRC message contains a parameters component.
             idx = endIdx + 1           // Should point to the parameters part of the message.
             rawParametersComponent = String(message.slice(idx))
         }
         // Parse the command component of the IRC message.
         if let rawCommandComponent = rawCommandComponent{
             parsedMessage.updateValue(
                 parseCommand(rawCommandComponent),
                 forKey: "command"
             )
         }
     }
     
     if let command = parsedMessage["command"] as? [String:Any]{
         if let rawTagsComponent = rawTagsComponent{ // The IRC message contains tags.
             parsedMessage.updateValue(
                 parseTags(rawTagsComponent),
                 forKey: "tags"
             )
         }
         
         if let rawSourceComponent = rawSourceComponent{
             parsedMessage.updateValue(
                 parseSource(rawSourceComponent),
                 forKey: "source"
             )
         }
         
         if let rawParametersComponent = rawParametersComponent{
             parsedMessage.updateValue(
                 rawParametersComponent,
                 forKey: "parameter"
             )
             
             if rawParametersComponent[0] == "!"{
                 // The user entered a bot command in the chat window.
                 parsedMessage.updateValue(
                     parseParameters(
                         rawParametersComponent,
                         command: command
                     ),
                     forKey: "command"
                 )
             }
         }
     }else{
         return nil
     }
     
     return parsedMessage
 }

        
 func parseTags(_ tags: String) -> [String:Any]{
     // badge-info=;badges=broadcaster/1;color=#0000FF;...
     var dictParsedTags: [String:Any] = [:]  // Holds the parsed list of tags.
                                           // The key is the tag's name (e.g., color).
     let parsedTags = tags.split(separator: ";")
     parsedTags.forEach{ tag in
         let parsedTag = tag.split(separator: "=")
         let tagValue: String? = parsedTag[1].isEmpty ? nil : String(parsedTag[1])
         
         switch parsedTag[0]{
         case "badges", "badge-info":
             if let tagValue = tagValue {
                 var badge: [String:String] = [:]   // Holds the list of badge objects.
                                                 // The key is the badge's name (e.g., subscriber).
                 let badges = tagValue.split(separator: ",")
                 badges.forEach{ pair in
                     let badgeParts = pair.split(separator: "/")
                     badge.updateValue(
                         String(badgeParts[1]),
                         forKey: String(badgeParts[0])
                     )
                 }
                 dictParsedTags.updateValue(badge, forKey: String(parsedTag[0]))
             }
         case "emotes":
             if let tagValue = tagValue {
                 var dictEmotes: [String:Any] = [:]
                 let emotes = tagValue.split(separator: "/")
                 emotes.forEach{ emote in
                     let emoteParts = emote.split(separator: ":")
                     var textPositions: [[String:String]] = []
                     let positions = emoteParts[1].split(separator: ",")
                     positions.forEach{ position in
                         let positionParts = position.split(separator: "-")
                         textPositions.append(
                             ["startPosition": String(positionParts[0]),
                              "endPosition"  : String(positionParts[1])]
                         )
                     }
                     dictEmotes.updateValue(
                         textPositions,
                         forKey: String(emoteParts[0])
                     )
                 }
                 dictParsedTags.updateValue(dictEmotes, forKey: String(parsedTag[0]))
             }
         case "emote-sets":
             // emote-sets=0,33,50,237
             if let tagValue = tagValue{
                 let emoteSetIds = tagValue.split(separator: ",") // Array of emote set IDs.
                 dictParsedTags.updateValue(emoteSetIds, forKey: String(parsedTag[0]))
             }
         default:
             if let tagValue = tagValue{
                 dictParsedTags.updateValue(tagValue, forKey: String(parsedTag[0]))
             }
         }
     }

     return dictParsedTags
 }
 
 
 func parseCommand(_ rawCommandComponent: String) -> [String:Any]?{
     var parsedCommand: [String:Any]? = nil
     let commandParts = rawCommandComponent.split(separator: " ")
     
     switch String(commandParts[0]){
     case "JOIN": break
     case "PART": break
     case "NOTICE": break
     case "CLEARCHAT": break
     case "HOSTTARGET": break
     case "PRIVMSG":
         parsedCommand = [
             "command": String(commandParts[0]),
             "channel": String(commandParts[1])
         ]
     case "PING":
         parsedCommand = [
             "command": String(commandParts[0])
         ]
     case "CAP":
         parsedCommand = [
             "command": String(commandParts[0]),
             "isCapRequestEnabled": String(commandParts[2]) == "ACK"
         ]
     case "GLOBALUSERSTATE":  // Included only if you request the /commands capability.
                              // But it has no meaning without also including the /tags capability.
         parsedCommand = [
             "command": String(commandParts[0])
         ]
     case "USERSTATE": break   // Included only if you request the /commands capability.
     case "ROOMSTATE":   // But it has no meaning without also including the /tags capabilities.
         parsedCommand = [
             "command": String(commandParts[0]),
             "channel": String(commandParts[1])
         ]
     case "RECONNECT":
         print("The Twitch IRC server is about to terminate the connection for maintenance.")
         parsedCommand = [
             "command": String(commandParts[0])
         ]
     case "421": break
     case "001":  // Logged in (successfully authenticated).
         parsedCommand = [
             "command": String(commandParts[0]),
             "channel": String(commandParts[1])
         ]
     case "002": break  // Ignoring all other numeric messages.
     case "003": break
     case "004": break
     case "353": break // Tells you who else is in the chat room you're joining.
     case "366": break
     case "372": break
     case "375": break
     case "376": break
     default: break
     }
     return parsedCommand
 }
 
 func parseSource(_ rawSourceComponent: String?) -> [String:Any]{
     if let component = rawSourceComponent{
         let sourceParts = component.split(separator: "!")
         return [
             "nick": sourceParts.count == 2 ? String(sourceParts[0]) : "",
             "host": sourceParts.count == 2 ? String(sourceParts[1]) : String(sourceParts[0])
         ]
     }else{
         return [:]
     }
 }
 
 func parseParameters(_ rawParametersComponent: String, command:[String:Any]) -> [String:Any]{
     var command = command
     let idx = 0
     let commandParts = rawParametersComponent.slice(idx + 1).trimmingCharacters(in: .whitespacesAndNewlines)
     let paramsIdx = commandParts.distance(
         from: commandParts.startIndex,
         to: commandParts.firstIndex(of: " ")!
     )
     if paramsIdx == -1 {
         command.updateValue(
             String(commandParts.slice(0)),
             forKey: "botCommand"
         )
     }else{
         command.updateValue(
             String(commandParts.slice(0, paramsIdx)),
             forKey: "botCommand"
         )
         command.updateValue(
             String(commandParts.slice(paramsIdx)).trimmingCharacters(in: .whitespacesAndNewlines),
             forKey: "botCommandParams"
         )
     }
     return command
 }
 
 */
