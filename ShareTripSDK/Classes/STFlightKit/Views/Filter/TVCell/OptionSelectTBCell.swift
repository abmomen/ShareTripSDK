//
//  FlightOptionInputTBCell.swift
//  ShareTrip
//
//  Created by Nazmul Islam on 26/4/20.
//  Copyright © 2020 ShareTrip. All rights reserved.
//

import UIKit

class OptionSelectTBCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var tickImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        containerView.layer.cornerRadius = 4.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(text: String, selected: Bool) {
        titleLabel.text = text
        tickImageView.isHidden = !selected
    }

    func select() {
        tickImageView.isHidden = false
    }

    func deselect() {
        tickImageView.isHidden = true
    }
}
