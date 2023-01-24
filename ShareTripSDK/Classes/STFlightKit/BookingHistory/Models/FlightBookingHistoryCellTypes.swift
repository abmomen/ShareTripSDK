//
//  FlightBookingHistoryCellTypes.swift
//  ShareTrip
//
//  Created by ST-iOS on 5/17/22.
//  Copyright © 2022 ShareTrip. All rights reserved.
//

import Foundation
import UIKit

enum FlightBookingHistoryCellTypes {
    case detail
    case retryInfo
    case retryBooking
    case cancelBooking
    case resendVoucher
    case weight
    case info
    case traveler
    case price
    case airFareRule
    case baggage
    case fareDetail
    case supportCenter
    case cancelationPolicy
    case refund
    case void
    
    var title: String {
        switch self {
        case .retryBooking:
            return "RETRY PAYMENT"
        case .cancelBooking:
            return "CANCEL BOOKING"
        case .resendVoucher:
            return "RESEND VOUCHER"
        case .info:
            return "Flight Information"
        case .traveler:
            return "Traveller Information"
        case .price:
            return "Pricing Information"
        case .airFareRule:
            return "Air Fare Rules"
        case .baggage:
            return "Baggage Information"
        case .fareDetail:
            return "Fare Information"
        case .supportCenter:
            return "Support Center"
        case .cancelationPolicy:
            return "Cancelation Policy"
        case .refund:
            return "REFUND"
        case .void:
            return "VOID"
        default:
            return ""
        }
    }
    
    var titleColor: UIColor {
        switch self {
        case .retryBooking, .resendVoucher, .void, .cancelBooking, .refund:
            return .white
        default:
            return .clear
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .retryBooking, .resendVoucher, .void, .cancelBooking, .refund:
            return .appPrimary
        default:
            return .clear
        }
    }
}
