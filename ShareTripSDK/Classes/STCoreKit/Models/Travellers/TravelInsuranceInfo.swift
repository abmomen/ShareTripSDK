//
//  TravelInsuranceInfo.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/20/22.
//

import Foundation

public struct TravelInsuranceInfo: Codable {
    public let code: String?
    public let optionsCode: String?
    
    public init(code: String? = "", optionsCode: String? = "") {
        self.code = code
        self.optionsCode = optionsCode
    }
}
