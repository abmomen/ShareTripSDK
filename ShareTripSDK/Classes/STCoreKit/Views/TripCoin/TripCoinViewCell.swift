//
//  TripCoinViewCell.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 07/11/2019.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

public class TripCoinViewCell: UITableViewCell {
    
    @IBOutlet private weak var earnedTripCoinLabel: UILabel!
    @IBOutlet private weak var redeemTripCoinLabel: UILabel!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func configure(earnedTripCoin: Int, redeemedTripCoin: Int) {
        selectionStyle = .none
        earnedTripCoinLabel.text = earnedTripCoin.withCommas()
        redeemTripCoinLabel.text = redeemedTripCoin.withCommas()
    }
}
