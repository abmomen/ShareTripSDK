//
//  ShareTripSDK.swift
//  Pods
//
//  Created by ST-iOS on 1/19/23.
//

import UIKit
import FirebaseCore
import IQKeyboardManagerSwift

public final class ShareTripSDK {
    private static var accessToken = ""
    public static var theme: SDKColorThemes = .sharetrip
    
    public static func configure(_ accessToken: String) {
        FirebaseApp.configure()
        self.accessToken = accessToken
        self.theme = .banglalink
        IQKeyboardManager.shared.enable = true
        STUserSession.current.authToken = AuthToken(accessToken: accessToken, loginType: .phone)
    }
}

public enum SDKColorThemes {
    case sharetrip
    case banglalink
}

extension ShareTripSDK {
    static let bundle: Bundle = {
        let myBundle = Bundle(for: ShareTripSDK.self)
        
        guard let resourceBundleURL = myBundle.url(forResource: "ShareTripSDK", withExtension: "bundle") else {
            fatalError("ShareTripSDK.bundle not found!")
        }
        
        guard let resourceBundle = Bundle(url: resourceBundleURL) else {
            fatalError("Cannot access MySDK.bundle!")
        }
        
        return resourceBundle
    }()
}
