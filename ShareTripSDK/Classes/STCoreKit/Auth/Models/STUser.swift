//
//  STUser.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/22/22.
//

import Foundation

public struct STUser: Codable {
    public let token: String
    public let email: String
    public let username: String
    public let mobileNumber: String?
    public let title: String?
    public let firstName: String?
    public let lastName: String?
    public let designation: String?
    public let address: String?
    public let avatar: String?
    public let gender: Int?
    public let dob: String?
}

// MARK: - UserDeletionResponse
public struct AccountDeletionReason: Codable {
    public let id, text: String
}
