//
//  SingleCellTripCoinView.swift
//  ShareTrip
//
//  Created by Nazmul Islam on 7/30/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

public class SingleCellTripCoinView: UIView, NibBased {
    
    @IBOutlet private weak var earnedTripCoinLabel: UILabel!
    @IBOutlet private weak var redeemTripCoinLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    
    public func configure(earnedTripCoin: Int, redeemedTripCoin: Int) {
        self.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = 8.0
        containerView.clipsToBounds = true
        earnedTripCoinLabel.text = earnedTripCoin.withCommas()
        redeemTripCoinLabel.text = redeemedTripCoin.withCommas()
    }
}
