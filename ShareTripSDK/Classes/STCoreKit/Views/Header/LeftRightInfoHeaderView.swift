//
//  PriceInfoHeaderView.swift
//  TBBD
//
//  Created by Mac on 4/23/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

public class LeftRightInfoHeaderView: UITableViewHeaderFooterView {
    
    public lazy var labelContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public lazy var leftLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 12.0, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    public lazy var rightLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 12.0, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    public var bottomAnchorLC: NSLayoutConstraint!
    
    override public init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    public func setText(left: String, right: String?) {
        leftLabel.text = left
        rightLabel.text = right
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        contentView.addSubview(labelContainerView)
        labelContainerView.addSubview(leftLabel)
        labelContainerView.addSubview(rightLabel)

        labelContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        labelContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        labelContainerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        bottomAnchorLC = labelContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        bottomAnchorLC.isActive = true
        
        leftLabel.leadingAnchor.constraint(equalTo: labelContainerView.leadingAnchor, constant: 8.0).isActive = true
        leftLabel.topAnchor.constraint(equalTo: labelContainerView.topAnchor, constant: 8).isActive = true
        leftLabel.bottomAnchor.constraint(equalTo: labelContainerView.bottomAnchor, constant: -8).isActive = true
        
        rightLabel.trailingAnchor.constraint(equalTo: labelContainerView.trailingAnchor, constant: -8.0).isActive = true
        rightLabel.centerYAnchor.constraint(equalTo: labelContainerView.centerYAnchor).isActive = true
    }
}
