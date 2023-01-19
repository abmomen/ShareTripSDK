//
//  FlightFilterAirlinesCell.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 12/3/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

protocol FlightFilterAirlinesCellDelegate: AnyObject {
    func getSwitchButtonStatus(status: Bool, cellIndexPath: IndexPath)
}

class FlightFilterAirlinesCell: UITableViewCell {
    private var delegate: FlightFilterAirlinesCellDelegate!
    private var cellIndexPath: IndexPath!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var airlineLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(imageString: String, airLines: String, price: String, cellIndexPath: IndexPath, delegate: FlightFilterAirlinesCellDelegate) {
        self.imageView?.image = UIImage(named: imageString)
        self.airlineLabel.text = airLines
        self.priceLabel.text = price
        self.delegate = delegate
        self.cellIndexPath = cellIndexPath
    }
    @IBAction func switchButtonAction(_ sender: UISwitch) {
        delegate.getSwitchButtonStatus(status: switchButton.isOn, cellIndexPath: cellIndexPath)
    }
    
}
