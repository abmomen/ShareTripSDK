//
//  HorizontalLineCell.swift
//  STCoreKit
//
//  Created by ST-iOS on 12/4/22.
//

import UIKit

public class HorizontalLineCell: UITableViewCell {
    
    private var heightConstantLC: NSLayoutConstraint!
    private var bottomHorizontalLine = UIView()
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        bottomHorizontalLine.backgroundColor = UIColor.paleGray
        contentView.addSubview(bottomHorizontalLine)
        bottomHorizontalLine.translatesAutoresizingMaskIntoConstraints = false
        
        bottomHorizontalLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0).isActive = true
        bottomHorizontalLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0).isActive = true
        bottomHorizontalLine.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.0).isActive = true
        heightConstantLC = bottomHorizontalLine.heightAnchor.constraint(equalToConstant: 1.0)
        heightConstantLC.isActive = true
    }
    
    public func configure(lineHeight: CGFloat){
        heightConstantLC.constant = lineHeight
    }
}

