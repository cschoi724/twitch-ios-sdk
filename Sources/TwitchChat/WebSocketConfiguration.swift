//
//  WebSocketConfiguration.swift
//
//
//  Created by cschoi on 2023/03/02.
//

import Foundation

struct WebSocketConfiguration {
    let serverURL: String
    let header: [String: String]
    
    init(serverURL: String, header: [String: String] = [:]) {
        self.serverURL = serverURL
        self.header = header
    }
}
