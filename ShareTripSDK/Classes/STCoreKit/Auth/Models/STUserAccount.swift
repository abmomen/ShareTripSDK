//
//  STUserAccount.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/22/22.
//

import Foundation

public class STUserAccount: Codable {
    public var titleName: TitleType
    public var givenName: String
    public var surName: String
    public var designation: String
    public var address1: String
    public var address2: String?
    public var profession: String?
    public var mobileNumber: String
    public var avatar: String
    public var gender: GenderType?
    public var dateOfBirth: String?
    public let username: String
    public var email: String
    public var referralCode: String
    public var nationality: String
    public var passportNumber: String
    public var passportExpireDate: String?
    public var country: String
    public var postCode: String
    public var passport: String
    public var passportCopy: String
    public var visaCopy: String
    public var frequentFlyerNumber: String
    public var seatPreference: String
    public var mealPreference: String
    public var totalPoints: Int64
    public var redeemablePoints: Int64
    public var profileLevel: UserStatus?
    public var otherPassengers: [STPassenger]?
    public let coinSettings: CoinSettings?
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        titleName = try container.decodeIfPresent(TitleType.self, forKey: .titleName) ?? .mr
        givenName = try container.decodeIfPresent(String.self, forKey: .givenName) ?? ""
        surName = try container.decodeIfPresent(String.self, forKey: .surName) ?? ""
        designation = try container.decodeIfPresent(String.self, forKey: .designation) ?? ""
        address1 = try container.decodeIfPresent(String.self, forKey: .address1) ?? ""
        mobileNumber = try container.decodeIfPresent(String.self, forKey: .mobileNumber) ?? ""
        avatar = try container.decodeIfPresent(String.self, forKey: .avatar) ?? ""
        gender = try container.decodeIfPresent(GenderType.self, forKey: .gender)
        dateOfBirth = try container.decodeIfPresent(String.self, forKey: .dateOfBirth)
        username = try container.decodeIfPresent(String.self, forKey: .username) ?? ""
        email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
        referralCode = try container.decodeIfPresent(String.self, forKey: .referralCode) ?? ""
        nationality = try container.decodeIfPresent(String.self, forKey: .nationality) ?? ""
        passportNumber = try container.decodeIfPresent(String.self, forKey: .passportNumber) ?? ""
        passportExpireDate = try container.decodeIfPresent(String.self, forKey: .passportExpireDate)
        country = try container.decodeIfPresent(String.self, forKey: .country) ?? ""
        postCode = try container.decodeIfPresent(String.self, forKey: .postCode) ?? ""
        passport = try container.decodeIfPresent(String.self, forKey: .passport) ?? ""
        passportCopy = try container.decodeIfPresent(String.self, forKey: .passportCopy) ?? ""
        visaCopy = try container.decodeIfPresent(String.self, forKey: .visaCopy) ?? ""
        frequentFlyerNumber = try container.decodeIfPresent(String.self, forKey: .frequentFlyerNumber) ?? ""
        seatPreference = try container.decodeIfPresent(String.self, forKey: .givenName) ?? ""
        mealPreference = try container.decodeIfPresent(String.self, forKey: .mealPreference) ?? ""
        totalPoints = try container.decode(Int64.self, forKey: .totalPoints)
        redeemablePoints = try container.decode(Int64.self, forKey: .redeemablePoints)
        profileLevel = STUserAccount.UserStatus(rawValue: try container.decodeIfPresent(String.self, forKey: .profileLevel) ?? "")
        otherPassengers = try container.decodeIfPresent([STPassenger].self, forKey: .otherPassengers) ?? []
        coinSettings = try container.decodeIfPresent(CoinSettings.self, forKey: .coinSettings)
    }
    
    public func update(with baseUser: STUserProfile) {
        self.titleName = baseUser.titleName
        self.givenName = baseUser.givenName
        self.surName = baseUser.surName
        self.address1 = baseUser.address1
        self.address2 = baseUser.address2
        self.profession = baseUser.profession
        self.postCode = baseUser.postCode
        self.mobileNumber = baseUser.mobileNumber
        self.avatar = baseUser.avatar
        self.gender = baseUser.gender
        self.dateOfBirth = baseUser.dateOfBirth
        self.email = baseUser.email
        self.nationality = baseUser.nationality
        self.passportNumber = baseUser.passportNumber
        self.passportExpireDate = baseUser.passportExpireDate
        self.passportCopy = baseUser.passportCopy
        self.visaCopy = baseUser.visaCopy
        self.frequentFlyerNumber = baseUser.frequentFlyerNumber
    }
    
    public func getPassenger() -> STPassenger {
        let passenger = STPassenger(
            titleName: titleName,
            givenName: givenName,
            surName: surName,
            nationality: nationality,
            dateOfBirth: dateOfBirth ?? "",
            gender: gender ?? .male,
            passportNumber: passportNumber,
            passportExpireDate: passportExpireDate ?? "",
            frequentFlyerNumber: frequentFlyerNumber,
            passportCopy: passportCopy,
            visaCopy: visaCopy
        )
        passenger.address1 = address1
        passenger.postCode = postCode
        passenger.email = email
        passenger.mobileNumber = mobileNumber
        return passenger
    }
    
    public func getAgeCount() -> Int? {
        if let dateOfBirthStr = dateOfBirth, let dob = Date(fromString: dateOfBirthStr, format: .isoDate) {
            let age = Date().since(dob, in: .year)
            return Int(age)
        }
        return nil
    }
    
    
    public enum UserStatus: String, CaseIterable, Codable {
        case silver = "Silver"
        case gold = "Gold"
        case platinum = "Platinum"
        case unknown
    }
}
