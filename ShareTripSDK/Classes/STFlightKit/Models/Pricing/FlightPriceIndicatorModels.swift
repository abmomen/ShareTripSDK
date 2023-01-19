//
//  FlightPriceIndicatorModels.swift
//  STFlightKit
//
//  Created by ST-iOS on 11/20/22.
//

import Foundation

// MARK: - Response
public struct FlightPriceIndicatorResponse: Codable {
    public let max, min: MinMaxFlightPriceIndicator?
    public let fare: [DateFlightPriceIndicator]
}

// MARK: - Fare
public struct DateFlightPriceIndicator: Codable {
    public let date: String
    public let direct, nonDirect: Double
}

// MARK: - Max
public struct MinMaxFlightPriceIndicator: Codable {
    public let direct, nonDirect: Double
}
