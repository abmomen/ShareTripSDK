//
//  PaymentGateway.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/22/22.
//

import Foundation

public struct PaymentGateway: Codable {
    public let id: String?
    public let name: String?
    public let code: String?
    public let type: String?
    public let currency: GatewayCurrency
    public let logo: LogoSize
    public let couponApplicable: Bool?
    public let earnTripcoinApplicable: Bool?
    public let redeemTripcoinApplicable: Bool?
    public let series: [GatewaySeries]
    public let charge: Double?
    
    public var isUSDPayment: Bool {
        guard let code = currency.code?.lowercased() else { return false }
        let usd = PaymentGatewayCurrency.usd.rawValue.lowercased()
        return code == usd
    }
    
    public enum CodingKeys: String, CodingKey {
        case id, name, logo, series, code, type, currency, charge
        case couponApplicable = "coupon_applicable"
        case earnTripcoinApplicable = "earn_tripcoin_applicable"
        case redeemTripcoinApplicable = "redeem_tripcoin_applicable"
    }
}

public struct GatewayCurrency: Codable {
    public let code: String?
    public let conversion: Conversion
}

public struct Conversion: Codable {
    public let rate: Double?
    public let code: String?
}

public struct LogoSize: Codable {
    public let small: String
    public let medium: String
    public let large: String
}

public struct GatewaySeries: Codable {
    public let id: String
    public let length: Int
    public let series: String
}

public enum PaymentGatewayType: String {
    case visa = "visa"
    case flight = "flight"
    case hotel = "hotel"
    case transfer = "transfer"
    case tour = "tour"
    case holiday = "Package"
}

public enum PaymentGatewayCurrency: String, Codable {
    case all = "ALL"
    case usd = "USD"
    case bdt = "BDT"
}
