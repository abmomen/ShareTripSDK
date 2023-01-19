//
//  FilterFlightDurationCell.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 12/3/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

protocol FilterFlightDurationCellDelegate: AnyObject {
    func getSliderValue(value: Float)
}

class FilterFlightDurationCell: UITableViewCell {
    private var delegate: FilterFlightDurationCellDelegate!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(time: String, delegate: FilterFlightDurationCellDelegate) {
        self.timeLabel.text = time
        self.delegate = delegate

    }
    
    @IBAction func onValueChange(_ sender: UISlider) {
        delegate.getSliderValue(value: slider.value)
    }
}
