//
//  TitleType.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/20/22.
//

import Foundation

public enum TitleType: String, Codable, CaseIterable {
    case mr = "MR"
    case ms = "MS"
    case master = "MSTR"
    case miss = "MISS"
    
    
    public init(from decoder: Decoder) throws {
        let stringValue = try decoder.singleValueContainer().decode(String.self)
        let capitalizedValue = stringValue.capitalized
        self = TitleType(rawValue: capitalizedValue) ?? .mr
    }
}
