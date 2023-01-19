//
//  PriceChangeView.swift
//  ShareTrip
//
//  Created by Nazmul Islam on 4/5/20.
//  Copyright © 2020 ShareTrip. All rights reserved.
//

import UIKit


class PriceChangeView: UIView, NibBased {

    @IBOutlet weak var previousPriceLabel: UILabel!
    @IBOutlet weak var updatedPriceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
//        backgroundColor = UIColor.black.withAlphaComponent(0.24)
    }

    func configure(with viewModel: PriceChangeView.ViewModel) {
        previousPriceLabel.text = viewModel.previousPriceStr
        updatedPriceLabel.text = viewModel.updatedPriceStr
    }

    typealias CallBackType = () -> Void
    var checkAnotherFlightCallback: CallBackType?
    var continueButtonCallBack: CallBackType?

    @IBAction func onCheckAnotherFlightButtonTapped(_ sender: UIButton) {
        checkAnotherFlightCallback?()
    }

    @IBAction func onContinueButtonTapped(_ sender: UIButton) {
        continueButtonCallBack?()
    }
}

extension PriceChangeView {
    struct ViewModel {
        let previousPrice: Double
        let updatedPrice: Double

        var previousPriceStr: String { "BDT \(previousPrice.withCommas())" }
        var updatedPriceStr: String { "BDT \(updatedPrice.withCommas())" }
    }
}
