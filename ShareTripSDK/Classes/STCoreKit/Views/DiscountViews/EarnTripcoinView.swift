//
//  EarnTripCoinView.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 30/11/2019.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

public class EarnTripcoinView: UIStackView, NibBased {
    
    @IBOutlet private weak var checkbox: GDCheckbox!
    @IBOutlet private weak var collapsibleContainer: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    
    public var discountAmount: Double = 0.0
    weak public var delegate: DiscountOptionCollapsibleViewDelegate?
    
    @IBAction private func onTapped(_ sender: Any) {
        delegate?.onDisCountOptionSelected(discountOptionView: self)
    }
    
    public var discountOptionTitle: String = "" {
        didSet {
            titleLabel.text = discountOptionTitle
        }
    }
    
    public var subTitle: String = "" {
        didSet {
            subtitleLabel.text = subTitle
        }
    }
}

extension EarnTripcoinView: DiscountOptionCollapsibleView {
    public var discountOptionType: DiscountOptionType {
        .earnTC
    }
    
    public var title: String {
        return "I want to Earn Trip Coin & Avail Discount Offer"
    }
    
    public var expanded: Bool {
        return !collapsibleContainer.isHidden
    }
    
    public func expand() {
        checkbox.isOn = true
        collapsibleContainer.isHidden = false
    }
    
    public func collapse() {
        checkbox.isOn = false
        collapsibleContainer.isHidden = true
    }
}
