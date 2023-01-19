//
//  LeftInfoHeaderView.swift
//  STCoreKit
//
//  Created by ST-iOS on 12/6/22.
//

import UIKit

public class LeftInfoHeaderView: UITableViewHeaderFooterView {
    
    public let customLabel = UILabel()
    public let bottomLineView = UIView()
    
    override public init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        customLabel.font = UIFont.systemFont(ofSize: 13.0, weight: .medium)
        customLabel.textColor = UIColor.blueGray
        customLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(customLabel)
        
        bottomLineView.backgroundColor = UIColor.paleGray
        bottomLineView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(bottomLineView)
        
        NSLayoutConstraint.activate([
            customLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.0),
            customLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 4.0),
            customLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            customLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 16.0),
            
            bottomLineView.heightAnchor.constraint(equalToConstant: 1.0),
            bottomLineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0.0),
            bottomLineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0.0),
            bottomLineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0.0)
            
        ])
    }
}
