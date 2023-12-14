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

struct DefaultTwitchConfigration: TwitchAuthConfigration {
    let authURL: String
    let clientId: String
    let secretKey: String
    let redirectUri: String
    let forceVerify: String
    let scope: String
    let state: String
}
