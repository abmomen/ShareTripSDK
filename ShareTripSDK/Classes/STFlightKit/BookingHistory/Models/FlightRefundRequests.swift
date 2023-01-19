//
//  FlightRefundRequests.swift
//  ShareTrip
//
//  Created by ST-iOS on 5/9/22.
//  Copyright © 2022 ShareTrip. All rights reserved.
//

import Foundation

struct FlightRefundEligibleTravellersRequest: Encodable {
    let bookingCode: String
    let searchId: String
}

struct FlightRefundQuotationRequest: Encodable {
    let bookingCode: String
    let searchId: String
    let eTickets: [String]
    
    var eTicketsParam: String {
        var param = "["
        for index in 0..<eTickets.count {
            if index == eTickets.count - 1 {
                param += "\"" + eTickets[index] + "\""
            } else {
                param += "\"" + eTickets[index] + "\"" + ", "
            }
        }
        param += "]"
        
        return param
    }
}

struct FlightRefundConfirmRequest: Encodable {
    let refundSearchId: String
}
