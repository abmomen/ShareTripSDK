//
//  SingleItemView.swift
//  TBBD
//
//  Created by Mac on 6/17/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

public class SingleItemView: UIView {
    
    public let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = UIColor.init(hex: 0x43A046)
        imageView.image = UIImage(named: "done-mono")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public let textLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // initWithFrame to init view from code
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    // Our own initializer, that may have the data for the view in arguments
    convenience init() {
        self.init(frame: .zero)
        
    }
    
    //MARK:- SetupView
    private func setupView() {
        addSubview(imageView)
        addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            imageView.heightAnchor.constraint(equalToConstant: 14.0),
            imageView.widthAnchor.constraint(equalToConstant: 14.0),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            textLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            textLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 4),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)
            
        ])
    }
}

