//
//  GenderType.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/20/22.
//

import Foundation

public enum GenderType: String, Codable, CaseIterable {
    case male = "Male"
    case female = "Female"
    case other = "Other"
    
    public init(from decoder: Decoder) throws {
        let stringValue = try decoder.singleValueContainer().decode(String.self)
        let capitalizedValue = stringValue.capitalized
        self = GenderType(rawValue: capitalizedValue) ?? .male
    }
}
