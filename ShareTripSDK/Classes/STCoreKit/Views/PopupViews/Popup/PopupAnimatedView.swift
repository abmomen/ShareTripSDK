//
//  PopupAnimatedView.swift
//  TBBD
//
//  Created by Mac on 5/30/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit
import Lottie

public class PopupAnimatedView: UIView {
    
    public var callbackClosure: ((Bool) -> Void)?
    public var title: String?
    public var message: String?
    public var shouldAnimate: Bool = true
    
    private var shouldSetupConstraints = true
    
    let containerGradientView: GradientView = {
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
    
    let animationView: LottieAnimationView = {
        let view = LottieAnimationView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close-mono"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let homeButton: UIButton = {
        let button = UIButton()
        button.setTitle("HOME", for: .normal)
        button.backgroundColor = UIColor.appPrimary
        button.layer.cornerRadius = 4.0
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - initializer
    public init(frame: CGRect, title: String, message: String, animation: Bool, callbackClosure: ((Bool) -> Void)?) {
        
        self.callbackClosure = callbackClosure
        self.title = title
        self.message = message
        shouldAnimate = animation
        
        //self.init(frame: frame)
        super.init(frame: frame)
        setupView()
    }
    
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
    
    //MARK: - Helpers
    private func setupView() {
        
        // Setup UI
        addSubview(containerGradientView)
        containerGradientView.addSubview(animationView)
        containerGradientView.addSubview(closeButton)
        containerGradientView.addSubview(titleLabel)
        containerGradientView.addSubview(messageLabel)
        containerGradientView.addSubview(homeButton)
        
        backgroundColor = UIColor(redInt: 4, greenInt: 4, blueInt: 15, alpha: 0.4)
        
        animationView.animation = LottieAnimation.named("TreasureBoxJerking", subdirectory: "LottieResources")
        titleLabel.text = title
        messageLabel.text = message
        
        if shouldAnimate {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2 ) {
                self.animationView.play(fromProgress: 0,
                                        toProgress: 1,
                                        loopMode: LottieLoopMode.playOnce,
                                        completion: { (finished) in
                                            if finished {
                                                STLog.info("finished")
                                            }
                                        })
            }
        }
        
        
        closeButton.addTarget(self, action: #selector(closeButtonTapped(_:)), for: .touchUpInside)
        homeButton.addTarget(self, action: #selector(homeButtonTapped(_:)), for: .touchUpInside)
        
        //Setup Constraint
        containerGradientView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        containerGradientView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        containerGradientView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.75).isActive = true
        
        closeButton.topAnchor.constraint(equalTo: containerGradientView.topAnchor, constant: 10.0).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: containerGradientView.trailingAnchor, constant: -10.0).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 24.0).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 24.0).isActive = true
        
        
        animationView.topAnchor.constraint(equalTo: containerGradientView.topAnchor, constant: 24.0).isActive = true
        animationView.centerXAnchor.constraint(equalTo: containerGradientView.centerXAnchor).isActive = true
        animationView.widthAnchor.constraint(equalToConstant: 120.0).isActive = true
        animationView.heightAnchor.constraint(equalToConstant: 120.0).isActive = true
        
        titleLabel.leadingAnchor.constraint(equalTo: containerGradientView.leadingAnchor, constant: 20.0).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: containerGradientView.trailingAnchor, constant: -20.0).isActive = true
        titleLabel.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 30.0).isActive = true
        
        messageLabel.leadingAnchor.constraint(equalTo: containerGradientView.leadingAnchor, constant: 20.0).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: containerGradientView.trailingAnchor, constant: -20.0).isActive = true
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6.0).isActive = true
        
        homeButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16.0).isActive = true
        homeButton.centerXAnchor.constraint(equalTo: containerGradientView.centerXAnchor).isActive = true
        homeButton.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
        homeButton.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        homeButton.bottomAnchor.constraint(equalTo: containerGradientView.bottomAnchor, constant: -24.0).isActive = true
        
    }
    
    public override func updateConstraints() {
        if shouldSetupConstraints {
            shouldSetupConstraints = false
        }
        super.updateConstraints()
    }
    
    @objc
    private func closeButtonTapped(_ sender: Any){
        callbackClosure?(true)
    }
    
    @objc
    private func homeButtonTapped(_ sender: Any){
        callbackClosure?(false)
    }
}
