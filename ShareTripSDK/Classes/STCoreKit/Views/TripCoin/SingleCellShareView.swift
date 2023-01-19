//
//  SingleCellShareView.swift
//  ShareTrip
//
//  Created by Nazmul Islam on 7/30/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

public class SingleCellShareView: UIView, NibBased {
    
    @IBOutlet private weak var shareLabel: UILabel!
    @IBOutlet private weak var shareButton: UIButton!
    
    private var shareButtonAction: ((_ sender: UIButton) -> Void)? = nil
    
    public func confugure(shareTripCoin: Int, shareButtonAction: ((_ sender: UIButton) -> Void)? = nil) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        shareLabel.text = "Get \(shareTripCoin) TripCoin"
        shareButton.setBorder(cornerRadius: 4.0)
        self.shareButtonAction = shareButtonAction
    }
    
    @IBAction func onShareButtonTapped(_ sender: UIButton) {
        shareButtonAction?(sender)
    }
    
}
