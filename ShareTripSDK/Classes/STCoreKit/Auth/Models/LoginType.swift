//
//  LoginType.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/22/22.
//

import Foundation

public enum LoginType: Codable {
    case email
    case apple
    case phone
    case google
    case skipped
    case facebook
}

public struct AuthToken: Codable {
    public let accessToken: String
    public let loginType: LoginType
    
    public init(accessToken: String, loginType: LoginType) {
        self.accessToken = accessToken
        self.loginType = loginType
    }
}
