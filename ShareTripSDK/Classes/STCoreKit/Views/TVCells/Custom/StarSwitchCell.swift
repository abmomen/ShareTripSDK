//
//  StarSwitchCell.swift
//  ShareTrip
//
//  Created by Mac on 2/2/20.
//  Copyright © 2020 TBBD IOS. All rights reserved.
//

import UIKit

class StarSwitchCell: UITableViewCell {
    
    lazy var cellContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 4.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var starRatingView: CosmosView = {
        let cosmosView =  CosmosView()
        cosmosView.settings.updateOnTouch = false
        cosmosView.settings.fillMode = .full
        cosmosView.settings.starSize = 18.0
        cosmosView.settings.starMargin = 0
        cosmosView.settings.filledColor = UIColor.marigold
        cosmosView.settings.filledBorderColor = UIColor.marigold
        cosmosView.translatesAutoresizingMaskIntoConstraints = false
        return cosmosView
    }()
    
    lazy var optionSwitch: UISwitch = {
        let optionSwitch = UISwitch()
        optionSwitch.isOn = false
        optionSwitch.onTintColor = UIColor.appPrimary
        optionSwitch.addTarget(self, action: #selector(switchButtonAction(_:)), for: .valueChanged)
        optionSwitch.translatesAutoresizingMaskIntoConstraints = false
        return optionSwitch
    }()
    
    //Private Properties
    private weak var delegate: SwitchCellDelegate?
    private var cellIndexPath: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    private func setupView() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(cellContainerView)
        
        cellContainerView.addSubview(starRatingView)
        cellContainerView.addSubview(optionSwitch)
        NSLayoutConstraint.activate([
            cellContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0),
            cellContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.0),
            cellContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 1.0),
            cellContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1.0),
            
            starRatingView.leadingAnchor.constraint(equalTo: cellContainerView.leadingAnchor, constant: 16.0),
            starRatingView.heightAnchor.constraint(equalToConstant: 24.0),
            starRatingView.centerYAnchor.constraint(equalTo: cellContainerView.centerYAnchor),
            
            starRatingView.leadingAnchor.constraint(equalTo: starRatingView.trailingAnchor, constant: 12.0),
            optionSwitch.trailingAnchor.constraint(equalTo: cellContainerView.trailingAnchor, constant: -16.0),
            optionSwitch.centerYAnchor.constraint(equalTo: cellContainerView.centerYAnchor)
        ])
    }
    
    @objc
    private func switchButtonAction(_ sender: UISwitch) {
        delegate?.switchButtonStatusChanged(status: sender.isOn, cellIndexPath: cellIndexPath)
    }
    
    func configure(starCount: Int, checked: Bool, indexPath: IndexPath, delegate: SwitchCellDelegate) {
        starRatingView.totalStars = starCount
        starRatingView.rating = Double(starCount)
        optionSwitch.setOn(checked, animated: false)
        
        cellIndexPath = indexPath
        self.delegate = delegate
    }
}
