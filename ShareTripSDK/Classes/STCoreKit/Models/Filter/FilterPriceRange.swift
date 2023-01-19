//
//  FilterPriceRange.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/23/22.
//

import Foundation

public struct FilterPriceRange {
    public let low: Int
    public let high: Int
    public var currentLow: Int?
    public var currentHigh: Int?
    
    public var hasFilter: Bool {
        return currentLow != nil || currentHigh != nil
    }
    
    public init(low: Int, high: Int, currentLow: Int? = nil, currentHigh: Int? = nil) {
        self.low = low
        self.high = high
        self.currentLow = currentLow
        self.currentHigh = currentHigh
    }
}
