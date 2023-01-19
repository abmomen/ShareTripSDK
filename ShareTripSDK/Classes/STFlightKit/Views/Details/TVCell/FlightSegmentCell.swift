//
//  FlightSegmentCell.swift
//  TBBD
//
//  Created by Mac on 4/24/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit
import Kingfisher

class FlightSegmentCell: UITableViewCell {
    
    @IBOutlet weak var airlinesImageView: UIImageView!
    @IBOutlet weak var airlinesLabel: UILabel!
    @IBOutlet weak var durationImageView: UIImageView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var departImageView: UIImageView!
    @IBOutlet weak var departTimeLabel: UILabel!
    @IBOutlet weak var departDateLabel: UILabel!
    @IBOutlet weak var departCodeLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var arrivalImageView: UIImageView!
    @IBOutlet weak var arrivalTimeLabel: UILabel!
    @IBOutlet weak var arrivalDateLabel: UILabel!
    @IBOutlet weak var arrivalCodeLabel: UILabel!
    @IBOutlet weak var classContainerView: UIView!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var aircraftLabel: UILabel!
    @IBOutlet weak var horizontalLineView: UIView!
    @IBOutlet weak var layoverContainerView: UIView!
    @IBOutlet weak var layoverLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        
        classContainerView.layer.cornerRadius = 4.0
        layoverContainerView.layer.cornerRadius = 4.0
        classContainerView.clipsToBounds = true
        layoverContainerView.clipsToBounds = true
        
        durationImageView.tintColor = UIColor.brownishGray
        arrowImageView.tintColor = UIColor.appPrimaryDark
        departImageView.tintColor = UIColor.appPrimary
        arrivalImageView.tintColor = UIColor.appPrimary
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
        departCodeLabel.text = cellData.departCode
        
        arrivalTimeLabel.text = cellData.arrivalTime
        arrivalDateLabel.text = cellData.arrivalDate
        arrivalCodeLabel.text = cellData.arrivalCode
        
        classLabel.text = cellData.classText
        
        layoverLabel.text = cellData.transitTime
        layoverLabel.isHidden = cellData.isLastSegment
        clipsToBounds = cellData.isLastSegment
        
//        if cellData.isLastSegment {
//            layoverLabel.isHidden 
//            clipsToBounds = false
//        } else {
//            clipsToBounds = true
//        }
        
        horizontalLineView.isHidden = !cellData.isLastSegment
    }
    
}
