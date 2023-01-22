//
//  AlertViewController.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 11/24/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

public class ErrorView: UIView {
    
    //MARK:- Initializer
    private var imageName: String?
    private var titleText: String?
    private var messageText: String?
    private var buttonTitle: String?
    private var imageViewHeight: CGFloat?
    private var imageViewWidth: CGFloat?
    private var isBackgroundColorWhite: Bool?
    
    public var buttonCallback: (() -> Void)?
    
    public init(
        frame: CGRect,
        imageName: String?,
        title: String,
        message: String,
        imageViewHeight: CGFloat = 256.0,
        imageViewWidth: CGFloat = 256.0,
        buttonTitle: String?,
        isBackgroundColorWhite: Bool = true
    ) {
        self.imageName = imageName
        self.titleText = title
        self.messageText = message
        self.buttonTitle = buttonTitle
        self.imageViewHeight = imageViewHeight
        self.imageViewWidth = imageViewWidth
        self.isBackgroundColorWhite = isBackgroundColorWhite
        
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    //MARK:- Property
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "no-internet")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 38, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor.greyishBrown
        label.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .appPrimary
        button.layer.cornerRadius = 4.0
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        button.addTarget(self, action: #selector(self.buttonClicked), for: .touchUpInside)
        return button
    }()
    
    @objc
    private func buttonClicked() {
        buttonCallback?()
    }
    
    //MARK:- Setup View
    private func setupViews() {
        isBackgroundColorWhite ?? false ? (backgroundColor = .white): (backgroundColor = .clear)
        
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(messageLabel)
        addSubview(button)
        
        if let imageName = imageName {
            imageView.image = UIImage(named: imageName)
        } else { return }
        
        if let buttonTitle = buttonTitle {
            button.setTitle(buttonTitle, for: .normal)
            button.isHidden = false
        } else {
            button.isHidden = true
        }
        titleLabel.text = self.titleText
        messageLabel.text = self.messageText
        
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -150.0),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: imageViewHeight!),
            imageView.heightAnchor.constraint(equalToConstant: imageViewWidth!),
            
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24.0),
            
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0),
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6.0),
            
            button.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32.0),
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32.0),
            button.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 24.0),
            button.heightAnchor.constraint(equalToConstant: 44.0)
        ])
    }
}
