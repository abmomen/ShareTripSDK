//
//  LeftRightPriceInfoCel.swift
//  ShareTrip
//
//  Created by ShareTrip iOS on 14/12/20.
//  Copyright © 2020 ShareTrip. All rights reserved.
//

import UIKit

public class LeftRightPriceInfoCell: UITableViewCell {
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Baggage"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.black
        label.textAlignment = .left
        return label
    }()
    
    private var amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Baggage price"
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = UIColor.black
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(amountLabel)
        
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2.0).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 16.0).isActive = true
        
        amountLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        amountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.0).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(title: String, amount: Double){
        titleLabel.text = title
        amountLabel.text = amount.withCommas()
    }
}
