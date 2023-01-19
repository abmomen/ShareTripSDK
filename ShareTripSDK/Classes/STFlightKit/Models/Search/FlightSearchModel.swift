//
//  FlightSearchModel.swift
//  STFlightKit
//
//  Created by ST-iOS on 11/20/22.
//



public enum FlightSearchCellOption {
    case routeType
    case airport
    case date
    case travellerClass
    case addCity
    case searchButton
    case explore
    case promotionalImage
}

public struct FlightSearchInfo {
    public let departure: Airport?
    public let arrival: Airport?
    public let date: Date?
}

public enum FlightScheduledType: Int {
    case departure
    case arrival
}
