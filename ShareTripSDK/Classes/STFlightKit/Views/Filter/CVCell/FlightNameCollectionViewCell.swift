//
//  FlightNameCollectionViewCell.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 6/28/20.
//  Copyright © 2020 ShareTrip. All rights reserved.
//

import UIKit
import Kingfisher

class FlightNameCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var airlineImageView: UIImageView!
    @IBOutlet weak var airlineCodeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var cellSeparatorView: UIView!
    @IBOutlet weak var selectedIndicatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(airlineCode: String, round: Int, isLastCell: Bool, isSelected: Bool) {
        containerView.layer.cornerRadius = 2.0
        cellSeparatorView.backgroundColor = .blueGray
        airlineImageView.tintColor = .appPrimary
        if isLastCell {
            cellSeparatorView.isHidden = true
        } else {
            cellSeparatorView.isHidden = false
        }
        let urlString: String? = "https://tbbd-flight.s3.ap-southeast-1.amazonaws.com/airlines-logo/\(airlineCode).png"

        let placeholder = UIImage(named: "placeholder-mono")
        if let imageUrlStr = urlString {
            let url = URL(string: imageUrlStr)
            airlineImageView.kf.setImage(with: url, placeholder: placeholder)
        } else {
            airlineImageView.image = placeholder
        }

        airlineCodeLabel.text = airlineCode
        priceLabel.text = "\(round) Flight".getPlural(count: round)

        if isSelected {
            selectedIndicatorView.backgroundColor = .appPrimary
        } else {
            selectedIndicatorView.backgroundColor = .clear
        }
    }

}
