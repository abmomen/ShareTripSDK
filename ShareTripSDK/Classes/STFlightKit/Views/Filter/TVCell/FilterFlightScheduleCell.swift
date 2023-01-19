//
//  FilterFlightScheduleCell.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 12/3/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

protocol FlightFilterScheduleCellDelegate: AnyObject {
    func sliderDidChange( minValue: Float, maxValue: Float, cellIndexPath: IndexPath)
}

class FilterFlightScheduleCell: UITableViewCell {
    weak var delegate: FlightFilterScheduleCellDelegate!
    private var cellIndexPath: IndexPath!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var timePeriodLabel: UILabel!
    @IBOutlet weak var slider: UISlider!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func configure(destination: String, cellIndexPath: IndexPath, delegate: FlightFilterScheduleCellDelegate){
        self.destinationLabel.text = destination
        self.cellIndexPath = cellIndexPath
        self.delegate = delegate

    }
    @IBAction func onSliderValueChanged(_ sender: UISlider) {
        delegate.sliderDidChange(minValue: slider.minimumValue, maxValue: slider.maximumValue, cellIndexPath: cellIndexPath)

    }

}
