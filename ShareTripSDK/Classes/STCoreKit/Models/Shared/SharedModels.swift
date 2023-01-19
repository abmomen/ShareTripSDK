//
//  SharedModels.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/20/22.
//

import Foundation

public enum Currency: String, Codable {
    case bdt = "BDT"
    case usd = "USD"
    case undefined
}

public enum DurationType: String, Codable {
    case days = "DAYS"
    case hours = "HOURS"
}

public enum Featured: String, Codable {
    case yes = "YES"
}

public enum Language: String, Codable {
    case en = "EN"
}

public enum Status: String, Codable {
    case active = "ACTIVE"
}

// MARK: - PriceRange
public struct PriceRange: Codable {
    public let min, max: Int
    
    public init(min: Int, max: Int) {
        self.min = min
        self.max = max
    }
}

// MARK: - Points
public struct Points: Codable {
    public let earning, shared: Int
    public let shareLink: String
}

// MARK: - Image
public struct Image: Codable {
    public let srcLarge, srcMedium, srcThumb: String
}

public enum TransportType: CaseIterable {
    case airlines, cruise, boat, train
    
    public var title: String {
        switch self {
        case .airlines:
            return "Airlines"
        case .cruise:
            return "Cruise"
        case .boat:
            return "Boat"
        case .train:
            return "Train"
        }
    }
    
    public var placeholder: String {
        switch self {
        case .airlines:
            return "Biman Bangladesh"
        case .cruise:
            return "Keari Sindabad"
        case .boat:
            return "Country Boat"
        case .train:
            return "Sundarban Express"
        }
    }
}

public struct Transport {
    public var type: TransportType
    public var name: String?
    public var code: String?
}

public struct DiscountOption: Codable {
    public let type: DiscountOptionType
    public let title: String
    public let subtitle: String
}

public enum DiscountOptionType: String, Codable {
    case earnTC = "earnTC"
    case redeemTC = "redeemTC"
    case useCoupon = "useCoupon"
    case unknown
    
    public var title: String {
        switch self {
        case .earnTC:
            return "I want to earn TripCoin"
        case .redeemTC:
            return "I want to redeem TripCoin"
        case .useCoupon:
            return "I want to use Coupon"
        case .unknown:
            return ""
        }
    }
}

public struct UrlOption: Codable {
    public let service_type: ServiceType
    public let status: PaymentConfirmationType
    public let url: String
}

public struct BooleanConvertible: Codable, ExpressibleByBooleanLiteral {
    public let value: Bool
    
    public init(booleanLiteral value: Bool) {
        self.value = value
    }
    
    public init(from decoder: Decoder) throws {
        if let stringValue = try? decoder.singleValueContainer().decode(String.self) {
            self.value = stringValue.boolValue
        } else if let intValue = try? decoder.singleValueContainer().decode(Int.self) {
            self.value = intValue.boolValue
        } else {
            self = false
        }
    }
}

extension BooleanConvertible: Equatable {
    public static func ==(lhs: BooleanConvertible, rhs: BooleanConvertible) -> Bool {
        return lhs.value == rhs.value
    }
    
    public static func ==(lhs: BooleanConvertible, rhs: Bool) -> Bool {
        return lhs.value == rhs
    }
}
