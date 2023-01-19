//
//  FlightPriceRange.swift
//  STFlightKit
//
//  Created by ST-iOS on 11/20/22.
//

import Foundation

public class FlightPriceRange: Codable {
    public let max, min: Int
    public init(min: Int, max: Int) {
        self.max = max
        self.min = min
    }
}
