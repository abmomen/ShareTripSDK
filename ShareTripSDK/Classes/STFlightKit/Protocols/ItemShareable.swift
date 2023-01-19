//
//  FlightShareable.swift
//  STFlightKit
//
//  Created by ST-iOS on 11/29/22.
//

import UIKit


public protocol ItemShareable {
    func share(for serviceType: ServiceType)
}

public extension ItemShareable where Self: UIViewController {
    func share(for serviceType: ServiceType) {
        FlightAPIClient().getShareLink(for: serviceType) {[weak self] result in
            switch result {
            case .success(let response):
                
                STAppManager.shared.updateUserInfoBy(adding: response.earnedCoin, completion: { user in
                    if let totalPoints = user?.totalPoints {
                        self?.navigationItem.rightBarButtonItem = TripCoinBarButtonItem.createWithText(totalPoints.withCommas())
                    }
                })
                self?.showAlert(message: "Shared Successfully")
                
            case .failure(let error):
                self?.showAlert(message: error.localizedDescription)
            }
        }
    }
}
