//
//  HeaderSpacedTitleView.swift
//  ShareTrip
//
//  Created by Mac on 2/27/20.
//  Copyright © 2020 TBBD IOS. All rights reserved.
//

import UIKit

public class HeaderSpacedTitleView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public init(with title: String, font: UIFont = UIFont.systemFont(ofSize: 13, weight: .medium)) {
        super.init(frame: CGRect.zero)
        
        setupView(with: title, font: font)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(with title: String, font: UIFont) {
        backgroundColor = .clear
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.0),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
        
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: 1.88, range: NSRange(location: 0, length: attributedString.length - 1))
        attributedString.addAttributes(
            [
                NSAttributedString.Key.kern: 1.88,
                NSAttributedString.Key.foregroundColor: UIColor.darkGray,
                NSAttributedString.Key.font: font
            ],
            range: NSRange(location: 0, length: attributedString.length))
        titleLabel.attributedText = attributedString
    }
}
