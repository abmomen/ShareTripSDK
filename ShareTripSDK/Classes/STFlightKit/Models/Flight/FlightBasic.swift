//
//  FlightBasic.swift
//  STFlightKit
//
//  Created by ST-iOS on 11/20/22.
//

public enum ClassType: String, Codable {
    case economy        = "Economy"
    case premiumEconomy = "Premium Economy"
    case business       = "Business"
    case firstClass     = "First"
}

public enum TripType: String, Codable {
    case oneWay    = "OneWay"
    case roundTrip = "Return"
    case multiCity = "Other"

    public static var allCases: [TripType] {
        return [.oneWay, .roundTrip, .multiCity]
    }
}

public class DateTime: Codable {
    public let date: String
    public let time: String
}

// MARK: - PriceBreakdown
public class FlightPriceBreakdown: Codable {
    public let discount, subTotal, couponAmount : Double
    public let total, originPrice, discountAmount: Double
    public let advanceIncomeTax: Double?
    public let currency: String
    public let details: [FlightPriceBreakdownDetail]
}

public class FlightPriceBreakdownDetail: Codable {
    public let type: TravellerType
    public let baseFare, tax, total: Double
    public let currency: String
    public let numberPaxes: Int
}


