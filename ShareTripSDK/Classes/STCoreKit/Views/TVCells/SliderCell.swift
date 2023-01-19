//
//  SliderCell.swift
//  STCoreKit
//
//  Created by ST-iOS on 12/4/22.
//

import UIKit

public protocol SliderCellDelegate: AnyObject {
    func sliderDidChange(_ value: Float, cellType: SliderCellType)
}

public enum SliderCellType {
    case locationRange
    case guestRating
}

public class SliderCell: UITableViewCell {
    
    let titleLabel = UILabel()
    var rightLabel = UILabel()
    let slider = UISlider()
    
    weak var delegate: SliderCellDelegate?
    
    //Private Properties
    private var cellType: SliderCellType!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    private func setupView() {
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        titleLabel.textColor = UIColor.black
        
        rightLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        rightLabel.textColor = UIColor.black
        rightLabel.textAlignment = .right
        
        slider.minimumValue = 1.0
        slider.maximumValue = 10.0
        slider.isContinuous = true
        slider.minimumTrackTintColor = UIColor.blueGray
        slider.maximumTrackTintColor = UIColor.deepSkyBlue
        slider.thumbTintColor = UIColor.appPrimary
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        
        slider.value = 1.0
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.0),
            titleLabel.heightAnchor.constraint(equalToConstant: 16.0),
        ])
        
        contentView.addSubview(rightLabel)
        rightLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            rightLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8.0),
            rightLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            rightLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.0),
            rightLabel.heightAnchor.constraint(equalToConstant: 16.0),
            rightLabel.widthAnchor.constraint(equalToConstant: 40.0)
        ])
        
        contentView.addSubview(slider)
        slider.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            slider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
            slider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.0),
            slider.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0),
            slider.heightAnchor.constraint(equalToConstant: 44.0)
        ])
    }
    
    func configure(currentValue: Float?, cellType: SliderCellType, delegate: SliderCellDelegate){
        self.delegate = delegate
        self.cellType = cellType
        
        switch cellType {
        case .guestRating:
            let value = currentValue ?? 1.0
            
            slider.minimumValue = 1.0
            slider.maximumValue = 10.0
            slider.value = value
            slider.minimumTrackTintColor = UIColor.blueGray
            slider.maximumTrackTintColor = UIColor.deepSkyBlue
            rightLabel.isHidden = true
            
            titleLabel.text = getAttributedStringValue(value: value)
            
        case .locationRange:
            let value = currentValue ?? 25.0
            
            slider.minimumValue = 1.0
            slider.maximumValue = 25.0
            slider.value = value
            slider.minimumTrackTintColor = UIColor.deepSkyBlue
            slider.maximumTrackTintColor = UIColor.blueGray
            rightLabel.isHidden = false
            
            rightLabel.text = "\(Int(value))KM"
            titleLabel.text = "Distance from the city center"
        }
    }
    
    @objc
    func sliderValueChanged(_ sender: Any) {
        
        if cellType == .guestRating {
            titleLabel.text = getAttributedStringValue(value: slider.value)
        } else {
            rightLabel.text = "\(Int(slider.value))KM"
        }
        
        delegate?.sliderDidChange(slider.value, cellType: cellType)
    }
    
    func getAttributedStringValue(value: Float) -> String {
        let valueStr = String(format: "%.1f", value)
        let text = (slider.value < slider.maximumValue) ? "From \(valueStr) or higher" : valueStr
        
        return text
    }
}

