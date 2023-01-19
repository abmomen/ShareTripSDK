//
//  FlightSegmentCardCell.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 01/12/2019.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

class FlightSegmentCardCell: UITableViewCell {

    @IBOutlet weak var segmentContainerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var airlinesImageView: UIImageView!
    @IBOutlet weak var airlinesLabel: UILabel!
    @IBOutlet weak var airlinesCodeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var departTimeLabel: UILabel!
    @IBOutlet weak var departDateLabel: UILabel!
    @IBOutlet weak var departAirportLabel: UILabel!
    @IBOutlet weak var arrivalTimeLabel: UILabel!
    @IBOutlet weak var arrivalDateLabel: UILabel!
    @IBOutlet weak var arrivalAirportLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var aircraftLabel: UILabel!
    @IBOutlet weak var layoverView: UIView!
    @IBOutlet weak var transitTimeLabel: UILabel!
    @IBOutlet weak var transitVisaView: UIView!
    @IBOutlet weak var transitVisaLabel: UILabel!
    @IBOutlet weak var technicalStoppageView: UIView!
    @IBOutlet weak var technicalStoppageLabel: UILabel!
    @IBOutlet weak var transitTimeView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        segmentContainerView.layer.cornerRadius = 4.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(with cellData: FlightSegmentCellData) {

        if let logo = cellData.airlinesImage, let url = URL(string: logo) {
            let placeholder = UIImage(named: "placeholder-mono")
            airlinesImageView.kf.setImage(with: url, placeholder: placeholder)
        }

        //airlinesImageView.kf.setImag

        airlinesLabel.text = cellData.airline
        aircraftLabel.text = cellData.aircraft

        //cell.durationLabel.text = "\(flightSegmentDetail.duration/60)h \(flightSegmentDetail.duration%60)m"
        durationLabel.text = cellData.duration

        departTimeLabel.text = cellData.departTime
        departDateLabel.text = cellData.departDate
        titleLabel.text = "\(cellData.departCode) - \(cellData.arrivalCode)"

        arrivalTimeLabel.text = cellData.arrivalTime
        arrivalDateLabel.text = cellData.arrivalDate


        classLabel.text = cellData.classText

        airlinesCodeLabel.text = cellData.airlineCode
        departAirportLabel.text = cellData.departAirport
        arrivalAirportLabel.text = cellData.arrivalAirport

        transitTimeLabel.text = cellData.transitTime
        transitTimeView.isHidden = cellData.isLastSegment

        transitVisaView.isHidden = !cellData.transitVisaRequired
        if cellData.transitVisaRequired {
            transitVisaLabel.text = cellData.transitVisaText
        }

        technicalStoppageView.isHidden = !cellData.hasTechnicalStoppage
        if cellData.hasTechnicalStoppage {
            technicalStoppageLabel.text = cellData.technicalStoppageText
        }

        if !transitVisaView.isHidden || !technicalStoppageView.isHidden || !transitTimeView.isHidden {
            layoverView.isHidden = false
        } else {
            layoverView.isHidden =  true
        }
    }
}
