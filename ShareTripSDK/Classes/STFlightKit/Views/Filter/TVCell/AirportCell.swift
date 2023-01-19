//
//  AirportCell.swift
//  ShareTrip
//
//  Created by Mac on 9/11/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

class AirportCell: UITableViewCell {
    
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var airportLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
