//
//  FlightVoidQuotationRequest.swift
//  ShareTrip
//
//  Created by ST-iOS on 5/9/22.
//  Copyright © 2022 ShareTrip. All rights reserved.
//

import Foundation

struct FlightVoidQuotationRequest: Encodable {
    let searchId: String
    let bookingCode: String
}

struct FlightVoidConfirmRequest: Encodable {
    let voidSearchId: String
}
