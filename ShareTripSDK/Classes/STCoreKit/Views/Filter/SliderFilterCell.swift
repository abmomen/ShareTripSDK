//
//  SliderFilterCell.swift
//  ShareTrip
//
//  Created by Mac on 2/4/20.
//  Copyright © 2020 TBBD IOS. All rights reserved.
//

import UIKit

public protocol SliderFilterCellDelegate: AnyObject {
    func sliderDidChange(_ value: Float, indexPath: IndexPath)
}

public class SliderFilterCell: UITableViewCell {
    
    private lazy var cellContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 4.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        label.textColor = UIColor.greyishBrown
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var rightLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = UIColor.tangerine
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 1.0
        slider.maximumValue = 10.0
        slider.value = 1.0
        slider.isContinuous = true
        slider.thumbTintColor = UIColor.appPrimary
        slider.minimumTrackTintColor = UIColor.deepSkyBlue
        slider.maximumTrackTintColor = UIColor.blueGray
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    //Private Properties
    private var indexPath: IndexPath?
    private weak var delegate: SliderFilterCellDelegate?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(cellContainerView)
        
        cellContainerView.addSubview(titleLabel)
        cellContainerView.addSubview(rightLabel)
        cellContainerView.addSubview(slider)
        
        NSLayoutConstraint.activate([
            cellContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0),
            cellContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.0),
            cellContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 1.0),
            cellContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1.0),
            
            titleLabel.leadingAnchor.constraint(equalTo: cellContainerView.leadingAnchor, constant: 16.0),
            titleLabel.topAnchor.constraint(equalTo: cellContainerView.topAnchor, constant: 19.0),
            
            rightLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8.0),
            rightLabel.trailingAnchor.constraint(equalTo: cellContainerView.trailingAnchor, constant: -16.0),
            rightLabel.topAnchor.constraint(equalTo: cellContainerView.topAnchor, constant: 16.0),
            rightLabel.widthAnchor.constraint(equalToConstant: 50.0),
            
            slider.leadingAnchor.constraint(equalTo: cellContainerView.leadingAnchor, constant: 16.0),
            slider.trailingAnchor.constraint(equalTo: cellContainerView.trailingAnchor, constant: -16.0),
            slider.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0),
            slider.heightAnchor.constraint(equalToConstant: 44.0)
        ])
    }
    
    public func configure(currentValue: Float?, indexPath: IndexPath, delegate: SliderFilterCellDelegate){
        
        self.indexPath = indexPath
        self.delegate = delegate
        
        let value = currentValue ?? 25.0
        slider.minimumValue = 1.0
        slider.maximumValue = 25.0
        slider.value = value
        
        rightLabel.isHidden = false
        
        rightLabel.text = "\(Int(value))KM"
        titleLabel.text = "Distance from the city center"
    }
    
    @objc
    private func sliderValueChanged(_ sender: Any) {
        rightLabel.text = "\(Int(slider.value))KM"
        if let indexPath = indexPath {
            delegate?.sliderDidChange(slider.value, indexPath: indexPath)
        }
    }
}
