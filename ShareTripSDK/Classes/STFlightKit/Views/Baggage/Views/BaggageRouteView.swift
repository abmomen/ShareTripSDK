//
//  BaggageHeaderView.swift
//  ShareTrip
//
//  Created by ShareTrip iOS on 21/12/20.
//  Copyright © 2020 ShareTrip. All rights reserved.
//

import UIKit
import STFlightKit

protocol BaggageRouteViewDelegate: AnyObject {
    func reloadView()
}

class BaggageRouteView: UIView {
    private var title: String = ""
    private let baggageViewModel: BaggageViewModel
    private let routeIndex: Int
    private weak var delegate: BaggageRouteViewDelegate?
    
    private lazy var titleContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
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
        stack.distribution = .fill
        return stack
    }()
    
    //MARK:- Initial Setup
    init(baggageViewModel : BaggageViewModel, routeIndex: Int, delegate: BaggageRouteViewDelegate?) {
        self.routeIndex = routeIndex
        self.baggageViewModel = baggageViewModel
        self.delegate = delegate
        super.init(frame: .zero)
        for view in stackView.arrangedSubviews { view.removeFromSuperview() }
       
        handleExpandButtonState()
        setupView()
        setupStackView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(titleContainerView)
        addSubview(stackView)
        titleContainerView.addSubview(titleButton)
        titleButton.setTitle(baggageViewModel.getTitle(for: routeIndex), for: .normal)
        titleContainerView.addSubview(button)
        stackView.isHidden = baggageViewModel.getCollapseStatus(by: routeIndex)
        
        titleContainerView.isHidden = baggageViewModel.isBaggageForWholeFlight()
        let titleViewHeight: CGFloat = baggageViewModel.isBaggageForWholeFlight() ? 0.0 : 56.0
        
                
        NSLayoutConstraint.activate ([
            titleContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleContainerView.topAnchor.constraint(equalTo: topAnchor),
            titleContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleContainerView.heightAnchor.constraint(equalToConstant: titleViewHeight),
            
            titleButton.leadingAnchor.constraint(equalTo: titleContainerView.leadingAnchor, constant: 16.0),
            titleButton.topAnchor.constraint(equalTo: titleContainerView.topAnchor),
            titleButton.bottomAnchor.constraint(equalTo: titleContainerView.bottomAnchor),
            
            button.leadingAnchor.constraint(equalTo: titleButton.trailingAnchor),
            button.widthAnchor.constraint(equalToConstant: 24.0),
            button.heightAnchor.constraint(equalToConstant: 24.0),
            button.centerYAnchor.constraint(equalTo: titleContainerView.centerYAnchor),
            button.trailingAnchor.constraint(equalTo: titleContainerView.trailingAnchor, constant: -16.0),
            
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.topAnchor.constraint(equalTo: titleContainerView.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    //MARK:- Button Action
    @objc private func buttonTapped() {
        baggageViewModel.setIsCollapsed(routeIndex: routeIndex, travellerIndex: nil)
        handleExpandButtonState()
        delegate?.reloadView()
    }
    
    @objc func titleButtonTapped() {
        buttonTapped()
    }
    
    //MARK:- Utils
    private func handleExpandButtonState() {
        if  baggageViewModel.getCollapseStatus(by: routeIndex) {
            let image = UIImage(named: "arrow-down-fat-mono")?.tint(with: .appPrimary)
            button.setImage(image, for: .normal)
        } else {
            let image = UIImage(named: "arrow-up-fat-mono")?.tint(with: .appPrimary)
            button.setImage(image, for: .normal)
        }
        stackView.layoutIfNeeded()
    }
    
    private func setupStackView() {
        if baggageViewModel.isPerPerson() {
            for travellerIndex in 0..<baggageViewModel.travellerCount() {
                if baggageViewModel.getTravelerType(using: travellerIndex) == .inf {
                    continue
                } else {
                    createOptions(travellerIndex: travellerIndex, travelerType: baggageViewModel.getTravelerType(using: travellerIndex))
                }
            }
            return
        }
        createOptions(travellerIndex: 0, travelerType: baggageViewModel.getTravelerType(using: 0))
    }
    
    private func createOptions(travellerIndex: Int, travelerType: BaggageTravellerType) {
        let baggageSelectionView = BaggageSelectionView(
            routeIndex: routeIndex,
            travellerIndex: travellerIndex,
            travelerType: travelerType, baggageViewModel: baggageViewModel,
            delegate: self
        )
        stackView.addArrangedSubview(baggageSelectionView)
    }
}

//MARK:- BaggageRouteView extension
extension BaggageRouteView: BaggageSelectionViewDelegate {
    func travellerSelectedOption(travellerType: BaggageTravellerType, travellerIndex: Int, optionIndex: Int, option: BaggageWholeFlightOptions) {
        baggageViewModel.setBagggeSelected(
            routeIndex: routeIndex,
            travellerIndex: travellerIndex,
            travellerType: travellerType,
            optionIndex: optionIndex,
            option: option
        )
        delegate?.reloadView()
    }
    
    func optionsExpanded(travellerIndex: Int) {
        if baggageViewModel.isPerPerson() {
            baggageViewModel.setIsCollapsed(routeIndex: routeIndex, travellerIndex: travellerIndex)
        } else {
            baggageViewModel.setIsCollapsed(routeIndex: routeIndex, travellerIndex: nil)
        }
        delegate?.reloadView()
    }
}
