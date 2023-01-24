//
//  AllServicesButtonCell.swift
//  Pods
//
//  Created by ST-iOS on 1/19/23.
//

import UIKit

class AllServicesButtonCell: UITableViewCell {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet weak var flightContainerView: UIView!
    @IBOutlet weak var hotelContainerView: UIView!
    @IBOutlet weak var visaContainerView: UIView!
    
    @IBOutlet weak var planeImageView: UIImageView!
    @IBOutlet weak var hotelImageView: UIImageView!
    @IBOutlet weak var visaImageView: UIImageView!
    
    var didTapFlight: () -> Void = { }
    var didTapHotel: () -> Void = { }
    var didTapVisa: () -> Void = { }
    
    @IBAction func didTapFlightButton(_ sender: UIButton) {
        didTapFlight()
    }
    
    @IBAction func didTapHotelButton(_ sender: UIButton) {
        didTapHotel()
    }
    
    @IBAction func didTapVisaButton(_ sender: UIButton) {
        didTapVisa()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        containerView.layer.cornerRadius = 16
        
        planeImageView.image = UIImage(named: "airplane-icon")
        hotelImageView.image = UIImage(named: "hotel-icon")
        visaImageView.image = UIImage(named: "visa-icon")
        
        flightContainerView.layer.cornerRadius = 12
        hotelContainerView.layer.cornerRadius = 12
        visaContainerView.layer.cornerRadius = 12
        
        flightContainerView.layer.borderWidth = 1
        hotelContainerView.layer.borderWidth = 1
        visaContainerView.layer.borderWidth = 1
        
        flightContainerView.layer.borderColor = UIColor.gray.cgColor
        hotelContainerView.layer.borderColor = UIColor.gray.cgColor
        visaContainerView.layer.borderColor = UIColor.gray.cgColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
