//
//  UserInfoRowType.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/20/22.
//

import UIKit

public enum UserInfoRowType: CaseIterable {
    case profileImage
    case nameInputGuideline
    case quickPick
    case givenName
    case surName
    case gender
    case dob
    case age
    case nationality
    case mobile
    case email
    case passportNumber
    case passportExpiryDate
    case frequentFlyerNumber
    case upload
    case warning
    case address
    case postCode
    case mealPreference
    case wheelChairRequest
    case covid19TestInfo
    case travelInsuranceService
    case addUpdateUserToQuickPick
    
    public var title: String {
        switch self {
        case .profileImage, .nameInputGuideline, .addUpdateUserToQuickPick:
            return ""
        case .quickPick:
            return "Select from Passenger Quick Pick"
        case .givenName:
            return "Given Name (First & Middle Name)"
        case .surName:
            return "Surname (Last Name)"
        case .gender:
            return "Select Your Gender"
        case .dob:
            return "Date of Birth"
        case .email:
            return "Email Address"
        case .mobile:
            return "Phone Number"
        case .nationality:
            return "Nationality"
        case .passportNumber:
            return "Passport Number"
        case .passportExpiryDate:
            return "Passport Expire Date"
        case .frequentFlyerNumber:
            return "Frequent Flyer Number (If any)"
        case .upload:
            return "Upload"
        case .address:
            return "Address"
        case .postCode:
            return "Post Code"
        case .age:
            return "Age"
        case .mealPreference:
            return "Select meal type (optional)"
        case .wheelChairRequest:
            return "Request wheelchair (optional)"
        case .covid19TestInfo:
            return "COVID-19 test (optional)"
        case .travelInsuranceService:
            return "Travel Insurance Service(optional)"
        case .warning:
            return ""
        }
    }
    
    public var placeholder: String {
        switch self {
        case .profileImage, .nameInputGuideline, .addUpdateUserToQuickPick:
            return ""
        case .quickPick:
            return "Select"
        case .givenName:
            return "Ex. Habibur"
        case .surName:
            return "Ex. Rahman"
        case .gender:
            return "Ex. Male"
        case .dob:
            return "Ex. 05-12-1985"
        case .email:
            return "habibur@gmail.com"
        case .mobile:
            return "Ex. 01710000000"
        case .nationality:
            return "Ex. Bangladesh"
        case .passportNumber:
            return "Ex. AG6546517"
        case .passportExpiryDate:
            return "Ex. 10-12-2021"
        case .frequentFlyerNumber:
            return "Ex. 99200018XXXX"
        case .upload:
            return ""
        case .address:
            return "Ex. H:45, Rd:13/C, Banani, Dhaka"
        case .postCode:
            return "Ex. 1213"
        case .age:
            return "Ex. 28"
        case .mealPreference, .wheelChairRequest, .covid19TestInfo, .travelInsuranceService, .warning:
            return ""
        }
    }
    
    public var imageString: String {
        switch self {
        case .profileImage, .nameInputGuideline, .addUpdateUserToQuickPick:
            return ""
        case .quickPick:
            return "people-mono"
        case .givenName:
            return "account-mono"
        case .surName:
            return "account-mono"
        case .gender:
            return "gender-mono"
        case .dob:
            return "calander-mono"
        case .email:
            return "inbox-mono"
        case .mobile:
            return "phone-mono"
        case .nationality:
            return "flag-mono"
        case .passportNumber:
            return "passport-mono"
        case .passportExpiryDate:
            return "calander-mono"
        case .frequentFlyerNumber:
            return "ffn-mono"
        case .upload:
            return "upload-mono"
        case .address:
            return "address-mono"
        case .postCode:
            return "postcode-mono"
        case .age:
            return "calander-mono"
        case .mealPreference, .wheelChairRequest, .covid19TestInfo, .travelInsuranceService, .warning:
            return ""
        }
    }
    
    public var keyboardType: UIKeyboardType {
        switch self {
        case .mobile:
            return .phonePad
        case .email:
            return .emailAddress
        default:
            return .default
        }
    }
    
    public var textContentType: UITextContentType? {
        switch self {
        case .mobile:
            return .telephoneNumber
        case .email:
            return .emailAddress
        default:
            return nil
        }
    }
}
