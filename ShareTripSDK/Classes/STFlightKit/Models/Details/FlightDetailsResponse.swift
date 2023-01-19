//
//  FlightDetailsResponse.swift
//  ShareTrip
//
//  Created by ST-iOS on 6/1/22.
//  Copyright © 2022 ShareTrip. All rights reserved.
//

import Foundation


public struct FlightDetailsResponse: Decodable {
    public let promotionalCoupon: [PromotionalCoupon]
}
