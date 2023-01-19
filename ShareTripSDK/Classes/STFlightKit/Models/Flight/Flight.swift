//
//  Flight.swift
//  STFlightKit
//
//  Created by ST-iOS on 11/20/22.
//

import Foundation

public enum FlightDealType: String, Codable {
    case preferred = "Preferred"
    case best      = "Best Deal"
    case none      = "None"

    public var title: String {
        switch self {
        case .preferred:
            return "Preferred Airlines"
        case .best:
            return "Best Deal"
        case .none:
            return "None"
        }
    }
}

// MARK: - Flight
public class Flight: Codable {
    public let deal: FlightDealType?
    public let sequence: String
    public let shareLink: String?
    public let seatsLeft: Int
    public let refundable: Bool?
    public let isRefundable: String?
    public let weight: String?
    public let price, discount, originPrice: Double
    public var earnPoint, sharePoint: Int
    public let currency, gatewayCurrency: String
    public let totalDuration: String
    public let departStartDate: DateTime
    public let flightLegs: [FlightLeg]
    public let segments: [FlightSegment]
    public var priceBreakdown: FlightPriceBreakdown
    public let domestic: Bool
    public let attachment: Bool?
    public let airlinesCode: String?
    public let advanceIncomeTax: Double?
    
    enum CodingKeys: String, CodingKey {
        case deal, sequence, shareLink, seatsLeft, refundable, weight, price, discount, originPrice
        case earnPoint, sharePoint, currency, totalDuration, departStartDate, gatewayCurrency, airlinesCode
        case flightLegs = "flight"
        case segments, priceBreakdown, domestic, attachment, advanceIncomeTax, isRefundable
    }
}
