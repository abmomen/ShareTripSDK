//
//  AmenityRowView.swift
//  TBBD
//
//  Created by Mac on 4/29/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

public class AmenityRowView: UIView {
    
    private var shouldSetupConstraints = true
    
    public let firstItemView = UIView()
    public let firstItemImageView = UIImageView()
    public let firstItemLabel = UILabel()
    
    public let secondItemView = UIView()
    public let secondItemImageView = UIImageView()
    public let secondItemLabel = UILabel()
    
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
    public convenience init() {
        self.init(frame: .zero)
        
    }
    
    //MARK:- SetupView
    private func setupView() {
        firstItemLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        firstItemLabel.textColor = UIColor.black
        
        secondItemLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        secondItemLabel.textColor = UIColor.black
        
        firstItemView.translatesAutoresizingMaskIntoConstraints = false
        firstItemImageView.translatesAutoresizingMaskIntoConstraints = false
        firstItemLabel.translatesAutoresizingMaskIntoConstraints = false
        secondItemView.translatesAutoresizingMaskIntoConstraints = false
        secondItemImageView.translatesAutoresizingMaskIntoConstraints = false
        secondItemLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(firstItemView)
        addSubview(secondItemView)
        
        firstItemView.addSubview(firstItemImageView)
        firstItemView.addSubview(firstItemLabel)
        
        secondItemView.addSubview(secondItemImageView)
        secondItemView.addSubview(secondItemLabel)
        
        setNeedsUpdateConstraints()
    }
    
    public override func updateConstraints() {
        if shouldSetupConstraints {
            
            // AutoLayout constraints
            firstItemView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            firstItemView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            firstItemView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            
            //firstItemView.trailingAnchor.constraint(equalTo: secondItemView.leadingAnchor, constant: 0).isActive = true
            secondItemView.leadingAnchor.constraint(equalTo: firstItemView.trailingAnchor, constant: 0).isActive = true
            
            secondItemView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            secondItemView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            secondItemView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            
            firstItemView.widthAnchor.constraint(equalTo: secondItemView.widthAnchor).isActive = true
            
            firstItemImageView.leadingAnchor.constraint(equalTo: firstItemView.leadingAnchor).isActive = true
            firstItemImageView.centerYAnchor.constraint(equalTo: firstItemView.centerYAnchor).isActive = true
            firstItemImageView.widthAnchor.constraint(equalToConstant: 16.0).isActive = true
            firstItemImageView.heightAnchor.constraint(equalToConstant: 16.0).isActive = true
            
            firstItemLabel.leadingAnchor.constraint(equalTo: firstItemImageView.trailingAnchor, constant: 8.0).isActive = true
            firstItemLabel.centerYAnchor.constraint(equalTo: firstItemView.centerYAnchor).isActive = true
            firstItemLabel.trailingAnchor.constraint(equalTo: firstItemView.trailingAnchor, constant: -8.0).isActive = true
            
            secondItemImageView.leadingAnchor.constraint(equalTo: secondItemView.leadingAnchor, constant: 16.0).isActive = true
            secondItemImageView.centerYAnchor.constraint(equalTo: secondItemView.centerYAnchor).isActive = true
            secondItemImageView.widthAnchor.constraint(equalToConstant: 16.0).isActive = true
            secondItemImageView.heightAnchor.constraint(equalToConstant: 16.0).isActive = true
            
            secondItemLabel.leadingAnchor.constraint(equalTo: secondItemImageView.trailingAnchor, constant: 8.0).isActive = true
            secondItemLabel.centerYAnchor.constraint(equalTo: secondItemView.centerYAnchor).isActive = true
            secondItemLabel.trailingAnchor.constraint(equalTo: secondItemView.trailingAnchor, constant: -8.0).isActive = true
            
            shouldSetupConstraints = false
        }
        super.updateConstraints()
    }
}
