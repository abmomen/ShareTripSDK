//
//  SavedCardDetails.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/29/22.
//

public struct SavedCardDetails: Codable {
    public let uid: String?
    public let customer: String?
    public let platform: String?
    public let number: String?
    public let details: CardDetails?
    public let tokenExpiry: String?
    
    public init(
        uid: String?,
        customer: String?,
        platform: String?,
        number: String?,
        details: CardDetails?,
        tokenExpiry: String?
    ) {
        self.uid = uid
        self.customer = customer
        self.platform = platform
        self.number = number
        self.details = details
        self.tokenExpiry = tokenExpiry
    }
}

public struct CardDetails: Codable {
    public let bank: String?
    public let brand: String?
    public let length: Int?
    public let logo: LogoSize?
    
    init(bank: String?, brand: String?, length: Int?, logo: LogoSize?) {
        self.bank = bank
        self.brand = brand
        self.length = length
        self.logo = logo
    }
}

