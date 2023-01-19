//
//  FlightRefundResponses.swift
//  ShareTrip
//
//  Created by ST-iOS on 5/9/22.
//  Copyright © 2022 ShareTrip. All rights reserved.
//



struct RefundableTravellersResponse: Decodable {
    let bookingCode: String
    let travellers: [RefundableTraveller]
}

struct RefundableTraveller: Decodable, Hashable {
    let eTicket, titleName, givenName, surName: String
    let dateOfBirth, paxNumber: String
    let travellerType: TravellerType
    let paxAssociated: String?
}

struct RefundQuotationCheckResponse: Decodable {
    let refundSearchID, specialRefundMessage: String
    let confirmationTime, airlineRefundCharge, stFee, totalFee: Double
    let purchasePrice, totalRefundAmount: Double
    
    enum CodingKeys: String, CodingKey {
        case refundSearchID = "refundSearchId"
        case specialRefundMessage, confirmationTime, airlineRefundCharge, stFee, totalFee, purchasePrice, totalRefundAmount
    }
}
