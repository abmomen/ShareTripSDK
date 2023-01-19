//
//  FlightInfoHeaderView.swift
//  TBBD
//
//  Created by Mac on 4/24/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

class FlightInfoHeaderView: UITableViewHeaderFooterView {
    @IBOutlet weak var fromCodeLabel: UILabel!
    func configure(title: String) {
        fromCodeLabel.text = title
    }
}
