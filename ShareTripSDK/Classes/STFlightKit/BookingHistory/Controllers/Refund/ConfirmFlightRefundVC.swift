//
//  ConfirmFlightRefundVC.swift
//  ShareTrip
//
//  Created by ST-iOS on 5/18/22.
//  Copyright © 2022 ShareTrip. All rights reserved.
//

import UIKit
import PKHUD


class ConfirmFlightRefundVC: UIViewController {
    
    @IBOutlet private weak var confimButton: UIButton! {
        didSet {
            confimButton.layer.cornerRadius = 8
            confimButton.clipsToBounds = true
        }
    }
    
    @IBOutlet private weak var cancelButton: UIButton! {
        didSet {
            cancelButton.layer.cornerRadius = 8
            cancelButton.clipsToBounds = true
        }
    }
    
    public var viewModel: FlightRefundConfirmViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItems(withTitle: "Booking Refund")
        
        viewModel.callback.didSuccessRefund = {[weak self] in
            HUD.hide(animated: true)
            let successVC = FlightRefundSuccessVC.instantiate()
            self?.navigationController?.pushViewController(successVC, animated: true)
        }
        
        viewModel.callback.didFailed = {[weak self] error in
            HUD.hide(animated: true)
            self?.showAlert(message: error)
        }
    }
    
    @IBAction private func didTapConfirmButton(_ sender: UIButton) {
        HUD.show(.progress)
        viewModel.confirmRefund()
    }
    
    @IBAction private func didTapCancelButton(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
}

extension ConfirmFlightRefundVC: StoryboardBased {
    static var storyboardName: String {
        return "FlightBooking"
    }
}
