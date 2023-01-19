//
//  TNC.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 07/10/2019.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import Foundation

public struct TNC: Codable {
    public let common, loyalty, spin: TOSBodyData
    
    init(common: TOSBodyData, loyalty: TOSBodyData, spin: TOSBodyData) {
        self.common = common
        self.loyalty = loyalty
        self.spin = spin
    }
}

public struct FAQ: Codable {
    public let commonOverview, flight, holiday, hotel: TOSBodyData
    public let tour, transfer, tripCoin: TOSBodyData
    
    public init(commonOverview: TOSBodyData, flight: TOSBodyData, holiday: TOSBodyData, hotel: TOSBodyData, tour: TOSBodyData, transfer: TOSBodyData, tripCoin: TOSBodyData) {
        self.commonOverview = commonOverview
        self.flight = flight
        self.holiday = holiday
        self.hotel = hotel
        self.tour = tour
        self.transfer = transfer
        self.tripCoin = tripCoin
    }
    
    enum CodingKeys: String, CodingKey {
        case commonOverview = "common_overview"
        case flight, holiday, hotel, tour, transfer
        case tripCoin = "trip_coin"
    }
}

public struct TOSBodyData: Codable {
    public let body, flag, title: String
    
    public init(body: String, flag: String, title: String) {
        self.body = body
        self.flag = flag
        self.title = title
    }
}
