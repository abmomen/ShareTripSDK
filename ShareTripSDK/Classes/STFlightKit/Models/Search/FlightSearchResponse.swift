//
//  FlightSearchResponse.swift
//  STFlightKit
//
//  Created by ST-iOS on 11/20/22.
//

import Foundation

public struct FlightSearchResponse: Codable {
    public let totalRecords: Int
    public let searchId, sessionId: String
    public let flightRouteType: FlightRouteType
    public let flightClass: FlightClass
    public let flights: [Flight]
    public var filters: FlightFilter
    public var filterDeal: FlightSortingOptions?
    
    enum CodingKeys: String, CodingKey {
        case totalRecords, searchId, sessionId, filters, flights
        case flightClass = "class"
        case flightRouteType = "tripType"
        case filterDeal
    }
}

public class PlaneCabin: Codable {
    public let code, name: String
}

public class TimeSlot: Codable {
    public let key, value: String
}

public class FlightStoppage: Codable {
    public let id: Int
    public let name: String
}

public class FlightWeight: Codable {
    public let key, weight: Int
    public let unit: String
    public let note: String
}



public class FlightLeg: Codable {
    public let searchCode, sequenceCode: String
    public let airlines: AirlineInfo
    public let airlinesCode: String
    public let logo: String
    public let aircraft: String
    public let aircraftCode: String
    public let originName, destinationName: AirportInfo
    public let arrivalDateTime, departureDateTime: DateTime
    public let duration: String
    public let stop: Int
    public let stopSegment: [Airport]
    public let min, dayCount: Int
    public let hiddenStops: Bool
}
