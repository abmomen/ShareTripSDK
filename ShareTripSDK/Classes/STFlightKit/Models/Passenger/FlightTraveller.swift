//
//  FlightTraveller.swift
//  STFlightKit
//
//  Created by ST-iOS on 11/20/22.
//

import Foundation

public enum TravellerType: String, Codable, CaseIterable {
    case adult = "Adult"
    case child = "Child"
    case infant = "Infant"
    
    public var requiredInfo: String {
        switch self {
        case .adult:
            return "12 years and above"
        case .child:
            return "2-11 years at the time of travel"
        case .infant:
            return "0-23 months at the time of travel"
        }
    }
    
    public init(from decoder: Decoder) throws {
        let stringValue = try decoder.singleValueContainer().decode(String.self)
        let capitalizedValue = stringValue.capitalized
        self = TravellerType(rawValue: capitalizedValue) ?? .adult
    }
    
    public init(intValue: Int) {
        switch intValue {
        case 0:
            self = .adult
        case 1:
            self = .child
        case 2:
            self = .infant
        default:
            self = .adult
        }
    }
    
    public static func getTravellerType(from dateOfBirth: Date) -> TravellerType {
        
        let years = Date().since(dateOfBirth, in: .year)
        
        if years < 2 {
            return .infant
        } else if years < 11 {
            return .child
        }
        
        return .adult
    }
}
