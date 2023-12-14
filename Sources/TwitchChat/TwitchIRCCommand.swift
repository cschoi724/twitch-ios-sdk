//
//  TwitchIRCCommand.swift
//
//
//  Created by cschoi on 12/13/23.
//

import Foundation

enum TwitchIRCCommand: RawRepresentable {
    typealias RawValue = String
    
    case CLEARCHAT
    case CLEARMSG
    case GLOBALUSERSTATE
    case HOSTTARGET
    case NOTICE
    case PRIVMSG
    case ROOMSTATE
    case USERNOTICE
    case USERSTATE
    case WHISPER
    case PING
    case RECONNECT
    case JOIN
    case PART
    case LOGINSUCCESS
    case UNKNOWN
    
    init(rawValue: String) {
        switch rawValue {
        case "CLEARCHAT":
            self = .CLEARCHAT
        case "CLEARMSG":
            self = .CLEARMSG
        case "GLOBALUSERSTATE":
            self = .GLOBALUSERSTATE
        case "HOSTTARGET":
            self = .HOSTTARGET
        case "NOTICE":
            self = .NOTICE
        case "PRIVMSG":
            self = .PRIVMSG
        case "ROOMSTATE":
            self = .ROOMSTATE
        case "USERNOTICE":
            self = .USERNOTICE
        case "USERSTATE":
            self = .USERSTATE
        case "WHISPER":
            self = .WHISPER
        case "PING":
            self = .PING
        case "RECONNECT":
            self = .RECONNECT
        case "JOIN":
            self = .JOIN
        case "PART":
            self = .PART
        case "001":
            self = .LOGINSUCCESS
        default:
            self = .UNKNOWN
        }
    }
    
    var rawValue: String {
        switch self {
        case .CLEARCHAT:
            return "CLEARCHAT"
        case .CLEARMSG:
            return "CLEARMSG"
        case .GLOBALUSERSTATE:
            return "GLOBALUSERSTATE"
        case .HOSTTARGET:
            return "HOSTTARGET"
        case .NOTICE:
            return "NOTICE"
        case .PRIVMSG:
            return "PRIVMSG"
        case .ROOMSTATE:
            return "ROOMSTATE"
        case .USERNOTICE:
            return "USERNOTICE"
        case .USERSTATE:
            return "USERSTATE"
        case .WHISPER:
            return "WHISPER"
        case .PING:
            return "PING"
        case .RECONNECT:
            return "RECONNECT"
        case .JOIN:
            return "JOIN"
        case .PART:
            return "PART"
        case .LOGINSUCCESS:
            return "001"
        case .UNKNOWN:
            return ""
        }
    }
}

/*
            case 'JOIN':
         case 'PART':
         case 'NOTICE':
         case 'CLEARCHAT':
         case 'HOSTTARGET':
         case 'PRIVMSG':
             parsedCommand = {
                 command: commandParts[0],
                 channel: commandParts[1]
             }
             break;
         case 'PING':
             parsedCommand = {
                 command: commandParts[0]
             }
             break;
         case 'CAP':
             parsedCommand = {
                 command: commandParts[0],
                 isCapRequestEnabled: (commandParts[2] === 'ACK') ? true : false,
                 // The parameters part of the messages contains the
                 // enabled capabilities.
             }
             break;
         case 'GLOBALUSERSTATE':  // Included only if you request the /commands capability.
                                  // But it has no meaning without also including the /tags capability.
             parsedCommand = {
                 command: commandParts[0]
             }
             break;
         case 'USERSTATE':   // Included only if you request the /commands capability.
         case 'ROOMSTATE':   // But it has no meaning without also including the /tags capabilities.
             parsedCommand = {
                 command: commandParts[0],
                 channel: commandParts[1]
             }
             break;
         case 'RECONNECT':
             console.log('The Twitch IRC server is about to terminate the connection for maintenance.')
             parsedCommand = {
                 command: commandParts[0]
             }
             break;
         case '421':
             console.log(`Unsupported IRC command: ${commandParts[2]}`)
             return null;
         case '001':  // Logged in (successfully authenticated).
             parsedCommand = {
                 command: commandParts[0],
                 channel: commandParts[1]
             }
             break;
         case '002':  // Ignoring all other numeric messages.
         case '003':
         case '004':
         case '353':  // Tells you who else is in the chat room you're joining.
         case '366':
         case '372':
         case '375':
         case '376':
             console.log(`numeric message: ${commandParts[0]}`)
             return null;
         default:
             console.log(`\nUnexpected command: ${commandParts[0]}\n`);
             return null;
 
 */
