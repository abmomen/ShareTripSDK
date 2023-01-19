//
//  Period.swift
//  STCoreKit
//
//  Created by ST-iOS on 12/5/22.
//

public struct Period: Codable {
    public let departureTime: String
    public let triplePerPax, doublePerPax: Int?
    public let periodFrom: String?
    public let id: Int?
    public let specificDays: String?
    public let category: String?
    public let singlePerPax: Int?
    public let departs: Departs?
    public let child7To12, quadPerPax: Int?
    public let periodTo: String?
    public let child3To6, infant, twinPerPax: Int?
    public let package_periods_hotels: [PeriodHotel]
    public let currency: String?
    public let singlePerPaxDiscountPrice, triplePerPaxDiscountPrice: Int?
    public let quadPerPaxDiscountPrice, infantDiscountPrice: Int?
    public let twinPerPaxDiscountPrice, doublePerPaxDiscountPrice, child3To6DiscountPrice, child7To12DiscountPrice: Int?
    
    public init(departureTime: String, triplePerPax: Int?, doublePerPax: Int?, periodFrom: String?, id: Int?, specificDays: String?, category: String?, singlePerPax: Int?, departs: Departs?, child7To12: Int?, quadPerPax: Int?, periodTo: String?, child3To6: Int?, infant: Int?, twinPerPax: Int?, package_periods_hotels: [PeriodHotel], currency: String?, singlePerPaxDiscountPrice: Int?, triplePerPaxDiscountPrice: Int?, quadPerPaxDiscountPrice: Int?, infantDiscountPrice: Int?, twinPerPaxDiscountPrice: Int?, doublePerPaxDiscountPrice: Int?, child3To6DiscountPrice: Int?, child7To12DiscountPrice: Int?) {
        self.departureTime = departureTime
        self.triplePerPax = triplePerPax
        self.doublePerPax = doublePerPax
        self.periodFrom = periodFrom
        self.id = id
        self.specificDays = specificDays
        self.category = category
        self.singlePerPax = singlePerPax
        self.departs = departs
        self.child7To12 = child7To12
        self.quadPerPax = quadPerPax
        self.periodTo = periodTo
        self.child3To6 = child3To6
        self.infant = infant
        self.twinPerPax = twinPerPax
        self.package_periods_hotels = package_periods_hotels
        self.currency = currency
        self.singlePerPaxDiscountPrice = singlePerPaxDiscountPrice
        self.triplePerPaxDiscountPrice = triplePerPaxDiscountPrice
        self.quadPerPaxDiscountPrice = quadPerPaxDiscountPrice
        self.infantDiscountPrice = infantDiscountPrice
        self.twinPerPaxDiscountPrice = twinPerPaxDiscountPrice
        self.doublePerPaxDiscountPrice = doublePerPaxDiscountPrice
        self.child3To6DiscountPrice = child3To6DiscountPrice
        self.child7To12DiscountPrice = child7To12DiscountPrice
    }
    
    public enum Departs: String, Codable {
        case everyDay = "EVERY DAY"
        case specificDay = "SPECIFIC DAY"
        case unknown
    }
}

public struct PeriodHotel: Codable {
    public let cityName: String
    public let id: Int
    public let hotelName, hotelId: String
    
    public init(cityName: String, id: Int, hotelName: String, hotelId: String) {
        self.cityName = cityName
        self.id = id
        self.hotelName = hotelName
        self.hotelId = hotelId
    }
}
