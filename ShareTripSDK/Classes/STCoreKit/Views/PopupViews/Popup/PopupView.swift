//
//  PopupView.swift
//  ShareTrip
//
//  Created by Mac on 3/9/20.
//  Copyright © 2020 TBBD IOS. All rights reserved.
//

import UIKit

public struct PopupViewData {
    let title: String
    let subtitle: String
    let buttonTitle: String
    let imageName: String
    
    public init(title: String, subtitle: String, buttonTitle: String, imageName: String) {
        self.title = title
        self.subtitle = subtitle
        self.buttonTitle = buttonTitle
        self.imageName = imageName
    }
}

public class PopupView: UIView {
    
    /// returned Boolean value denote true for Home/Bottom button action
    var callbackClosure: ((Bool) -> Void)?
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 4.0
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "tripcoins-onboarding")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close-mono"), for: .normal)
        button.tintColor = UIColor.blueGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(hex: 0x212121)
        label.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor =  UIColor(hex: 0x434343)
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.minimumScaleFactor = 0.6
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var homeButton: UIButton = {
        let button = UIButton()
        button.setTitle("BACK", for: .normal)
        button.backgroundColor = UIColor.appPrimary
        button.layer.cornerRadius = 4.0
        button.tintColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - initializer
    public init(frame: CGRect, viewData: PopupViewData, callbackClosure: ((Bool) -> Void)?) {
        self.callbackClosure = callbackClosure
        super.init(frame: frame)
        setupView(with: viewData)
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView(with: nil)
    }
    
    // initWithFrame to init view from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView(with: nil)
    }
    
    //MARK: - Helpers
    private func setupView(with viewData: PopupViewData? = nil) {
        
        addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(closeButton)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(homeButton)
        
        backgroundColor = UIColor(redInt: 4, greenInt: 4, blueInt: 15, alpha: 0.4)
        closeButton.addTarget(self, action: #selector(closeButtonTapped(_:)), for: .touchUpInside)
        homeButton.addTarget(self, action: #selector(homeButtonTapped(_:)), for: .touchUpInside)
        
        if UIScreen.main.bounds.size.width * 0.9 > Constants.App.alertWidthMaxConstant {
            containerView.widthAnchor.constraint(equalToConstant: Constants.App.alertWidthMaxConstant).isActive = true
        } else {
            containerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true
        }
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10.0),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10.0),
            closeButton.widthAnchor.constraint(equalToConstant: 24.0),
            closeButton.heightAnchor.constraint(equalToConstant: 24.0)
        ])
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24.0),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 100.0),
            imageView.heightAnchor.constraint(equalToConstant: 100.0)
        ])
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.0),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.0),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16.0)
        ])
        NSLayoutConstraint.activate([
            subtitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.0),
            subtitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.0),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0)
        ])
        NSLayoutConstraint.activate([
            homeButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 16.0),
            homeButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24.0),
            homeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24.0),
            homeButton.heightAnchor.constraint(equalToConstant: 44.0),
            homeButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24.0)
        ])
        
        if let viewData = viewData {
            titleLabel.text = viewData.title
            subtitleLabel.text = viewData.subtitle
            homeButton.setTitle(viewData.buttonTitle, for: .normal)
            imageView.image = UIImage(named: viewData.imageName)
        }
    }
    
    @objc
    private func closeButtonTapped(_ sender: Any){
        callbackClosure?(false)
    }
    
    @objc
    private func homeButtonTapped(_ sender: Any){
        callbackClosure?(true)
    }
}
