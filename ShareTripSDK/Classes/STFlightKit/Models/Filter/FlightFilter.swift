//
//  FlightFilter.swift
//  STFlightKit
//
//  Created by ST-iOS on 11/20/22.
//



public class FlightFilter: Codable {
    public let airlines: [Airline]
    public let price: FlightPriceRange
    public let stoppages: [FlightStoppage]
    public let origin, destination, layover: [Airport]
    public let weight: [FlightWeight]
    public let departTimeSlot: [TimeSlot]
    public let returnTimeSlot: [TimeSlot]?
    public let refundable: Int?
    public let isRefundable: [IsRefundable]?

    enum CodingKeys: String, CodingKey {
        case price, airlines, origin, destination, layover, weight, refundable
        case departTimeSlot = "outbound"
        case returnTimeSlot = "return"
        case stoppages = "stop"
        case isRefundable
    }
    
    public struct IsRefundable: Codable {
        public let key: String
        public let value: Int
    }
}

public enum FlightFilterType: Int, CaseIterable {
    case reset
    case priceRange
    case refundble
    case schedule
    case stoppage
    case airline
    case layover
    case weight
    
    public var title: String {
        switch self {
        case .reset:
            return "Sort & Filter"
        case .priceRange:
            return "Price Range"
        case .schedule:
            return "Schedule"
        case .stoppage:
            return "Stops"
        case .airline:
            return "Airline"
        case .layover:
            return "Layover"
        case .weight:
            return "Weight"
        case .refundble:
            return "Refundable"
        }
    }
    
    public var subTitle: String {
        switch self {
        case .priceRange:
            return "10,000 - 500,000"
        default:
            return "Any"
        }
    }
    
    public var rowCount: Int {
        switch self {
        case .reset, .priceRange:
            return 1
        default:
            return 0
        }
    }
}

public enum ScheduleCellType {
    case title(text: String)
    case departTimeSlot(key: String, value: String)
    case returnTimeSlot(key: String, value: String)
    
    public var timeSlotKey: String? {
        switch self {
        case .title:
            return nil
        case .departTimeSlot(let key, _), .returnTimeSlot(let key, _):
            return key
        }
    }
    
    public func equalType(with scheduleCellType: ScheduleCellType) -> Bool {
        switch (self, scheduleCellType) {
        case ( .departTimeSlot(_, _), .departTimeSlot(_, _)):
            return true
        case ( .returnTimeSlot(_, _), .returnTimeSlot(_, _)):
            return true
        default:
            return false
        }
    }
}

public class FlightSearchFilter: Encodable {
    public let page: Int
    public let searchId: String
    public let filter: FlightFilterData?
    
    public init(page: Int, searchId: String, filter: FlightFilterData?) {
        self.page = page
        self.searchId = searchId
        self.filter = filter
    }
    
    public enum CodingKeys: String, CodingKey {
        case page
        case searchId
        case filter
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try? container.encode(page, forKey: .page)
        try? container.encode(searchId, forKey: .searchId)
        
        if let filter = filter, filter.hasAtleastOneFilter() {
            try? container.encodeIfPresent(filter, forKey: .filter)
        }
    }
}
