//
//  ChildCalendarTopView.swift
//  ConfigurableCalendar
//
//  Created by Nazmul Islam on 29/3/20.
//  Copyright © 2020 TBBD. All rights reserved.
//

import UIKit
import STCoreKit

class FlightCalendarTopView: UIView, NibBased {
    @IBOutlet weak var chepIndicator: UIView!
    @IBOutlet weak var cheapLabel: UILabel!

    @IBOutlet weak var midIndicator: UIView!
    @IBOutlet weak var midLabel: UILabel!

    @IBOutlet weak var highIndicator: UIView!
    @IBOutlet weak var highLabel: UILabel!

    @IBOutlet weak var notFoundIndicator: UIView!
    @IBOutlet weak var notFoundLabel: UILabel!

    @IBOutlet weak var filterSwitch: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    typealias SwitchCallBack = (_ isOn: Bool) -> Void
    var switchCallBack: SwitchCallBack?
    @IBAction func onNonStopFlightSwitchToggled(_ sender: UISwitch) {
        switchCallBack?(sender.isOn)
    }

    func setupUI() {
        chepIndicator.backgroundColor = IndicatorType.green.color
        cheapLabel.text = PriceRangeType.cheap.title

        midIndicator.backgroundColor = IndicatorType.yellow.color
        midLabel.text = PriceRangeType.moderate.title

        highIndicator.backgroundColor = IndicatorType.red.color
        highLabel.text = PriceRangeType.expensive.title

        notFoundIndicator.backgroundColor = IndicatorType.unknown.color
        notFoundLabel.text = PriceRangeType.unknown.title
    }

    func updatePriceIndicatorLabels(priceIndicator: FlightPriceIndicatorViewModel) {
        if let chepPriceRange = priceIndicator.priceRange(for: .cheap) {
            let low: Int = Int(floor(chepPriceRange.0 / 1000))
            let high: Int = Int(round(chepPriceRange.1 / 1000))
            cheapLabel.text = "\(low)K - \(high)K"
        }

        if let mediumPriceRange = priceIndicator.priceRange(for: .moderate) {
            let low: Int = Int(round(mediumPriceRange.0 / 1000))
            let high: Int = Int(round(mediumPriceRange.1 / 1000))
            midLabel.text = "\(low)K - \(high)K"
        }

        if let expensivePriceRange = priceIndicator.priceRange(for: .expensive) {
            let low: Int = Int(round(expensivePriceRange.0 / 1000))
            let high: Int = Int(ceil(expensivePriceRange.1 / 1000))
            highLabel.text = "\(low)K - \(high)K"
        }
    }
}
