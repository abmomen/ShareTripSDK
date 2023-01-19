//
//  CheckboxStarRatingCell.swift
//  TBBD
//
//  Created by TBBD on 4/4/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

class CheckboxStarRatingCell: UITableViewCell {
    
    let checkbox = GDCheckbox()
    let titleLabel = UILabel()
    let starRatingView = CosmosView()
    
    //Private Properties
    private var cellIndexPath: IndexPath!
    private var callbackClosure: ((IndexPath, Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    private func setupView(){
        checkbox.checkColor = .white
        checkbox.checkWidth = 3.0
        checkbox.containerColor = UIColor.blueGray
        checkbox.containerFillColor = UIColor.appPrimary
        checkbox.containerWidth = 2.0
        checkbox.isCircular = false
        checkbox.isOn = false
        checkbox.isRadiobox = false
        checkbox.isSquare = false
        checkbox.shouldAnimate = true
        checkbox.shouldFillContainer = true
        checkbox.addTarget(self, action: #selector(checkboxValueChanged(_:)), for: .valueChanged)
        
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        titleLabel.textColor = UIColor.black
        
        starRatingView.settings.updateOnTouch = false
        starRatingView.settings.fillMode = .full
        starRatingView.settings.starSize = 18.0
        starRatingView.settings.starMargin = 0
        starRatingView.settings.filledColor = UIColor.marigold
        starRatingView.settings.filledBorderColor = UIColor.marigold
        
        contentView.addSubview(checkbox)
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            checkbox.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            checkbox.widthAnchor.constraint(equalToConstant: 22.0),
            checkbox.heightAnchor.constraint(equalToConstant: 22.0),
            checkbox.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: checkbox.trailingAnchor, constant: 12.0),
            titleLabel.widthAnchor.constraint(equalToConstant: 40.0),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            
        ])
        
        contentView.addSubview(starRatingView)
        starRatingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            starRatingView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8.0),
            starRatingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            starRatingView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            starRatingView.heightAnchor.constraint(equalToConstant: 18.0)
        ])
    }
    
    func configure(indexPath: IndexPath, starCount: Int, checkboxChecked: Bool, callbackClosure: ((_ cellIndexPath: IndexPath, _ checked: Bool) -> Void)?){
        
        cellIndexPath = indexPath
        self.callbackClosure = callbackClosure
        checkbox.isOn = checkboxChecked
        
        titleLabel.text = "\(starCount) Star"
        starRatingView.totalStars = starCount
        starRatingView.rating = Double(starCount)
    }
    
    @objc
    func checkboxValueChanged(_ sender: Any){
        callbackClosure?(cellIndexPath, checkbox.isOn)
    }
}

