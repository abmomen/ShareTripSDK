//
//  DiscountOptionsCell.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 03/12/2019.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

public class DiscountOptionsCell: UITableViewCell {
    
    @IBOutlet private weak var subContainerView: UIView!
    @IBOutlet private weak var discountOptionsHolder: UIStackView!
    
    private let showLoginCard = !STAppManager.shared.isUserLoggedIn
    
    public var callbackClosure: (() -> Void)? = nil {
        didSet {
            if showLoginCard {
                addLoginCardView()
            } else {
                hideLoginCardView()
            }
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func configure(discountOptionsView: UIView) {
        discountOptionsView.translatesAutoresizingMaskIntoConstraints = false
        discountOptionsHolder.subviews.forEach { subView in
            subView.removeFromSuperview()
        }
        discountOptionsHolder.addArrangedSubview(discountOptionsView)
    }
    
    var blurEffectView: UIVisualEffectView?
    private func addLoginCardView() {
        
        guard blurEffectView == nil else { return }
        
        let viewData = LoginCardViewData(
            title: "Dear Guest User",
            subtitle: "Please log in or sign up on the app to avail the discount offers",
            imageName: "discount-mono",
            gradientBackground: false
        )
        let loginCardView = LoginCardView(frame: CGRect.zero, viewData: viewData, callbackClosure: callbackClosure)
        loginCardView.layer.cornerRadius = 4.0
        loginCardView.clipsToBounds = true
        loginCardView.backgroundColor = .clear
        loginCardView.imageView.tintColor = UIColor.appPrimaryDark
        loginCardView.translatesAutoresizingMaskIntoConstraints = false
        
        let effect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: effect)
        blurEffectView.alpha = 0.85
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        subContainerView.addSubview(blurEffectView)
        blurEffectView.contentView.addSubview(loginCardView)
        
        NSLayoutConstraint.activate([
            blurEffectView.leadingAnchor.constraint(equalTo: subContainerView.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: subContainerView.trailingAnchor),
            blurEffectView.topAnchor.constraint(equalTo: subContainerView.topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: subContainerView.bottomAnchor),
        ])
        NSLayoutConstraint.activate([
            loginCardView.leadingAnchor.constraint(equalTo: blurEffectView.contentView.leadingAnchor),
            loginCardView.trailingAnchor.constraint(equalTo: blurEffectView.contentView.trailingAnchor),
            loginCardView.topAnchor.constraint(equalTo: blurEffectView.contentView.topAnchor),
            loginCardView.bottomAnchor.constraint(equalTo: blurEffectView.contentView.bottomAnchor)
        ])
        self.blurEffectView = blurEffectView
    }
    
    private func hideLoginCardView() {
        blurEffectView?.removeFromSuperview()
        blurEffectView = nil
    }
}
