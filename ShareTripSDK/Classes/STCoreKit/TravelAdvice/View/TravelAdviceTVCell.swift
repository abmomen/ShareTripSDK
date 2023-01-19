//
//  TravelAdviceTVCell.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 16/11/2020.
//  Copyright © 2020 ShareTrip. All rights reserved.
//

import UIKit

class TravelAdviceTVCell: UITableViewCell {

    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var headlineLabel: UILabel!
    @IBOutlet weak private var infoLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 8.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
