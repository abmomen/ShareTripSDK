//
//  SeatAndBagageInfoCardCell.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 01/12/2019.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

class SeatAndBagageInfoCardCell: UITableViewCell {
    @IBOutlet private weak var seatLabel: UILabel!
    @IBOutlet private weak var weightLabel: UILabel!

    @IBOutlet private weak var seatsImageView: UIImageView!
    @IBOutlet private weak var baggageImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        seatsImageView.image = UIImage(named: "seat-mono")
        baggageImageView.image = UIImage(named: "baggage-mono")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(availableSeats: Int, weightStr: String) {
        seatLabel.text = "\(availableSeats) " + "Seat".getPlural(availableSeats > 1)
        weightLabel.text = weightStr
    }
}
