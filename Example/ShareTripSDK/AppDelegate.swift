//
//  AppDelegate.swift
//  ShareTripSDK
//
//  Created by 20514535 on 01/19/2023.
//  Copyright (c) 2023 20514535. All rights reserved.
//

import UIKit
import ShareTripSDK
import FirebaseCore
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = NavigationController(rootViewController: FlightSearchVC.instantiate())
        
        STUserSession.current.authToken = AuthToken(
            accessToken: "$2b$10$pv.ZAnzyuSTD7GIMm/yHL.hdPTFQgUDN2rfXPnQXh67e4JsKJ0Fl.",
            loginType: .email
        )
        // Enable IQKeyboardManager
        IQKeyboardManager.shared.enable = true
        
        window?.rootViewController = MyBLHomeVC.instantiate() //navigationController
        window?.makeKeyAndVisible()
        
        FirebaseApp.configure()
        
        return true
    }

}

