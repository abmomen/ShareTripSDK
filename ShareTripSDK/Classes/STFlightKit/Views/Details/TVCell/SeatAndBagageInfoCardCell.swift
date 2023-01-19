//
//  SeatAndBagageInfoCardCell.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 01/12/2019.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

class SeatAndBagageInfoCardCell: UITableViewCell {
    @IBOutlet weak var seatLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(availableSeats: Int, weightStr: String) {
        seatLabel.text = "\(availableSeats) " + "Seat".getPlural(availableSeats > 1)
        weightLabel.text = weightStr
    }
}
