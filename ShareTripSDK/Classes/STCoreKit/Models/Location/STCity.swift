//
//  STCity.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/22/22.
//

import Foundation

public class STCity: Codable {
    public let name: String?
    public let cityCode: String?
    public let countryCode: String?
    public let countryName: String?
    public let image: String?
    public let cityName: String?
    public let minPrice: Int?
    public let currency: String?
    public let count: Int?
     
    public var commonCityName: String? {
        return cityName ?? name
    }
}
