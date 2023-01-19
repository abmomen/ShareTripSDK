//
//  UIViewControllerExtension.swift
//  STCoreKit
//
//  Created by ST-iOS on 12/4/22.
//

import UIKit

//setup navigation items
public extension UIViewController {
    func setupNavigationItems(withTitle title: String) {
        navigationItem.title = title
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        if let totalPoints = STAppManager.shared.userAccount?.totalPoints {
            navigationItem.rightBarButtonItem = TripCoinBarButtonItem.createWithText(totalPoints.withCommas())
        }
    }
    
    func setupNavWithoutRightBarItem(withTitle title: String){
        navigationItem.title = title
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
    }
    
}
