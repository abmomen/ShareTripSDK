//
//  AccountCellInfo.swift
//  ShareTrip
//
//  Created by Mac on 2/27/20.
//  Copyright © 2020 TBBD IOS. All rights reserved.
//

import Foundation

public enum AccountCellInfo {
    case login
    case editProfile
    case quickPick
    case referEarn
    case leaderboard
    case changePassword
    case savedCards
    case visaTrack
    case logout
    
    case manageData
    case writeReview
    case faq
    case support
    case terms
    case privacy
    case contact
    
    public var title: String {
        switch self {
        case .login:
            return "Login"
        case .editProfile:
            return "Edit Profile"
        case .quickPick:
            return "Favourite Guest List"
        case .referEarn:
            return "Refer & Earn"
        case .leaderboard:
            return "Leaderboard"
        case .changePassword:
            return "Change Password"
        case .savedCards:
            return "Saved Cards"
        case .visaTrack:
            return "Visa Application Tracker"
        case .logout:
            return "Logout"
        
        case .manageData:
            return "Manage Data"
        case .writeReview:
            return "Write a Review"
        case .faq:
            return "FAQ"
        case .support:
            return "Support"
        case .terms:
            return "Terms & Conditions"
        case .privacy:
            return "Privacy Policy"
        case .contact:
            return "Contact Us"
        }
    }
    
    public static var topSection: [AccountCellInfo] {
        return [.editProfile, .quickPick, .referEarn, .leaderboard, .changePassword, .savedCards, .visaTrack, .manageData, .logout]
    }
    
    public static var bottomSecion: [AccountCellInfo] {
        return [.writeReview, .support, .terms, .privacy, .faq, .contact]
    }
}
