//
//  PopupGradientView.swift
//  ShareTrip
//
//  Created by Mac on 6/29/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

public struct PopupGradientViewData {
    public let title: String
    public let subtitle: String
    public let subtitleTwo: NSAttributedString?
    public let buttonTitle: String
    public let imageName: String
    
    public init(title: String, subtitle: String, subtitleTwo: NSAttributedString?, buttonTitle: String, imageName: String) {
        self.title = title
        self.subtitle = subtitle
        self.subtitleTwo = subtitleTwo
        self.buttonTitle = buttonTitle
        self.imageName = imageName
    }
}

public class PopupGradientView: UIView {
    
    /// returned Boolean value denote true for Home/Bottom button action
    public var callbackClosure: ((Bool) -> Void)?
    
    public lazy var containerGradientView: GradientView = {
        let gradientView = GradientView()
        gradientView.startColor = UIColor.orangeyRed
        gradientView.endColor = UIColor.tangerine
        gradientView.startLocation = 0.0
        gradientView.endLocation = 1.0
        gradientView.layer.cornerRadius = 14.0
        gradientView.clipsToBounds = true
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        return gradientView
    }()
    
    public lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "tripcoins-onboarding")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close-mono"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public lazy var subtitleTwoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public lazy var homeButton: UIButton = {
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
    public init(frame: CGRect, viewData: PopupGradientViewData, callbackClosure: ((Bool) -> Void)?) {
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
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView(with: nil)
    }
    
    //MARK: - Helpers
    private func setupView(with viewData: PopupGradientViewData? = nil) {
        
        // Setup UI
        addSubview(containerGradientView)
        containerGradientView.addSubview(imageView)
        containerGradientView.addSubview(closeButton)
        containerGradientView.addSubview(titleLabel)
        containerGradientView.addSubview(subtitleLabel)
        containerGradientView.addSubview(subtitleTwoLabel)
        containerGradientView.addSubview(homeButton)
        
        backgroundColor = UIColor(redInt: 4, greenInt: 4, blueInt: 15, alpha: 0.4)
        closeButton.addTarget(self, action: #selector(closeButtonTapped(_:)), for: .touchUpInside)
        homeButton.addTarget(self, action: #selector(homeButtonTapped(_:)), for: .touchUpInside)
        
        //Setup Constraint
        containerGradientView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        containerGradientView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        containerGradientView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
        
        closeButton.topAnchor.constraint(equalTo: containerGradientView.topAnchor, constant: 10.0).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: containerGradientView.trailingAnchor, constant: -10.0).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 24.0).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 24.0).isActive = true
        
        imageView.topAnchor.constraint(equalTo: containerGradientView.topAnchor, constant: 24.0).isActive = true
        imageView.centerXAnchor.constraint(equalTo: containerGradientView.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 120.0).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 120.0).isActive = true
        
        titleLabel.leadingAnchor.constraint(equalTo: containerGradientView.leadingAnchor, constant: 20.0).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: containerGradientView.trailingAnchor, constant: -20.0).isActive = true
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16.0).isActive = true
        
        subtitleLabel.leadingAnchor.constraint(equalTo: containerGradientView.leadingAnchor, constant: 20.0).isActive = true
        subtitleLabel.trailingAnchor.constraint(equalTo: containerGradientView.trailingAnchor, constant: -20.0).isActive = true
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0).isActive = true
        
        subtitleTwoLabel.leadingAnchor.constraint(equalTo: containerGradientView.leadingAnchor, constant: 20.0).isActive = true
        subtitleTwoLabel.trailingAnchor.constraint(equalTo: containerGradientView.trailingAnchor, constant: -20.0).isActive = true
        subtitleTwoLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 4.0).isActive = true
        
        homeButton.centerXAnchor.constraint(equalTo: containerGradientView.centerXAnchor).isActive = true
        homeButton.widthAnchor.constraint(equalToConstant: 150.0).isActive = true
        homeButton.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        homeButton.bottomAnchor.constraint(equalTo: containerGradientView.bottomAnchor, constant: -24.0).isActive = true
        
        if let viewData = viewData {
            if let subtitleTwo = viewData.subtitleTwo {
                subtitleTwoLabel.leadingAnchor.constraint(equalTo: containerGradientView.leadingAnchor, constant: 20.0).isActive = true
                subtitleTwoLabel.trailingAnchor.constraint(equalTo: containerGradientView.trailingAnchor, constant: -20.0).isActive = true
                subtitleTwoLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 4.0).isActive = true
                // Top Anchor to subtitleTwoLabel
                homeButton.topAnchor.constraint(equalTo: subtitleTwoLabel.bottomAnchor, constant: 16.0).isActive = true
                
                //setup data
                subtitleTwoLabel.attributedText = subtitleTwo
            } else {
                homeButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 16.0).isActive = true
            }
            
            titleLabel.text = viewData.title
            subtitleLabel.text = viewData.subtitle
            homeButton.setTitle(viewData.buttonTitle, for: .normal)
            imageView.image = UIImage(named: viewData.imageName)
        }
    }
    
    @objc private func closeButtonTapped(_ sender: Any){
        callbackClosure?(false)
    }
    
    @objc private func homeButtonTapped(_ sender: Any){
        callbackClosure?(true)
    }
}
