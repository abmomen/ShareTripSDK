//
//  PaymentGatewayCell.swift
//  TBBD
//
//  Created by Mac on 5/19/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit
import Kingfisher

public class PaymentGatewayCell: UICollectionViewCell {
    
    let paymentGatewayImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.white
        imageView.image = UIImage(named: "Profile")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    private func setupViews(){
        layer.borderColor = UIColor(redInt: 224, greenInt: 224, blueInt: 225).cgColor
        layer.borderWidth = 2
        
        addSubview(paymentGatewayImageView)
        
        NSLayoutConstraint.activate([
            paymentGatewayImageView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            paymentGatewayImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            paymentGatewayImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            paymentGatewayImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4)
        ])
    }
    
    public func setCellSelection(selected: Bool) {
        clipsToBounds = true
        layer.cornerRadius = 4
        layer.borderColor = (selected ? UIColor.appPrimary : UIColor(redInt: 224, greenInt: 224, blueInt: 225)).cgColor
        isSelected = selected
    }
    
    public func configure(imageLink: String) {
        let url = URL(string: imageLink)
        let placeholder = UIImage(named: "placeholder-mono")
        
        paymentGatewayImageView.kf.indicatorType = .activity
        paymentGatewayImageView.kf.setImage(with: url, placeholder: placeholder)
        paymentGatewayImageView.backgroundColor = UIColor.clear
        paymentGatewayImageView.contentMode = .scaleAspectFit
    }
}
