//
//  Airport.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/22/22.
//

import Foundation

// MARK: - Airport Search
public class Airport: Codable, Equatable {
    public let iata: String
    public let name: String
    public let city: String?
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        iata = try container.decode(String.self, forKey: .iata)
        name = try container.decode(String.self, forKey: .name)
        city = try container.decodeIfPresent(String.self, forKey: .city)
    }

    public static func == (lhs: Airport, rhs: Airport) -> Bool {
        return lhs.iata == rhs.iata
    }
}
