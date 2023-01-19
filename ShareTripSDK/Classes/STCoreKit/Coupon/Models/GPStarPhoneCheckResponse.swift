//
//  GPStarResponse.swift
//  ShareTrip
//
//  Created by ST-iOS on 9/20/22.
//  Copyright © 2022 ShareTrip. All rights reserved.
//

import Foundation

public struct GPStarPhoneCheckResponse: Codable {
    public let loyaltyStatus: String?
    public let success: Bool?
    public let otpExpirationInMin: Double?
    
    public init(loyaltyStatus: String?, success: Bool?, otpExpirationInMin: Double?) {
        self.loyaltyStatus = loyaltyStatus
        self.success = success
        self.otpExpirationInMin = otpExpirationInMin
    }
}

public struct GPStarOTPCheckResponse: Codable {
    public let success: Bool
    
    init(success: Bool) {
        self.success = success
    }
}
