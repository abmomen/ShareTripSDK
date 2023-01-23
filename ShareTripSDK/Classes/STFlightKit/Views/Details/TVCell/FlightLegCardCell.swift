//
//  FlightSegmentCardCell.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 01/12/2019.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

class FlightLegCardCell: UITableViewCell {
    @IBOutlet weak var containedView: UIView!

    @IBOutlet weak var airlineImageView: UIImageView!
    @IBOutlet weak var airlineLabel: UILabel!
    @IBOutlet weak var departureTimeLabel: UILabel!
    @IBOutlet weak var originNameLabel: UILabel!
    @IBOutlet weak var stoppageLabel: UILabel!
    @IBOutlet weak var arrivalTimeLabel: UILabel!
    @IBOutlet weak var dayCountLabel: UILabel!
    @IBOutlet weak var destinationNameLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var departureDateLabel: UILabel!

    @IBOutlet weak var hiddenStoppageView: UIView!
    
    
    @IBOutlet weak var seeDetailsLabel: UILabel!
    @IBOutlet weak var arrowRightImageView: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        seeDetailsLabel.textColor = .appPrimary
        arrowRightImageView.tintColor = .appPrimary
        arrowRightImageView.image = UIImage(named: "arrow-right-mono")
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        setAsSelectedOrHighlighted(highlighted, animated: animated)
        super.setHighlighted(highlighted, animated: animated)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        setAsSelectedOrHighlighted(selected, animated: animated)
        super.setSelected(selected, animated: animated)
    }

    private func setAsSelectedOrHighlighted(_ selectedOrHighlighted: Bool, animated: Bool) {

        let action: () -> Void = { [weak self] in
            // Set animatable properties
            self?.containedView?.backgroundColor = selectedOrHighlighted ? .paleGray : .white
        }

        if animated {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: action, completion: nil)
        } else {
            action()
        }
    }

    func configure(with flightLeg: FlightLeg, hasHiddenStoppage: Bool) {
        let url = URL(string: flightLeg.logo)
        airlineImageView.kf.setImage(with: url)
        airlineLabel.text = flightLeg.airlines.short

        departureTimeLabel.text = flightLeg.departureDateTime.time
        originNameLabel.text = flightLeg.originName.code
        
        arrivalTimeLabel.text = flightLeg.arrivalDateTime.time
        destinationNameLabel.text = flightLeg.destinationName.code
        durationLabel.text = flightLeg.duration

        stoppageLabel.text = flightLeg.stop > 0 ? "\(flightLeg.stop) Stop(s)" : "Nonstop"
        dayCountLabel.text = flightLeg.dayCount > 0 ? "+\(flightLeg.dayCount)" : ""
        
        
        let dateStr = Date(fromString: flightLeg.departureDateTime.date, format: .isoDate)?
            .toString(format: .custom("EEE, MMM dd, yyyy"))
        departureDateLabel.text = dateStr ?? flightLeg.departureDateTime.date

        hiddenStoppageView.isHidden = !hasHiddenStoppage
    }
    
}
