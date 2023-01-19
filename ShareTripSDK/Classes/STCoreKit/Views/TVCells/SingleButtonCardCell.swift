//
//  HotelSingleButtonCell.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 18/02/2020.
//  Copyright © 2020 TBBD IOS. All rights reserved.
//

import UIKit

public class SingleButtonCardCell: UITableViewCell {
    
    @IBOutlet private weak var button: UIButton!
    
    public var callBack: (() -> Void)?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    @IBAction private func onButtonTapped(_ sender: Any) {
        callBack?()
    }
    
    public func configure(title: String,
                   titleColor: UIColor,
                   backgroundColor: UIColor) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.backgroundColor = backgroundColor
    }
}
