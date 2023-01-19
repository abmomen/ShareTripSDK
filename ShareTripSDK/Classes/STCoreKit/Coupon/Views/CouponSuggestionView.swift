//
//  CouponSuggestionView.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 12/04/2021.
//  Copyright © 2021 ShareTrip. All rights reserved.
//

import UIKit

extension CouponSuggestionView {
    class Callback {
        var didSelectCouponView: (_ index: Int) -> Void = { _ in }
    }
}

class CouponSuggestionView: UIView, NibBased {
    @IBOutlet private weak var couponLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var withDiscountLabel: UILabel!
    
    var index = 0
    let callback = Callback()
    
    var promotionalCoupon: PromotionalCoupon? {
        didSet {
            couponLabel.text = promotionalCoupon?.coupon ?? ""
            subTitleLabel.text = promotionalCoupon?.title ?? ""
            withDiscountLabel.text = withDiscountText
        }
    }
    
    var isSelected: Bool = false {
        didSet {
            layer.borderColor = isSelected ? UIColor.appPrimary.cgColor : UIColor.blueGray.cgColor
        }
    }
    
    private var isWithDiscount: Bool {
        guard let promotionalCoupon = promotionalCoupon else { return false }
        return promotionalCoupon.withDiscount.uppercased() == "YES"
    }
    
    private var withDiscountText: String {
        return isWithDiscount ? "WITH DISCOUNT" : ""
    }
    
    @IBAction private func didTapCoupon(_ sender: UIButton) {
        callback.didSelectCouponView(index)
    }
    
    func setupView() {
        layer.borderWidth = 1
        layer.cornerRadius = 8
        couponLabel.text = ""
        subTitleLabel.text = ""
        withDiscountLabel.text = ""
        layer.borderColor = UIColor.blueGray.cgColor
    }
}
