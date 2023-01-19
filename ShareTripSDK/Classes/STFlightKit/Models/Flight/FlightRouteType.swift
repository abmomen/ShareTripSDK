//
//  FlightRouteType.swift
//  STFlightKit
//
//  Created by ST-iOS on 11/20/22.
//

import Foundation
import Alamofire

public enum FlightRouteType: String, Codable, CaseIterable {
    case round     = "Return"
    case oneWay    = "OneWay"
    case multiCity = "Other"
    
    public init(stringValue: String) {
        if let value = FlightRouteType(rawValue: stringValue) {
            self = value
            return
        }
        self = .round
    }
    
    public init(from decoder: Decoder) throws {
        let stringValue = try decoder.singleValueContainer().decode(String.self)
        let capitalizedValue = stringValue.capitalized
        self = FlightRouteType(rawValue: capitalizedValue) ?? .round
    }
    
    public init(intValue: Int) {
        switch intValue {
        case 0:
            self = .round
        case 1:
            self = .oneWay
        case 2:
            self = .multiCity
        default:
            self = .round
        }
    }
    
    public var intValue: Int {
        switch self {
        case .round:
            return 0
        case .oneWay:
            return 1
        case .multiCity:
            return 2
        }
    }
    
    public var title: String {
        switch self {
        case .round:
            return "ROUND"
        case .oneWay:
            return "ONE-WAY"
        case .multiCity:
            return "MULTI-CITY"
        }
    }
}
