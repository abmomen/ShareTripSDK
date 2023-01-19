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
    
    @IBAction func didTapFlightButton(_ sender: UIButton) {
        
    }
    
    @IBAction func didTapHotelButton(_ sender: UIButton) {
        
    }
    
    @IBAction func didTapVisaButton(_ sender: UIButton) {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 16
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
