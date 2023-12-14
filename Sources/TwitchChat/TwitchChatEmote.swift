//
//  TwitchChatEmote.swift
//
//
//  Created by cschoi on 12/13/23.
//

import Foundation

public struct TwitchChatEmote {
    public let id: String
    public let indices: [Int]
    
    init(
        id: String,
        indices: [Int]
    ) {
        self.id = id
        self.indices = indices
    }
}
