//
//  FlightNavTitleViewData.swift
//  STFlightKit
//
//  Created by ST-iOS on 11/23/22.
//

import Foundation

public struct FlightNavTitleViewData {
    public let flightRouteType: FlightRouteType
    public let firstText: String
    public let secondText: String
    public let firstDate: Date?
    public let secondDate: Date?
    public let travellerText: String
    public let showArrow: Bool
    
    public init(flightRouteType: FlightRouteType, firstText: String, secondText: String, firstDate: Date?, secondDate: Date?, travellerText: String, showArrow: Bool) {
        self.flightRouteType = flightRouteType
        self.firstText = firstText
        self.secondText = secondText
        self.firstDate = firstDate
        self.secondDate = secondDate
        self.travellerText = travellerText
        self.showArrow = showArrow
    }
}
