//
//  DiscountOptionViewProtocols.swift
//  ShareTrip
//
//  Created by Nazmul Islam on 6/6/20.
//  Copyright © 2020 ShareTrip. All rights reserved.
//

import UIKit

public protocol DiscountOptionCollapsibleView: UIView {
    var title: String { get }
    var discountAmount: Double { get }
    var discountOptionType: DiscountOptionType { get }
    var delegate: DiscountOptionCollapsibleViewDelegate? { get set }
    var expanded: Bool { get }
    func expand()
    func collapse()
}

public protocol DiscountOptionCollapsibleViewDelegate: AnyObject {
    func onDisCountOptionSelected(discountOptionView: DiscountOptionCollapsibleView)
}
