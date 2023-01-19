//
//  PromotionalCoupon.swift
//  ShareTrip
//
//  Created by ST-iOS on 6/7/22.
//  Copyright © 2022 ShareTrip. All rights reserved.
//

import Foundation

public struct PromotionalCoupon: Decodable {
    public let coupon, title: String
    public let minimumTotalAmount: Double
    public let withDiscount: String
    public let discount: Double
    public let discountType: String
    public let rooms: [Int]?
    public let gateway: [String]?
}
