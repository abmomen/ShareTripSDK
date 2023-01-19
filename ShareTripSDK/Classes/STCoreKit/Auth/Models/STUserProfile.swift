//
//  STUserProfile.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/22/22.
//

import Foundation

public class STUserProfile: Codable {
    public let titleName: TitleType
    public let givenName: String
    public let surName: String
    public let address1: String
    public let address2: String? = nil
    public let profession: String? = nil
    public let postCode: String
    public let mobileNumber: String
    public let avatar: String
    public let gender: GenderType?
    public let dateOfBirth: String?
    public let username: String
    public let email: String
    public let nationality: String
    public let passportNumber: String
    public let passportExpireDate: String?
    public let passportCopy: String
    public let visaCopy: String
    public let frequentFlyerNumber: String
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        titleName = try container.decodeIfPresent(TitleType.self, forKey: .titleName) ?? .mr
        givenName = try container.decodeIfPresent(String.self, forKey: .givenName) ?? ""
        surName = try container.decodeIfPresent(String.self, forKey: .surName) ?? ""
        address1 = try container.decodeIfPresent(String.self, forKey: .address1) ?? ""
        postCode = try container.decodeIfPresent(String.self, forKey: .postCode) ?? ""
        mobileNumber = try container.decodeIfPresent(String.self, forKey: .mobileNumber) ?? ""
        avatar = try container.decodeIfPresent(String.self, forKey: .avatar) ?? ""
        gender = try container.decodeIfPresent(GenderType.self, forKey: .gender)
        dateOfBirth = try container.decodeIfPresent(String.self, forKey: .dateOfBirth)
        username = try container.decodeIfPresent(String.self, forKey: .username) ?? ""
        email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
        nationality = try container.decodeIfPresent(String.self, forKey: .nationality) ?? ""
        passportNumber = try container.decodeIfPresent(String.self, forKey: .passportNumber) ?? ""
        passportExpireDate = try container.decodeIfPresent(String.self, forKey: .passportExpireDate)
        passportCopy = try container.decodeIfPresent(String.self, forKey: .passportCopy) ?? ""
        visaCopy = try container.decodeIfPresent(String.self, forKey: .visaCopy) ?? ""
        frequentFlyerNumber = try container.decodeIfPresent(String.self, forKey: .frequentFlyerNumber) ?? ""
    }
}
