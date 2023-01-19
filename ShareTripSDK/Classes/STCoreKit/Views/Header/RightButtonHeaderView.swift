//
//  RightButtonHeaderView.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 11/27/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

public class RightButtonHeaderView: UITableViewHeaderFooterView {
    
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let rightButton: UIButton = {
        let button = UIButton()
        button.setTitle("EDIT", for: .normal)
        button.contentHorizontalAlignment = .trailing
        button.setTitleColor(UIColor(hex: 0x1882ff), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override public init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.backgroundColor = UIColor.paleGray
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(rightButton)
        self.contentView.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            
            rightButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            rightButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            rightButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
    }
}
