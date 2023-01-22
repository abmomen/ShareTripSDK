//
//  LoginCardView.swift
//  ShareTrip
//
//  Created by Mac on 6/29/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

public struct LoginCardViewData {
    public let title: String
    public let subtitle: String
    public let imageName: String
    public let gradientBackground: Bool
    
    public init(title: String, subtitle: String, imageName: String, gradientBackground: Bool) {
        self.title = title
        self.subtitle = subtitle
        self.imageName = imageName
        self.gradientBackground = gradientBackground
    }
}

public class LoginCardView: UIView {
    
    /// returned Boolean value denote true for Login button action
    public var callbackClosure: (() -> Void)?
    
    lazy var containerGradientView: GradientView = {
        let gradientView = GradientView()
        gradientView.startColor = UIColor.orangeyRed
        gradientView.endColor = UIColor.tangerine
        gradientView.startLocation = 0.0
        gradientView.endLocation = 1.0
        gradientView.layer.cornerRadius = 8.0
        gradientView.clipsToBounds = true
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        return gradientView
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "tripcoins-onboarding")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.minimumScaleFactor = 0.6
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("LOGIN", for: .normal)
        button.backgroundColor = UIColor.appPrimary
        button.layer.cornerRadius = 4.0
        button.tintColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - initializer
    public init(frame: CGRect, viewData: LoginCardViewData, callbackClosure: (() -> Void)?) {
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
    
    //MARK: - SetupView
    private func setupView(with viewData: LoginCardViewData? = nil) {
        guard let viewData = viewData else { return }
        
        addSubviewsAndLayout(gradientBackground: viewData.gradientBackground)
        
        titleLabel.text = viewData.title
        subtitleLabel.text = viewData.subtitle
        imageView.image = UIImage(named: viewData.imageName)
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped(_:)), for: .touchUpInside)
    }
    
    private func addSubviewsAndLayout(gradientBackground: Bool) {
        let containerView: UIView
        if gradientBackground {
            containerView = containerGradientView
            addSubview(containerGradientView)
            
            NSLayoutConstraint.activate([
                containerView.topAnchor.constraint(equalTo: topAnchor),
                containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
                containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
                containerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.0)
            ])
            
        } else {
            containerView = self
            backgroundColor = UIColor.white
            layer.cornerRadius = 8.0
            clipsToBounds = true
            titleLabel.textColor = UIColor(hex: 0x212121)
            subtitleLabel.textColor = UIColor(hex: 0x434343)
        }
        
        containerView.addSubview(imageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24.0),
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 120.0),
            imageView.heightAnchor.constraint(equalToConstant: 120.0),
            
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.0),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.0),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16.0),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.0),
            subtitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.0),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0),
            
            loginButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 24.0),
            loginButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.0),
            loginButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.0),
            loginButton.heightAnchor.constraint(equalToConstant: 44.0),
            loginButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24.0)
            
        ])
    }
    
    @objc
    func loginButtonTapped(_ sender: Any){
        callbackClosure?()
    }
}
