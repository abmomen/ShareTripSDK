//
//  Covid19TestOptions.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 23/02/2021.
//  Copyright © 2021 ShareTrip. All rights reserved.
//

import Foundation

public struct Covid19TestOptionResponse: Codable {
    public let name, code, logo: String?
    public let selfTest: Bool?
    public var options: [CovidTestOptions]?
    
    enum CodingKeys: String, CodingKey {
        case name, code, logo, options
        case selfTest = "self"
    }
}

public struct CovidTestOptions: Codable {
    public let name, code: String?
    public let price, discountPrice: Double?
    public let isAddress: Bool?
}
