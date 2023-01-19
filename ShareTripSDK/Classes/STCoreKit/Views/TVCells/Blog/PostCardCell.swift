//
//  PostCardCell.swift
//  ShareTrip
//
//  Created by ShareTrip iOS on 5/10/20.
//  Copyright © 2020 ShareTrip. All rights reserved.
//

import UIKit
import Kingfisher

public class PostCardCell: UITableViewCell {
    
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var bgImageView: UIImageView!
    @IBOutlet weak private var textContainerView: UIView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var subtitleLabel: UILabel!
    
    private var gradiantLayer: CAGradientLayer?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    public func configure(postCardCellData: PostCardCellData) {
        containerView.layer.cornerRadius = 10.0
        containerView.clipsToBounds = true
        textContainerView.backgroundColor = .clear
        containerView.layer.cornerRadius = 10.0
        containerView.clipsToBounds = true
        
        let url = URL(string: postCardCellData.imageUrl ?? "")
        let placeholder = UIImage(named: "placeholder-mono")
        bgImageView.kf.indicatorType = .activity
        bgImageView.kf.setImage(with: url, placeholder: placeholder)
        bgImageView.backgroundColor = .offWhite
        
        let colors = [
            UIColor.black.withAlphaComponent(0.0),
            UIColor.black.withAlphaComponent(0.0),
            UIColor.black.withAlphaComponent(0.90)
        ]
        if gradiantLayer == nil {
            gradiantLayer = bgImageView.applyGradient(colours: colors, locations: [0.0, 0.5, 1.0])
        }
        
        
        if let titleText = postCardCellData.title {
            titleLabel.text = titleText
            titleLabel.isHidden = false
        } else {
            titleLabel.isHidden = true
        }
        
        if let subTitleText = postCardCellData.text {
            subtitleLabel.text = subTitleText
            subtitleLabel.isHidden = false
        } else {
            subtitleLabel.isHidden = true
        }
        
        if postCardCellData.title == nil && postCardCellData.text == nil {
            textContainerView.isHidden = true
        } else {
            textContainerView.isHidden = false
        }
    }
}

public extension PostCardCell {
    struct PostCardCellData {
        public let imageUrl: String?
        public let title: String?
        public let text: String?
        
        public init(imageUrl: String?, title: String?, text: String?) {
            self.imageUrl = imageUrl
            self.title = title
            self.text = text
        }
    }
}
