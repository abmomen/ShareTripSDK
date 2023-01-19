//
//  WhitishNavigationController.swift
//  STCoreKit
//
//  Created by ST-iOS on 12/5/22.
//

import UIKit

public class WhitishNavigationController: UINavigationController {
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .offWhiteLight
        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .semibold),
            NSAttributedString.Key.foregroundColor: UIColor.greyishBrown
        ]
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = .offWhiteLight
            appearance.titleTextAttributes = [.foregroundColor: UIColor.greyishBrown]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.greyishBrown]
            
            navigationBar.tintColor = .greyishBrown
            navigationBar.standardAppearance = appearance
            navigationBar.compactAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
        } else {
            
            navigationBar.tintColor = .greyishBrown
            navigationBar.barTintColor = UIColor.appPrimary
            navigationBar.isTranslucent = false
        }
    }
}

