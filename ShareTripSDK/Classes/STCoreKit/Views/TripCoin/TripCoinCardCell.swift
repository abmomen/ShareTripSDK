//
//  TripCoinCardCell.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 01/12/2019.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

public class TripCoinCardCell: UITableViewCell {
    
    @IBOutlet private weak var earnTripcoinLabel: UILabel!
    @IBOutlet private weak var redeemTripcoinLabel: UILabel!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func configure(earnedTripCoin: Int, redeemedTripCoin: Int) {
        earnTripcoinLabel.text = earnedTripCoin.withCommas()
        redeemTripcoinLabel.text = redeemedTripCoin.withCommas()
    }
}
