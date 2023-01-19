//
//  PackageDetailsViews.swift
//  TBBD
//
//  Created by Tbbd iOS on 5/28/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

public class BriefInfoCardCell: UITableViewCell {
    
    @IBOutlet private weak var countryNameLabel: UILabel!
    @IBOutlet private  weak var durationLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    public func configure(countryName: String, duration: String, title: String, description: String) {
        selectionStyle = .none
        countryNameLabel.text = countryName
        durationLabel.text = duration
        titleLabel.text = title
        descriptionLabel.text = description
    }
}
