//
//  CityProperty.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/22/22.
//

import Foundation

public class CityProperty: Codable {
    public let id: String?
    public let countryCode: String?
    public let countryName: String?
    public let center: STLocation?
    public let name : String?
    public let type: String?
     
    public init(id: String, countryCode: String, countryName: String, center: STLocation, name : String, type: String) {
        self.id = id
        self.countryCode = countryCode
        self.countryName = countryName
        self.center = center
        self.name = name
        self.type = type
    }
}
