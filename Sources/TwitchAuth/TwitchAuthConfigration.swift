//
//  TwitchAuthConfigration.swift
//
//
//  Created by cschoi on 12/13/23.
//

import Foundation

public protocol TwitchAuthConfigration {
    var authURL: String { get }
    var clientId: String { get }
    var secretKey: String { get }
    var redirectUri: String { get }
    var forceVerify: String { get }
    var scope: String { get }
    var state: String { get }
}

public struct DefaultTwitchConfigration: TwitchAuthConfigration {
    public let authURL: String
    public let clientId: String
    public let secretKey: String
    public let redirectUri: String
    public let forceVerify: String
    public let scope: String
    public let state: String
}
