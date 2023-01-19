//
//  TripCoinBarButtonItem.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/29/22.
//

import UIKit

public class TripCoinBarButtonItem {
    
    public init() { }
    
    public class func createWithText(_ text: String, target: Any? = nil, action: Selector? = nil) -> UIBarButtonItem {
        
        let tripCoinBarView = TripCoinBarView()
        tripCoinBarView.tripCoinLabel.text = text
        tripCoinBarView.sizeToFit()
        
        if let action = action {
            tripCoinBarView.actionButton.addTarget(target, action: action, for: .touchUpInside)
        }
        
        return UIBarButtonItem(customView: tripCoinBarView)
    }
}

public class TripCoinBarView: UIView {
    
    let tripCoinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "tripcoin-color")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let tripCoinLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.starYellow
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let actionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //initWithCode to init view from xib or storyboard
    public required init?(coder aDecoder: NSCoder) {
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
        addSubview(tripCoinImageView)
        addSubview(tripCoinLabel)
        addSubview(actionButton)
        
        NSLayoutConstraint.activate([
            tripCoinImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            tripCoinImageView.heightAnchor.constraint(equalToConstant: 28.0),
            tripCoinImageView.widthAnchor.constraint(equalToConstant: 28.0),
            tripCoinImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            tripCoinLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            tripCoinLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            tripCoinLabel.leadingAnchor.constraint(equalTo: tripCoinImageView.trailingAnchor, constant: 4),
            tripCoinLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            
            actionButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            actionButton.topAnchor.constraint(equalTo: topAnchor),
            actionButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

