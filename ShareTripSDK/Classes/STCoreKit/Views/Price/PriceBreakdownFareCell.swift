//
//  PriceBreakdownFareCell.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 17/11/2019.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

public class PriceBreakdownFareCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var fareAmountLabel: UILabel!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func configure(title: String, fare: Double) {
        titleLabel.text = title
        fareAmountLabel.text = fare.withCommas()
    }
}
