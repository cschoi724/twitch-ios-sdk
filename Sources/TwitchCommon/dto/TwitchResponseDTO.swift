//
//  TwitchResponseDTO.swift
//  SPLE
//
//  Created by cschoi on 2022/12/14.
//

import Foundation
struct TwitchResponseDTO<T: Codable>: Codable {
    let data: T!
    
    enum CodingKeys: CodingKey {
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.data = (try? container.decode(T.self, forKey: .data)) ?? nil
    }
}
