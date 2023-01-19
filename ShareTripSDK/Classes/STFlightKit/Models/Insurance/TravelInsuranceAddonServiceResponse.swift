//
//  TravelInsuranceAddonServiceResponse.swift
//  ShareTrip
//
//  Created by Mac mini M1 on 13/9/22.
//  Copyright © 2022 ShareTrip. All rights reserved.
//

import Foundation

// MARK: - Response
public struct TravelInsuranceAddonServiceResponse: Codable {
    public let code, name: String?
    public let logo: String?
    public let selfRisk: Int
    public let options: [TravelInsuranceOption]?
    
    enum CodingKeys: String, CodingKey {
        case code, name, logo, options
        case selfRisk = "self"
    }
}

// MARK: - Option
public struct TravelInsuranceOption: Codable {
    public let code, name: String?
    public let price, discountPrice: Double?
    public let defaultOption: Int
    
    enum CodingKeys: String, CodingKey {
        case code, name
        case price, discountPrice
        case defaultOption = "default"
    }
}
