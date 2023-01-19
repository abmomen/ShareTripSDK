//
//  FlightLegView.swift
//  ShareTrip
//
//  Created by Mac on 9/26/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit


class FlightLegView: UIView, NibBased {
    
    @IBOutlet weak var airplaneImageView: UIImageView!
    @IBOutlet weak var airplaneLabel: UILabel!
    @IBOutlet weak var departureTimeLabel: UILabel!
    @IBOutlet weak var originNameLabel: UILabel!
    @IBOutlet weak var stopLabel: UILabel!
    @IBOutlet weak var arrivalTimeLabel: UILabel!
    @IBOutlet weak var dayCountLabel: UILabel!
    @IBOutlet weak var destinationNameLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!

    class func instanceFromNib() -> FlightLegView {
        let bundle = Bundle(for: FlightLegView.self)
        return UINib(nibName: "FlightLegView", bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as! FlightLegView
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        //stopLabel.layer.cornerRadius = 8.0
        //stopLabel.clipsToBounds = true
    }
    
    func config(with flightLegData: FlightLegData) {
        
        let url = URL(string: flightLegData.airplaneLogo)
        airplaneImageView.kf.setImage(with: url)
        airplaneLabel.text = flightLegData.airplaneName
        
        stopLabel.layer.cornerRadius = 8.0
        stopLabel.layer.masksToBounds = true
        
        departureTimeLabel.text = flightLegData.departureTime
        originNameLabel.text = flightLegData.originName
        arrivalTimeLabel.text = flightLegData.arrivalTime
        destinationNameLabel.text = flightLegData.destinationName
        durationLabel.text = flightLegData.duration
        
        stopLabel.text = flightLegData.stop > 0 ? "\(flightLegData.stop) Stop(s)" : "Nonstop"
        dayCountLabel.text = flightLegData.dayCount > 0 ? "+\(flightLegData.dayCount)" : ""
    }
}
