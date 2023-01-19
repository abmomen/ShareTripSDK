//
//  FlightClass.swift
//  STFlightKit
//
//  Created by ST-iOS on 11/20/22.
//

import Foundation

public enum FlightClass: String, Codable, CaseIterable {
    case economy = "Economy"
    case business = "Business"
    case firstClass = "First"
    
    public init(from decoder: Decoder) throws {
        let stringValue = try decoder.singleValueContainer().decode(String.self)
        let capitalizedValue = stringValue.capitalized
        self = FlightClass(rawValue: capitalizedValue) ?? .economy
    }
    
    public init(intValue: Int) {
        switch intValue {
        case 0:
            self = .economy
        case 1:
            self = .business
        case 2:
            self = .firstClass
        default:
            self = .economy
        }
    }
    
    public var intValue: Int {
        switch self {
        case .economy:
            return 0
        case .business:
            return 1
        case .firstClass:
            return 2
        }
    }
    
    public var title: String {
        switch self {
        case .economy:
            return "Economy"
        case .business:
            return "Business"
        case .firstClass:
            return "First Class"
        }
    }
}
