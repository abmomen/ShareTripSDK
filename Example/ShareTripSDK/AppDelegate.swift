//
//  AppDelegate.swift
//  ShareTripSDK
//
//  Created by 20514535 on 01/19/2023.
//  Copyright (c) 2023 20514535. All rights reserved.
//

import UIKit
import ShareTripSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MyBLHomeVC.instantiate()
        window?.makeKeyAndVisible()
        
        return true
    }

}

