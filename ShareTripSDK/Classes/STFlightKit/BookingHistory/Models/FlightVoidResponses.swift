//
//  FlightVoidResponses.swift
//  ShareTrip
//
//  Created by ST-iOS on 5/9/22.
//  Copyright © 2022 ShareTrip. All rights reserved.
//

import Foundation

struct FlightVoidQuotationResponse: Decodable {
    let totalReturnAmount: Int
    let voidSearchID: String
    let totalFee, confirmationTime, airlineVoidCharge, stVoidCharge: Int
    let reQuotationTime: String
    let purchasePrice: Int
    let automationType: Bool
    
    enum CodingKeys: String, CodingKey {
        case totalReturnAmount
        case voidSearchID = "voidSearchId"
        case totalFee, confirmationTime, airlineVoidCharge, stVoidCharge, reQuotationTime, purchasePrice, automationType
    }
}
