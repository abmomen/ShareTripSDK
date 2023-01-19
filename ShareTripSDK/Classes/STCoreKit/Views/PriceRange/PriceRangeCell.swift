//
//  PriceRangeCell.swift
//  TBBD
//
//  Created by TBBD on 4/3/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

public protocol PriceRangeCellDelegate: AnyObject {
    func rangeSeekSliderDidChange( minValue: CGFloat, maxValue: CGFloat)
}

public class PriceRangeCell: UITableViewCell {
    
    @IBOutlet private weak var minimumLabel: UILabel!
    @IBOutlet private weak var maximumLabel: UILabel!
    @IBOutlet private var rangeSeekSlider: RangeSeekSlider!
    
    public weak var delegate: PriceRangeCellDelegate?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func setupView(){
        rangeSeekSlider.delegate = self
    }
    
    public func configure(priceRange: FilterPriceRange){
        
        let currentLow = priceRange.currentLow ?? priceRange.low
        let currentHigh = priceRange.currentHigh ?? priceRange.high
        
        minimumLabel.text = currentLow.withCommas()
        maximumLabel.text = currentHigh.withCommas()
        
        rangeSeekSlider.minValue = 1
        rangeSeekSlider.maxValue = 1
        
        rangeSeekSlider.minValue = CGFloat(priceRange.low)
        rangeSeekSlider.maxValue = CGFloat(priceRange.high)
        rangeSeekSlider.selectedMinValue = CGFloat(currentLow)
        rangeSeekSlider.selectedMaxValue = CGFloat(currentHigh)
    }
}

// MARK: - RangeSeekSliderDelegate
extension PriceRangeCell: RangeSeekSliderDelegate {
    public func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        minimumLabel.text = Int(minValue).withCommas()
        maximumLabel.text = Int(maxValue).withCommas()
        delegate?.rangeSeekSliderDidChange(minValue: minValue, maxValue: maxValue)
    }
}
