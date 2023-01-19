//
//  BookingHistoryOption.swift
//  STCoreKit
//
//  Created by ST-iOS on 12/4/22.
//

public enum BookingHistoryOption: Int {
    case hotel
    case flight
    case holiday
    case transport
    case tours
    case visa
    
    public var title: String {
        switch self {
        case .hotel:
            return "Hotel Booking"
        case .flight:
            return "Flight Booking"
        case .holiday:
            return "Holiday Booking"
        case .transport:
            return "Transfer Booking"
        case .tours:
            return "Tour Booking"
        case .visa:
            return "Visa Booking"
        }
    }
}
