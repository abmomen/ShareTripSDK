//
//  GPStarRequest.swift
//  ShareTrip
//
//  Created by ST-iOS on 9/20/22.
//  Copyright © 2022 ShareTrip. All rights reserved.
//

import Foundation

public struct GPStarRequest: Encodable {
    public let mobileNumber: String
    public let otp: String?
    
    public init(mobileNumber: String, otp: String?) {
        self.mobileNumber = mobileNumber
        self.otp = otp
    }
}
