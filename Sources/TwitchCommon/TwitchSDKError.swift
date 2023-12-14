//
//  TwitchAuthError.swift
//
//
//  Created by cschoi on 12/13/23.
//

import Foundation

public enum TwitchSDKError: Error {
    case urlGeneration
    case noGround
    case responseSerializationFailed
    case noResponse
    case failure
    case cancel
    case networkError(error: Error)
    case unknown
}
