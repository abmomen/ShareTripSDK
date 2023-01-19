//
//  STUserSession.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/22/22.
//

import SwiftKeychainWrapper

public class STUserSession {
    private var savedUser: STUser?
    
    public static var current = STUserSession()
    
    public var authToken: AuthToken? {
        get {
            KeychainWrapper.standard.codableObject(forKey: KeychainWrapper.Key.authToken.rawValue)
        }
        set {
            KeychainWrapper.standard.set(newValue, forKey: KeychainWrapper.Key.authToken.rawValue)
        }
    }
    
    public var user: STUser? {
        get {
            KeychainWrapper.standard.codableObject(forKey: KeychainWrapper.Key.user.rawValue)
        }
        set {
            KeychainWrapper.standard.set(newValue, forKey: KeychainWrapper.Key.user.rawValue)
        }
    }
    
    public var appleAuthorizationCode: String? {
        get {
            KeychainWrapper.standard.codableObject(forKey: KeychainWrapper.Key.appleAuthorizationCode.rawValue)
        }
        set {
            KeychainWrapper.standard.set(newValue, forKey: KeychainWrapper.Key.appleAuthorizationCode.rawValue)
        }
    }
    
    public func isUserLoggedIn() -> Bool {
        guard let authToken = authToken else { return false }
        return !authToken.accessToken.isReallyEmpty && authToken.loginType != .skipped
    }
    
    public func clear() {
        authToken = nil
        savedUser = nil
        appleAuthorizationCode = nil
        
        let defaults = UserDefaults.standard
        defaults.set(nil, forKey: Constants.App.treasureBoxEarnTime)
        defaults.set(nil, forKey: Constants.App.treasureBoxWaitTime)
        defaults.set(nil, forKey: Constants.UserDefaultKey.lastQuizOpeningTime)
        defaults.synchronize()
    }
}
