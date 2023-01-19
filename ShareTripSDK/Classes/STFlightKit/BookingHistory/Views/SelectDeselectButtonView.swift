//
//  SelectDeselectViewButtonView.swift
//  ShareTrip
//
//  Created by ST-iOS on 5/22/22.
//  Copyright © 2022 ShareTrip. All rights reserved.
//

import UIKit

extension SelectDeselectButtonView {
    class Callback {
        var isSelected: (Bool) -> Void = { _ in }
    }
}

class SelectDeselectButtonView: UITableViewHeaderFooterView {
    private var isSelected = false
    var callback = Callback()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let rightButton: UIButton = {
        let button = UIButton()
        button.setTitle("select all".uppercased(), for: .normal)
        button.contentHorizontalAlignment = .trailing
        button.setTitleColor(UIColor(hex: 0x1882ff), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(SelectDeselectButtonView.self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        return button
    }()
    
    override public init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func didTapButton(_ sender: UIButton) {
        isSelected.toggle()
        let titleColor: UIColor = isSelected ? .lightGray: .appPrimary
        let title: String = isSelected ? "deselect all": "select all"
        rightButton.setTitle(title.uppercased(), for: .normal)
        rightButton.setTitleColor(titleColor, for: .normal)
        callback.isSelected(isSelected)
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
