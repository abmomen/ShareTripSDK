//
//  ProfileBarButtonItem.swift
//  TBBD
//
//  Created by Mac on 6/16/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit
import Kingfisher

public class ProfileBarButtonItem: NSObject {
    
    public class func createWith(name: String, image: String?, status: String?, target: Any? = nil, action: Selector? = nil) -> UIBarButtonItem {
        
        let showStatus = status != nil
        let hasAction = action != nil
        let barView = ProfileBarView(showStatus: showStatus, hasAction: hasAction)
        let placeholder = UIImage(named: "avator-mono")
        
        if let imageUrlStr = image {
            let url = URL(string: imageUrlStr)
            barView.profileImageView.kf.setImage(with: url, placeholder: placeholder)
        } else {
            barView.profileImageView.image = placeholder
        }
        
        let nameLength = showStatus ? 8 : 12
        barView.nameLabel.text = String(name.prefix(nameLength))
        
        if let status = status {
            barView.statusLabelView.statusLabel.text = status
            let colorCode = ProfileBarButtonItem.getStatusColorCode(status: status)
            barView.statusLabelView.starImageView.tintColor = UIColor(hex: colorCode)
        }
        
        if let action = action {
            barView.actionButton.addTarget(target, action: action, for: .touchUpInside)
        }
        
        barView.sizeToFit()
        return UIBarButtonItem(customView: barView)
    }
    
    public class func getStatusColorCode(status: String) -> Int {
        switch status.capitalized {
        case "Silver":
            return 0xc0c0c0
        case "Gold":
            return 0xfcb900
        case "Platinum":
            return 0xe5e4e2
        default:
            return 0xfffff
        }
    }
}

//MARK:- ProfileBarView
public class ProfileBarView: UIView {
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = UIColor.white
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.image = UIImage(named: "avator-mono")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10.0
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var statusLabelView: StatusLabelView = {
        let view = StatusLabelView()
        view.backgroundColor = UIColor.blueBlue
        view.layer.cornerRadius = 9.0
        view.clipsToBounds = true
        view.tintColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var actionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK:- Init
    public init(showStatus: Bool, hasAction: Bool) {
        super.init(frame: .zero)
        setupView(showStatus: showStatus, hasAction: hasAction)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- SetupView
    private func setupView(showStatus: Bool, hasAction: Bool) {
        addSubview(profileImageView)
        addSubview(nameLabel)
        
        profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 6.0).isActive = true
        
        if showStatus {
            addSubview(statusLabelView)
            statusLabelView.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 6.0).isActive = true
            statusLabelView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
            statusLabelView.heightAnchor.constraint(equalToConstant: 18.0).isActive = true
            statusLabelView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        } else {
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        }
        
        if hasAction {
            addSubview(actionButton)
            actionButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            actionButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
            actionButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        }
    }
}

//MARK:- StatusLabelView
public class StatusLabelView: UIView {
    
    let starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "star-mono")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(starImageView)
        addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            starImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            starImageView.heightAnchor.constraint(equalToConstant: 12.0),
            starImageView.widthAnchor.constraint(equalToConstant: 12.0),
            starImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            statusLabel.leadingAnchor.constraint(equalTo: starImageView.trailingAnchor, constant: 3),
            statusLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6.0)
        ])
    }
}
