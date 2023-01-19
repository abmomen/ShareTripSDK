//
//  PaymentConfirmationVC.swift
//  TBBD
//
//  Created by Mac on 5/20/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit
import PKHUD

public class PaymentConfirmationVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet private weak var statusImageViewContainer: UIView!
    @IBOutlet private weak var statusImageView: UIImageView!
    
    @IBOutlet private weak var statusTitleLabel: UILabel!
    @IBOutlet private weak var statusDetailsLabel: UILabel!
    @IBOutlet private weak var tripCoinStackView: UIStackView!
    @IBOutlet private weak var stackViewHeightLC: NSLayoutConstraint!
    @IBOutlet private weak var earnTripCoinLabel: UILabel!
    @IBOutlet private weak var redeemTripCoinLabel: UILabel!
    @IBOutlet private weak var shareTripCoinLabel: UILabel!
    @IBOutlet private weak var retryButton: UIButton!
    
    public var paymentConfirmationData: PaymentConfirmationData!
    
    private let analytics: AnalyticsManager = {
        let fae = FirebaseAnalyticsEngine()
        let manager = AnalyticsManager([fae])
        return manager
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        FireEvents()
        
        switch paymentConfirmationData.confirmationType {
        case .success:
            scheduleLocalNotification()
            STAppManager.shared.getUserInfo { [weak self] response in
                if let user = response?.response {
                    self?.navigationItem.rightBarButtonItem = TripCoinBarButtonItem.createWithText(user.totalPoints.withCommas())
                }
            }
        case .failed:
            break
        }
    }
    
    //MARK:- IBAction
    @IBAction private func retryButtonTapped(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc
    private func homeButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK:- SetupViews
    private func setupViews(){
        title = "Confirmation"
        
        if let totalPoints = STAppManager.shared.userAccount?.totalPoints {
            navigationItem.rightBarButtonItem = TripCoinBarButtonItem.createWithText(totalPoints.withCommas())
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "home-mono"),
            style: UIBarButtonItem.Style.plain,
            target: self, action: #selector(homeButtonTapped(_:))
        )
        
        let view = tripCoinStackView.arrangedSubviews[1]
        view.isHidden = true
        stackViewHeightLC.constant = stackViewHeightLC.constant/2
        
        statusImageView.tintColor = .white
        
        statusImageViewContainer.layer.cornerRadius = statusImageViewContainer.bounds.size.height/2
        statusImageViewContainer.clipsToBounds = true
        
        retryButton.layer.cornerRadius = 4
        
        switch paymentConfirmationData.confirmationType {
        case .success:
            statusImageViewContainer.backgroundColor = UIColor.midGreen
            statusImageView.image = UIImage(named: "done-mono")
            retryButton.setTitle("Home", for: .normal)
            statusTitleLabel.text = "Booking Succeed!"
            statusDetailsLabel.text = "Congratulations. Thank you for\nthe booking"
        case .failed:
            statusImageViewContainer.backgroundColor = UIColor.orangeyRed
            statusImageView.image = UIImage(named: "close-mono")
            retryButton.setTitle("Home", for: .normal)
            statusTitleLabel.text =  "Booking Declined!"
            statusDetailsLabel.text = "Don't worry. Please enter all your\nvalid data and try again."
        }
        earnTripCoinLabel.text = String(paymentConfirmationData.earnTripCoin)
        redeemTripCoinLabel.text = String(paymentConfirmationData.redeemTripCoin)
        shareTripCoinLabel.text = "Get More \(paymentConfirmationData.shareTripCoin) TripCoin"
        
    }
    
    private func scheduleLocalNotification() {
        let title = "Upcoming Flight Alert"
        let subTitle = "Your Flight is within 6 hours please get prepared"
        switch paymentConfirmationData.serviceType {
        case .flight:
            for components in paymentConfirmationData.notifierSchedules {
                let localNotifier = LocalNotifier()
                localNotifier.scheduleNotification(title: title, subtitle: subTitle, dateComponent: components)
            }
        default:
            return
        }
    }
    
    func showAppReviewRequest() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            if UIApplication.topViewController is PaymentConfirmationVC {
                AppStoreReviewManager.requestReviewIfAppropriate(host: self, force: true)
            }
        }
    }
    
    //MARK: - FirebaseEvents
    private func FireEvents() {
        if paymentConfirmationData.confirmationType == .success {
            switch paymentConfirmationData.serviceType {
            case .hotel:
                analytics.log(PaymentConfirmationEvents.paymentCompleteHotel)
            case .flight:
                analytics.log(PaymentConfirmationEvents.paymentCompleteFlight)
            case .package:
                analytics.log(PaymentConfirmationEvents.paymentCompleteHoliday)
            case .visa:
                analytics.log(PaymentConfirmationEvents.paymentCompleteVisa)
            default:
                break
            }
        } else {
            switch paymentConfirmationData.serviceType {
            case .hotel:
                analytics.log(PaymentConfirmationEvents.paymentFailedHotel)
            case .flight:
                analytics.log(PaymentConfirmationEvents.paymentFailedFlight)
            case .package:
                analytics.log(PaymentConfirmationEvents.paymentFailedHoliday)
            case .visa:
                analytics.log(PaymentConfirmationEvents.paymentFailedVisa)
            default:
                break
            }
        }
    }
}
