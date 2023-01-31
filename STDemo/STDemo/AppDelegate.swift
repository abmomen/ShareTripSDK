//
//  AppDelegate.swift
//  STDemo
//
//  Created by ST-iOS on 1/30/23.
//

import UIKit
import ShareTripSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UISceneDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        STSDK.configure("$2b$10$pv.ZAnzyuSTD7GIMm/yHL.hdPTFQgUDN2rfXPnQXh67e4JsKJ0Fl.")
        window?.rootViewController =  UINavigationController(rootViewController: MyBLHomeVC.instantiate())
        
        window?.makeKeyAndVisible()
        
        return true
    }

}

