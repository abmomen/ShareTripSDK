//
//  RadioboxCell.swift
//  TBBD
//
//  Created by TBBD on 4/8/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

class RadioboxCell: UITableViewCell {
    
    let radiobox = GDCheckbox()
    let titleLabel = UILabel()
    
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
    
    private func setupView() {
        radiobox.checkColor = .white
        radiobox.checkWidth = 3.0
        radiobox.containerColor = UIColor.blueGray
        radiobox.containerFillColor = UIColor.appPrimary
        radiobox.containerWidth = 2.0
        radiobox.isCircular = false
        radiobox.isOn = false
        radiobox.isRadiobox = true
        radiobox.isSquare = false
        radiobox.shouldAnimate = true
        radiobox.shouldFillContainer = true
        radiobox.addTarget(self, action: #selector(radioboxValueChanged(_:)), for: .valueChanged)
        
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        titleLabel.textColor = UIColor.black
        
        contentView.addSubview(radiobox)
        radiobox.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            radiobox.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            radiobox.widthAnchor.constraint(equalToConstant: 22.0),
            radiobox.heightAnchor.constraint(equalToConstant: 22.0),
            radiobox.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: radiobox.trailingAnchor, constant: 12.0),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(indexPath: IndexPath, title: String, radioboxChecked: Bool, callbackClosure: ((_ cellIndexPath: IndexPath, _ checked: Bool) -> Void)?){
        
        cellIndexPath = indexPath
        self.callbackClosure = callbackClosure
        radiobox.isOn = radioboxChecked
        
        titleLabel.text = title
    }
    
    @objc
    func radioboxValueChanged(_ sender: Any){
        callbackClosure?(cellIndexPath, radiobox.isOn)
    }
}
