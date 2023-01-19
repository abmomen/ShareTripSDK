//
//  RedeemTripcoinView.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 30/11/2019.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

public protocol RedeemTripcoinViewDelegate: AnyObject {
    func didChangeRedeemAmount(dicount: Double)
}

public class RedeemTripcoinView: UIStackView, NibBased {
    
    @IBOutlet private weak var checkbox: GDCheckbox!
    @IBOutlet private weak var collapsibleContainer: UIView!
    @IBOutlet private weak var slider: UISlider!
    @IBOutlet private weak var redeemAmountLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    
    public private(set) var discountAmount: Double = 0.0
    public weak var delegate: DiscountOptionCollapsibleViewDelegate?
    public weak var redeemDelegate: RedeemTripcoinViewDelegate?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        slider.addTarget(self, action: #selector(sliderValueChanged(_:event:)), for: .valueChanged)
    }
    
    @IBAction private func onTapped(_ sender: Any) {
        delegate?.onDisCountOptionSelected(discountOptionView: self)
    }
    
    public func configure(minValue: Double, maxValue: Double, selectedValue: Double? = nil, title: String, subtitle: String) {
        updateSliderValues(minValue: minValue, maxValue: maxValue, selectedValue: selectedValue)
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
    
    public func updateSliderValues(minValue: Double, maxValue: Double, selectedValue: Double? = nil) {
        slider.minimumValue = Float(minValue)
        slider.maximumValue = Float(maxValue)
        
        var sliderValue: Double
        if let val = selectedValue {
            sliderValue = val
        } else {
            sliderValue = (maxValue + minValue) / 2.0
        }
        
        slider.setValue(Float(sliderValue), animated: false)
        setDiscountAmount(sliderValue)
    }
    
    private func setDiscountAmount(_ amount: Double) {
        discountAmount = Double(round(amount))
        redeemAmountLabel.text = Int(discountAmount).withCommas()
        redeemDelegate?.didChangeRedeemAmount(dicount: discountAmount)
    }
    
    @objc
    private func sliderValueChanged(_ sender: UISlider, event: UIEvent) {
        let amount = round(Double(sender.value))
        setDiscountAmount(amount)
    }
}

extension RedeemTripcoinView {
    struct ViewModel {
        let minValue: Double
        let maxValue: Double
        let selectedValue: Double? = nil
        let title: String
        let subtitle: String
    }
    
    func configure(with viewModel: ViewModel) {
        configure(
            minValue: viewModel.minValue,
            maxValue: viewModel.maxValue,
            selectedValue: viewModel.selectedValue,
            title: viewModel.title,
            subtitle: viewModel.subtitle
        )
    }
}

//MARK:- DiscountOptionCollapsibleView
extension RedeemTripcoinView: DiscountOptionCollapsibleView {
    public var discountOptionType: DiscountOptionType {
        .redeemTC
    }
    
    public var title: String {
        return "I want to Redeem Trip Coin"
    }
    
    public var expanded: Bool {
        get {
            return !collapsibleContainer.isHidden
        }
        set {
            collapsibleContainer.isHidden = !newValue
        }
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
