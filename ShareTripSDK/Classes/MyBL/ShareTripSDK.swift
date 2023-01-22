//
//  ShareTripSDK.swift
//  Pods
//
//  Created by ST-iOS on 1/19/23.
//

import Foundation

public final class ShareTripSDK {
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
