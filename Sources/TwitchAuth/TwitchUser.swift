//
//  TwitchUser.swift
//
//
//  Created by cschoi on 2023/02/22.
//

import Foundation

public struct TwitchUser: Codable {
    public let token: String
    public let id: String
    public let login: String
    public let displayName: String
    public let type: String
    public let broadcasterType: String
    public let profileImageURL: String
    public let offlineImageURL: String
    public let description: String
    public let viewCount: String
    public let email: String
    public let createdAt: String
    
    init(token: String, id: String, login: String, displayName: String, type: String, broadcasterType: String, profileImageURL: String, offlineImageURL: String, description: String, viewCount: String, email: String, createdAt: String) {
        self.token = token
        self.id = id
        self.login = login
        self.displayName = displayName
        self.type = type
        self.broadcasterType = broadcasterType
        self.profileImageURL = profileImageURL
        self.offlineImageURL = offlineImageURL
        self.description = description
        self.viewCount = viewCount
        self.email = email
        self.createdAt = createdAt
    }
}
