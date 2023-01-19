//
//  KeychainWrapperExtension.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/22/22.
//

import SwiftKeychainWrapper

public extension KeychainWrapper.Key {
    static let authToken = KeychainWrapper.Key(rawValue: "auth-token")
    static let user = KeychainWrapper.Key(rawValue: "user")
    static let appleAuthorizationCode = KeychainWrapper.Key(rawValue: "apple_authorization_code")
}

public extension KeychainWrapper {
    @discardableResult
    func set<T: Codable>(
        _ value: T?,
        forKey key: String,
        withAccessibility accessibility: KeychainItemAccessibility? = nil,
        isSynchronizable: Bool = false
    ) -> Bool {
        guard let object = value else {
            removeObject(
                forKey: key,
                withAccessibility: accessibility,
                isSynchronizable: isSynchronizable
            )
            return true
        }
        guard let data = try? JSONEncoder().encode(object) else { return false }
        return set(
            data,
            forKey: key,
            withAccessibility: accessibility,
            isSynchronizable: isSynchronizable
        )
    }

    func codableObject<T: Codable>(
        forKey key: String,
        withAccessibility accessibility: KeychainItemAccessibility? = nil,
        isSynchronizable: Bool = false
    ) -> T? {
        guard let data = data(
            forKey: key,
            withAccessibility: accessibility,
            isSynchronizable: isSynchronizable
        ),
            let object = try? JSONDecoder().decode(T.self, from: data) else { return nil }
        return object
    }
}

