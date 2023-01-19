//
//  WarningMessageCell.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 6/22/20.
//  Copyright © 2020 ShareTrip. All rights reserved.
//

import UIKit

class WarningMessageCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var messageLabel: UILabel!

    func configure(with text: String) {
        messageLabel.text = text
        containerView.layer.cornerRadius = 8.0
    }
    
}
