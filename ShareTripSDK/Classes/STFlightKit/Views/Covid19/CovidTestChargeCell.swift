//
//  CovidTestChargeCell.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 04/03/2021.
//  Copyright © 2021 ShareTrip. All rights reserved.
//

import UIKit

class CovidTestChargeCell: UITableViewCell {

    @IBOutlet weak private var amountLabel: UILabel!
    @IBOutlet weak var amountTextLabel: UILabel!
    @IBOutlet weak var headerDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func config(amountText: NSMutableAttributedString, text: String, description: String){
        amountLabel.attributedText = amountText
        amountTextLabel.text = text
        headerDescriptionLabel.text = description
    }
}
