//
//  CoinSettings.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/22/22.
//

import Foundation

public class TreasureBoxCoin: Codable {
    public let passed: String
    public let remaining: String
    public let format: String
    public let status: String
    
    public func totalWaitTime() -> Double {
        
        let passedDouble = Double(passed) ?? 0
        let remainingDouble = Double(remaining) ?? 0
        let waitTime = passedDouble + remainingDouble
        
        if waitTime == 0 {
            return 6 * 60 * 60
        }
        
        return waitTime
    }
}

public class CoinSettings: Codable {
    public let registrationEarnCoin: Int
    public let referCoin: Int
    public let treasureBoxCoin: Int
    public let minCostPlayWheel: Int
    public let maxTripCoinValue: Int
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        registrationEarnCoin = try container.decodeIfPresent(Int.self, forKey: .registrationEarnCoin) ?? 0
        referCoin = try container.decodeIfPresent(Int.self, forKey: .referCoin) ?? 0
        treasureBoxCoin = try container.decodeIfPresent(Int.self, forKey: .treasureBoxCoin) ?? 0
        minCostPlayWheel = try container.decodeIfPresent(Int.self, forKey: .minCostPlayWheel) ?? 0
        maxTripCoinValue = try container.decodeIfPresent(Int.self, forKey: .maxTripCoinValue) ?? 0
    }
}
