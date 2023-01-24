//
//  ViewController.swift
//  ShareTripSDK
//
//  Created by ST-iOS on 1/24/23.
//

import UIKit

public class ViewController: UIViewController {

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .appPrimary
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .semibold),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = UIColor.appPrimary
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.shadowColor = .clear
            
            navigationController?.navigationBar.tintColor = .white
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
            navigationController?.navigationBar.tintColor = .white
            navigationController?.navigationBar.barTintColor = UIColor.appPrimary
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
        }
    }

}
