//
//  PaymentConfirmationType.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/20/22.
//

import Foundation

public enum PaymentConfirmationType: String, Codable {
    case success = "success"
    case failed = "failed"
}

public struct PaymentConfirmationData {
    public let confirmationType: PaymentConfirmationType
    public let serviceType: ServiceType
    public let notifierSchedules: [DateComponents]
    public let earnTripCoin: Int
    public let redeemTripCoin: Int
    public let shareTripCoin: Int
    
    public init(confirmationType: PaymentConfirmationType, serviceType: ServiceType, notifierSchedules: [DateComponents], earnTripCoin: Int, redeemTripCoin: Int, shareTripCoin: Int) {
        self.confirmationType = confirmationType
        self.serviceType = serviceType
        self.notifierSchedules = notifierSchedules
        self.earnTripCoin = earnTripCoin
        self.redeemTripCoin = redeemTripCoin
        self.shareTripCoin = shareTripCoin
    }
}
