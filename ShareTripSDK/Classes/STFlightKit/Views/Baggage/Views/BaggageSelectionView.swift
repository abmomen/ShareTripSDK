//
//  BaggageSelectionView.swift
//  ShareTrip
//
//  Created by ShareTrip iOS on 20/12/20.
//  Copyright © 2020 ShareTrip. All rights reserved.
//

import UIKit



protocol BaggageSelectionViewDelegate: AnyObject {
    func travellerSelectedOption(travellerType: BaggageTravellerType, travellerIndex: Int, optionIndex: Int, option: BaggageWholeFlightOptions)
    func optionsExpanded(travellerIndex: Int)
}

class BaggageSelectionView: UIView {
    private weak var delegate: BaggageSelectionViewDelegate?
    private var routeIndex: Int
    private var travellerIndex: Int
    private var baggageViewModel: BaggageViewModel
    private var travelerType: BaggageTravellerType
    
    private lazy var titleContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile-mono")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: .bold)
        button.setTitleColor(.black, for: .normal)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(titleButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillEqually
        return stack
    }()
    
    init(
        routeIndex: Int,
        travellerIndex: Int,
        travelerType: BaggageTravellerType,
        baggageViewModel: BaggageViewModel,
        delegate: BaggageSelectionViewDelegate?
    ) {
        self.routeIndex = routeIndex
        self.travellerIndex = travellerIndex
        self.baggageViewModel = baggageViewModel
        self.travelerType = travelerType
        self.delegate = delegate
        
        super.init(frame: .zero)
        setupView()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonTapped() {
        delegate?.optionsExpanded(travellerIndex: travellerIndex)
        handleExpandButtonState()
    }
    
    @objc func titleButtonTapped() {
        buttonTapped()
    }
    
    private func handleExpandButtonState() {
        if baggageViewModel.getCollapseStatus(by: routeIndex, and: travellerIndex) {
            let image = UIImage(named: "minus-mono")?.tint(with: .appPrimary)
            button.setImage(image, for: .normal)
        } else {
            let image = UIImage(named: "plus-mono")?.tint(with: .appPrimary)
            button.setImage(image, for: .normal)
        }
        stackView.layoutIfNeeded()
    }
    
    private func setupView() {
        handleExpandButtonState()
        titleContainerView.isHidden = !baggageViewModel.isPerPerson()
        
        switch travelerType {
        case .adt:
            titleButton.setTitle("Traveller \(travellerIndex + 1) (Adult)", for: .normal)
        case .chd:
            titleButton.setTitle("Traveller \(travellerIndex + 1) (Child)", for: .normal)
        case .inf:
            STLog.info("")
        }
        
        let isRouteCollapsed = baggageViewModel.getCollapseStatus(by: routeIndex)
        let isRouteExpanded = baggageViewModel.getCollapseStatus(by: routeIndex, and: travellerIndex)
        
        let options = baggageViewModel.getOptionsPerRoute(for: travelerType, routeIndex: routeIndex)

        let stackViewHeight = isRouteExpanded ? CGFloat(options.count * 56) : 0.0
        
        var headerViewHeight: CGFloat = isRouteCollapsed ? 0 : 44.0
        headerViewHeight = baggageViewModel.isPerPerson() ? headerViewHeight : 0.0
        
        addSubview(titleContainerView)
        addSubview(stackView)
        stackView.isHidden = !isRouteExpanded
        
        titleContainerView.addSubview(imageView)
        titleContainerView.addSubview(titleButton)
        titleContainerView.addSubview(button)
        
        NSLayoutConstraint.activate([
            titleContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleContainerView.topAnchor.constraint(equalTo: topAnchor),
            titleContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleContainerView.heightAnchor.constraint(equalToConstant: headerViewHeight),
            
            imageView.leadingAnchor.constraint(equalTo: titleContainerView.leadingAnchor, constant: 16.0),
            imageView.centerYAnchor.constraint(equalTo: titleContainerView.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 24.0),
            imageView.widthAnchor.constraint(equalToConstant: 24.0),
            
            titleButton.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8.0),
            titleButton.topAnchor.constraint(equalTo: titleContainerView.topAnchor),
            titleButton.bottomAnchor.constraint(equalTo: titleContainerView.bottomAnchor),
            
            button.leadingAnchor.constraint(equalTo: titleButton.trailingAnchor),
            button.centerYAnchor.constraint(equalTo: titleContainerView.centerYAnchor),
            button.trailingAnchor.constraint(equalTo: titleContainerView.trailingAnchor, constant: -16.0),
            button.widthAnchor.constraint(equalToConstant: 22.0),
            button.heightAnchor.constraint(equalToConstant: 22.0),
            
            stackView.topAnchor.constraint(equalTo: titleContainerView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.heightAnchor.constraint(equalToConstant: stackViewHeight)
        ])
        stackView.layoutIfNeeded()
    }
    
    private var baggageSubViews = [BaggageOptionView]()
    private func configureView() {
        for view in stackView.subviews { view.removeFromSuperview() }
        let options = baggageViewModel.getOptionsPerRoute(for: travelerType, routeIndex: routeIndex)

        for index in 0..<options.count {
            let optionView = BaggageOptionView(
                frame: .zero,
                isSelected: baggageViewModel.getSelectedBaggageIndex(routeIndex: routeIndex, travellerIndex: travellerIndex, optionIndex: index),
                option: options[index],
                optionIndex: index,
                delegate: self
            )
            baggageSubViews.append(optionView)
            stackView.addArrangedSubview(optionView)
        }
    }
}

extension BaggageSelectionView: BaggageOptionViewDelegate {
    func optionSelected(optionIndex: Int, isSelected: Bool, option: BaggageWholeFlightOptions) {
        delegate?.travellerSelectedOption(travellerType: travelerType, travellerIndex: travellerIndex, optionIndex: optionIndex, option: option)
    }
}
