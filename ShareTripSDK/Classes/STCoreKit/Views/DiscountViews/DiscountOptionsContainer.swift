//
//  DiscountOptionView.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 30/11/2019.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

public protocol DiscountOptionViewDelegate: AnyObject {
    func selectedOptionChanged(_ selectedOptionView: DiscountOptionCollapsibleView)
}

public class DiscountOptionsContainer: UIStackView {
    
    public var discountOptionViews = [DiscountOptionCollapsibleView]() {
        didSet {
            addSubviews()
        }
    }
    
    public var mustSelectOne: Bool = true
    public weak var delegate: DiscountOptionViewDelegate?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .vertical
        alignment = .fill
        distribution = .fill
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func clearView() {
        for view in subviews {
            view.removeFromSuperview()
        }
    }
    
    private func addSubviews() {
        for view in discountOptionViews {
            view.delegate = self
            addArrangedSubview(view)
        }
    }
    
    private func collapseAll() {
        for view in discountOptionViews {
            view.collapse()
        }
    }
}
//MARK:- DiscountOptionCollapsibleViewDelegate
extension DiscountOptionsContainer: DiscountOptionCollapsibleViewDelegate {
    public func onDisCountOptionSelected(discountOptionView: DiscountOptionCollapsibleView) {
        let alreadyExpanded = discountOptionView.expanded
        collapseAll()
        
        if mustSelectOne || !alreadyExpanded {
            discountOptionView.expand()
        }
        delegate?.selectedOptionChanged(discountOptionView)
    }
}
