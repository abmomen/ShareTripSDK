//
//  STPassenger.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/22/22.
//

import Foundation

public class STPassenger: Codable {
    public var code: String
    public let titleName: TitleType
    public let givenName: String
    public let surName: String
    public let nationality: String
    public let gender: GenderType
    public let dateOfBirth: String
    public let passportNumber: String?
    public let passportExpireDate: String?
    public let frequentFlyerNumber: String?
    public let passportCopy: String?
    public let visaCopy: String?
    
    //FIXME: Quick Fix
    public var address1: String = ""
    public var postCode: String = ""
    public var email: String = ""
    public var mobileNumber: String = ""
    public var address2: String = ""
    public var profession: String = ""
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        code = try container.decode(String.self, forKey: .code)
        titleName = try container.decode(TitleType.self, forKey: .titleName)
        givenName = try container.decodeIfPresent(String.self, forKey: .givenName) ?? ""
        surName = try container.decodeIfPresent(String.self, forKey: .surName) ?? ""
        nationality = try container.decodeIfPresent(String.self, forKey: .nationality) ?? ""
        gender = try container.decode(GenderType.self, forKey: .gender)
        dateOfBirth = try container.decodeIfPresent(String.self, forKey: .dateOfBirth) ?? ""
        passportNumber = try container.decodeIfPresent(String.self, forKey: .passportNumber) ?? ""
        passportExpireDate = try container.decodeIfPresent(String.self, forKey: .passportExpireDate) ?? ""
        frequentFlyerNumber = try container.decodeIfPresent(String.self, forKey: .frequentFlyerNumber)
        passportCopy = try container.decodeIfPresent(String.self, forKey: .passportCopy)
        visaCopy = try container.decodeIfPresent(String.self, forKey: .visaCopy)
        
        if let mobileNumber = try container.decodeIfPresent(String.self, forKey: .mobileNumber) {
            self.mobileNumber = mobileNumber
        }
        if let email = try container.decodeIfPresent(String.self, forKey: .email) {
            self.email = email
        }
    }
    
    public init(
        titleName: TitleType,
        givenName: String,
        surName: String,
        nationality: String,
        dateOfBirth: String,
        gender: GenderType,
        passportNumber: String?,
        passportExpireDate: String?,
        frequentFlyerNumber: String?,
        passportCopy: String?,
        visaCopy: String?
    ) {
        self.code = ""
        self.titleName = titleName
        self.givenName = givenName
        self.surName = surName
        self.nationality = nationality
        self.gender = gender
        self.dateOfBirth = dateOfBirth
        
        self.passportNumber = passportNumber
        self.passportExpireDate = passportExpireDate
        self.frequentFlyerNumber = frequentFlyerNumber
        self.passportCopy = passportCopy
        self.visaCopy = visaCopy
    }
    
    public func getAgeCount() -> Int? {
        if let dob = Date(fromString: dateOfBirth, format: .isoDate) {
            let age = Date().since(dob, in: .year)
            return Int(age)
        }
        return nil
    }
}
