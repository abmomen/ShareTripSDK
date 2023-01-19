//
//  PriceViewCell.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 07/11/2019.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

public class PriceViewCell: UITableViewCell {
    
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var priceAfterDiscountLabel: UILabel!
    @IBOutlet private weak var discountLabel: UILabel!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func configure(priceStr: String, priceAfterDiscountStr: String?, discountPercentageStr: String?) {
        
        selectionStyle = .none
        
        priceLabel.text = priceStr
        if let priceAfterDiscountStr = priceAfterDiscountStr,
           let discountPercentageStr = discountPercentageStr {
            priceAfterDiscountLabel.text = priceAfterDiscountStr
            discountLabel.text = discountPercentageStr
        } else {
            priceAfterDiscountLabel.isHidden = true
            priceAfterDiscountLabel.heightAnchor.constraint(equalToConstant: 0).isActive = true
            discountLabel.isHidden = true
            discountLabel.heightAnchor.constraint(equalToConstant: 0).isActive = true
        }
    }
}
