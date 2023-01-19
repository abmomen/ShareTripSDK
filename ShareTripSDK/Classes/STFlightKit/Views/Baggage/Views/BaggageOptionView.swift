//
//  BaggageOptionView.swift
//  ShareTrip
//
//  Created by ShareTrip iOS on 20/12/20.
//  Copyright © 2020 ShareTrip. All rights reserved.
//

import UIKit
import STFlightKit

protocol BaggageOptionViewDelegate: AnyObject {
    func optionSelected(optionIndex: Int, isSelected: Bool, option: BaggageWholeFlightOptions)
}

class BaggageOptionView: UIView {
    private var option: BaggageWholeFlightOptions
    private var isSelected: Bool
    private var optionIndex: Int
    private weak var delegate: BaggageOptionViewDelegate?
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var topSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(hex: 0xefefef)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var selectionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "radiobox-blank-mono")
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .bold)
        label.textColor = UIColor.black
        return label
    }()
    
    private lazy var overlayButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("", for: .normal)
        button.addTarget(self, action: #selector(overlayButtonTapped), for: .touchUpInside)
        return button
    }()
    
    init(
        frame: CGRect,
        isSelected: Bool,
        option: BaggageWholeFlightOptions,
        optionIndex: Int,
        delegate: BaggageOptionViewDelegate?
    ) {
        self.optionIndex = optionIndex
        self.option = option
        self.isSelected = isSelected
        self.delegate = delegate
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func overlayButtonTapped() {
        if selectionImageView.image == UIImage(named: "radiobox-marked-mono") {
            delegate?.optionSelected(optionIndex: optionIndex, isSelected: true, option: option)
        } else {
            delegate?.optionSelected(optionIndex: optionIndex, isSelected: false, option: option)
        }
    }
    
    private func setupView() {
        containerView.addSubview(selectionImageView)
        containerView.addSubview(titleLabel)
        
        titleLabel.text = getTitleText()
        
        if isSelected {
            selectionImageView.image = UIImage(named: "radiobox-marked-mono")
        } else {
            selectionImageView.image = UIImage(named: "radiobox-blank-mono")
        }
        
        addSubview(containerView)
        addSubview(topSeparatorView)
        addSubview(overlayButton)
        
        NSLayoutConstraint.activate([
            topSeparatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topSeparatorView.topAnchor.constraint(equalTo: topAnchor),
            topSeparatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topSeparatorView.heightAnchor.constraint(equalToConstant: 1.0),
            
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            selectionImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            selectionImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            selectionImageView.widthAnchor.constraint(equalToConstant: 22.0),
            selectionImageView.heightAnchor.constraint(equalToConstant: 22.0),
            
            titleLabel.leadingAnchor.constraint(equalTo: selectionImageView.trailingAnchor, constant: 8.0),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            overlayButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            overlayButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            overlayButton.topAnchor.constraint(equalTo: topAnchor),
            overlayButton.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func getTitleText() -> String {
        if option.details == "Add No Baggage" {
            return "Add No Baggage"
        } else {
            return "Add \(option.details ?? "") \(option.quantity ?? 0) (\(option.currency.rawValue) \(option.amount ?? 0.0) Max \(option.quantity ?? 0) Bags)"
        }
    }
}
