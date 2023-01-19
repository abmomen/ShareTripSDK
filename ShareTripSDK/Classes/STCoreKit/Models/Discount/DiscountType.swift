//
//  DiscountType.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/20/22.
//

import Foundation

public enum DiscountType: String, Codable {
    case flat       = "Flat"
    case percentage = "Percentage"
    case unknown
    
    public init(from decoder: Decoder) throws {
        let stringValue = try decoder.singleValueContainer().decode(String.self)
        self = DiscountType(rawValue: stringValue.capitalized) ?? .unknown
    }
}
