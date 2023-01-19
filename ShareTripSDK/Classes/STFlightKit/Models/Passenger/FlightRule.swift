//
//  FlightRule.swift
//  STFlightKit
//
//  Created by ST-iOS on 11/20/22.
//

import Foundation

// MARK: - FlightRuleResponse
public class FlightRuleResponse: Codable {
    public let refundPolicies: [RefundPolicy?]?
    public let baggages: [FlightBaggage]?
    public let fareDetails: String?
    
    enum CodingKeys: String, CodingKey {
        case refundPolicies = "airFareRules"
        case baggages, fareDetails
    }
}

// MARK: - RefundPolicy/AirFareRule
public class RefundPolicy: Codable {
    public let type: String
    public let rules: [RefundPolicyRule]
}

// MARK: - RefundPolicyRule
public class RefundPolicyRule: Codable {
    public let type, text: String
}

// MARK: - Baggage
public class FlightBaggage: Codable {
    public let type: String
    public let adult: String?
    public let child, infant: String?
}
