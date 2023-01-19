//
//  CovidTestInfo.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/20/22.
//

import Foundation

public struct CovidTestInfo: Codable {
    public let code: String
    public let optionsCode: String
    public var address: String
    public var selfTest: Bool
    
    public init() {
        self.code = ""
        self.optionsCode = ""
        self.address = ""
        self.selfTest = true
    }
    
    public init(code: String, optionsCode: String, address: String, selfTest: Bool) {
        self.code = code
        self.optionsCode = optionsCode
        self.address = address
        self.selfTest = selfTest
    }
}
