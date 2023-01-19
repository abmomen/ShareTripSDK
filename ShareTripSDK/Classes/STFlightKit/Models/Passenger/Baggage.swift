//
//  Baggage.swift
//  STFlightKit
//
//  Created by ST-iOS on 11/20/22.
//



public struct BaggageResponse: Codable {
    public let isPerPerson, isLuggageOptional, wholeFlight: Bool?
    public var wholeFlightOptions: [BaggageWholeFlightOptions]?
    public var routeOptions: [BaggageRouteOption]?
}

public struct BaggageRouteOption: Codable {
    public let origin, destination: String?
    public var options: [BaggageWholeFlightOptions]?
}

public struct BaggageWholeFlightOptions: Codable, Hashable {
    public var travellerType: BaggageTravellerType?
    public var code: String?
    public let quantity: Int?
    public let details: String?
    public let amount: Double?
    public let currency: Currency
    
    public init(travellerType: BaggageTravellerType? = nil, code: String? = nil, quantity: Int?, details: String?, amount: Double?, currency: Currency) {
        self.travellerType = travellerType
        self.code = code
        self.quantity = quantity
        self.details = details
        self.amount = amount
        self.currency = currency
    }
}

public enum BaggageTravellerType: String, Codable {
    case adt = "ADT"
    case chd = "CHD"
    case inf = "INF"
}
