//
//  FareCardSingleLineCell.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 01/12/2019.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

public class FareCardSingleLineCell: UITableViewCell {
    
    @IBOutlet private weak var priceImageView: UIImageView!
    @IBOutlet private weak var originPriceLabel: UILabel!
    @IBOutlet private weak var discountPariceLabel: UILabel!
    @IBOutlet private weak var discountLabel: UILabel!
    @IBOutlet private weak var refundableStatus: UILabel!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        discountLabel.isHidden = true
        priceImageView.layer.cornerRadius = priceImageView.frame.size.width/2
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func configure(
        currency: String,
        orginPrice: Double,
        discountPrice: Double,
        discount: Double,
        refundable: String
    ) {
        originPriceLabel.attributedText = "\(currency) \(orginPrice.withCommas())".strikeThrough()
        discountPariceLabel.text = "\(currency) \(discountPrice.withCommas())"
        refundableStatus.text = refundable
        
        if discount == 0 {
            discountPariceLabel.isHidden = true
            originPriceLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        } else {
            discountPariceLabel.isHidden = false
            originPriceLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        }
    }
}
