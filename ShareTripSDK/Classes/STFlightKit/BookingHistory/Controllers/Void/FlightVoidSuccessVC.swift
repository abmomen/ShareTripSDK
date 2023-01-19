//
//  FlightVoidSuccessVC.swift
//  ShareTrip
//
//  Created by ST-iOS on 5/18/22.
//  Copyright © 2022 ShareTrip. All rights reserved.
//

import UIKit


class FlightVoidSuccessVC: UIViewController {
    
    @IBOutlet private weak var backButton: UIButton! {
        didSet {
            backButton.layer.cornerRadius = 8
            backButton.clipsToBounds = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItems(withTitle: "Confirmation")
    }
    
    @IBAction private func didTapGoBack(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }

}

extension FlightVoidSuccessVC: StoryboardBased {
    static var storyboardName: String {
        return "FlightBooking"
    }
}
