//
//  ImageViewCell.swift
//  ShareTrip
//
//  Created by ST-iOS on 5/9/22.
//  Copyright © 2022 ShareTrip. All rights reserved.
//

import UIKit
import Kingfisher

class ImageViewCell: UITableViewCell {
    @IBOutlet private weak var cellImageView: UIImageView!
    
    var imageURL: String = "" {
        didSet {
            let url = URL(string: imageURL)
            let placeholder = UIImage(named: "deals-details")
            cellImageView.kf.setImage(with: url, placeholder: placeholder)
        }
    }
}
