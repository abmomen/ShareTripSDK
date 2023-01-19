//
//  CollapsibleHeaderView.swift
//  TBBD
//
//  Created by TBBD on 4/3/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

public protocol CollapsibleHeaderViewDelegate: AnyObject {
    func toggleSection(_ section: Int)
}

open class CollapsibleHeaderView: UITableViewHeaderFooterView {
    
    public weak var delegate: CollapsibleHeaderViewDelegate?
    public var section: Int = 0
    
    public let titleLabel = UILabel()
    public let arrowImageView = UIImageView()
    public let horizontalLineView = UIView()
    
    
    override public init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let cell = gestureRecognizer.view as? CollapsibleHeaderView else {
            return
        }
        _ = delegate?.toggleSection(cell.section)
    }
    
    public func setCollapsed(_ collapsed: Bool) {
        arrowImageView.rotate(collapsed ? 0.0 : .pi)
    }
    
    private func setupView() {
        contentView.backgroundColor = .white
        
        contentView.addSubview(arrowImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(horizontalLineView)
        
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        horizontalLineView.translatesAutoresizingMaskIntoConstraints = false
        
        arrowImageView.image = UIImage(named: "arrow-down-mono")
        
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .medium)
        
        horizontalLineView.backgroundColor = UIColor.whitishGray
        let height = (1.0 / UIScreen.main.scale) < 0 ? (1.0 / UIScreen.main.scale)*2 : 1.0
        
        
        NSLayoutConstraint.activate([
            arrowImageView.widthAnchor.constraint(equalToConstant: 24),
            arrowImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -26),
            arrowImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            horizontalLineView.heightAnchor.constraint(equalToConstant: height),
            horizontalLineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            horizontalLineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            horizontalLineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        ])
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CollapsibleHeaderView.tapHeader(_:))))
    }
}
