//
//  FlightLeg.swift
//  STFlightKit
//
//  Created by ST-iOS on 11/20/22.
//



public struct FlightLegData {
    public let originName: String
    public let destinationName: String
    public let airplaneName: String
    public let airplaneLogo: String
    public let departureTime: String
    public let arrivalTime: String
    public let stop: Int
    public let dayCount: Int
    public let duration: String
    
    public init(originName: String, destinationName: String, airplaneName: String, airplaneLogo: String, departureTime: String, arrivalTime: String, stop: Int, dayCount: Int, duration: String) {
        self.originName = originName
        self.destinationName = destinationName
        self.airplaneName = airplaneName
        self.airplaneLogo = airplaneLogo
        self.departureTime = departureTime
        self.arrivalTime = arrivalTime
        self.stop = stop
        self.dayCount = dayCount
        self.duration = duration
    }
}

public struct FlightRow {
    public let currency: String
    public let totalPrice: Double
    public let discountPrice: Double?
    public let discountPercentage: Double?
    public let earnPoint: Int
    public let sharePoint: Int
    public let flightLegDatas: [FlightLegData]
    public var hasTechnicalStoppage: Bool
    public var isRefundable: String
    public var dealType: FlightDealType?
    
    public init(currency: String, totalPrice: Double, discountPrice: Double?, discountPercentage: Double?, earnPoint: Int, sharePoint: Int, flightLegDatas: [FlightLegData], hasTechnicalStoppage: Bool, isRefundable: String, dealType: FlightDealType? = nil) {
        self.currency = currency
        self.totalPrice = totalPrice
        self.discountPrice = discountPrice
        self.discountPercentage = discountPercentage
        self.earnPoint = earnPoint
        self.sharePoint = sharePoint
        self.flightLegDatas = flightLegDatas
        self.hasTechnicalStoppage = hasTechnicalStoppage
        self.isRefundable = isRefundable
        self.dealType = dealType
    }
    
    public var totalPriceText: String {
        return totalPrice.withCommas()
    }
    
    public var discountPriceText: String? {
        return discountPrice?.withCommas()
    }
    
    public var earnPointText: String {
        return earnPoint.withCommas()
    }
    
    public var sharePointText: String {
        return sharePoint.withCommas()
    }
}
