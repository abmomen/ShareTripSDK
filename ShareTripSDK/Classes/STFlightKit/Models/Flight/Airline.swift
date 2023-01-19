//
//  Airline.swift
//  STFlightKit
//
//  Created by ST-iOS on 11/20/22.
//

import Foundation

public class AirportInfo: Codable, Equatable {
    public let airport: String
    public let city: String
    public let code: String
    
    public static func == (lhs: AirportInfo, rhs: AirportInfo) -> Bool {
        return lhs.code == rhs.code
    }
}

public class Airline: Codable {
    public let records: Double?
    public let code: String
    public let full: String
    public let short: String
}

public class AirlineInfo: Codable {
    public let code: String
    public let full: String
    public let short: String
}

public class StopSegment: Codable {
    public let iata: String
    public let city: String
    public let name: String
}
