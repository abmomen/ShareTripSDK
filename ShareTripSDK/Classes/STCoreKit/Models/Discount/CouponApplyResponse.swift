//
//  CouponApplyResponse.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/20/22.
//

public struct CouponApplyResponse: Codable {
    public let discount: Double
    public let gateway: [String]
    public let withDiscount: String?
    public let discountType: DiscountType
    public let mobileVerificationRequired: String?
    
    public var isWithDiscount: Bool {
        guard let withDiscount = withDiscount else { return false }
        return withDiscount.uppercased() == "YES"
    }
    
    public var isPhoneVerificationRequired: Bool {
        guard let mobileVerificationRequired = mobileVerificationRequired else { return false }
        return mobileVerificationRequired.uppercased() == "YES"
    }
}
