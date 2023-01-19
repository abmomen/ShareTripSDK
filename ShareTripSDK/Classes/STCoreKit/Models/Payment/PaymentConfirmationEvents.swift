//
//  PaymentConfirmationEvents.swift
//  ShareTrip
//
//  Created by ST-iOS on 10/25/21.
//  Copyright © 2021 ShareTrip. All rights reserved.
//

public enum PaymentConfirmationEvents: STAnalyticsEvent {
    case paymentCompleteVisa
    case paymentCompleteFlight
    case paymentCompleteHotel
    case paymentCompleteHoliday
    
    case paymentFailedVisa
    case paymentFailedFlight
    case paymentFailedHotel
    case paymentFailedHoliday
    
    public var name: String  {
        switch self {
        case .paymentCompleteVisa:
            return "payment_complete_visa"
        case .paymentCompleteFlight:
            return "payment_complete_flight"
        case .paymentCompleteHotel:
            return "payment_complete_hotel"
        case .paymentCompleteHoliday:
            return "payment_complete_holiday"
            
        case .paymentFailedVisa:
            return "payment_failed_visa"
        case .paymentFailedFlight:
            return "payment_failed_flight"
        case .paymentFailedHotel:
            return "payment_failed_hotel"
        case .paymentFailedHoliday:
            return "payment_failed_holiday"
        }
    }
    
    public var payload: Payload? { return nil }
}
