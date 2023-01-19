//
//  TravelerCell.swift
//  ShareTrip
//
//  Created by Mac on 9/12/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

extension TravelerCell {
    class Callback {
        var didStepperValueChanged: (Int) -> Void = { _ in }
    }
}

class TravelerCell: UITableViewCell {
    
    @IBOutlet private weak var numberLabel: UILabel!
    @IBOutlet private weak var typeLabel: UILabel!
    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var stepper: UIStepper!

    let callback = Callback()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        stepper.stepValue = 1
    }
    
    var currentValue = 0 {
        didSet {
            numberLabel.text = String(currentValue)
            stepper.value = Double(currentValue)
        }
    }
    
    var min = 0 {
        didSet {
            stepper.minimumValue = Double(min)
        }
    }
    
    var max = 0 {
        didSet {
            stepper.maximumValue = Double(max)
        }
    }

    func config(travellerType: TravellerType) {
        typeLabel.text = travellerType.rawValue
        infoLabel.text = travellerType.requiredInfo
    }
    
    @IBAction private func stepperValueChanged(_ sender: UIStepper) {
        currentValue = Int(sender.value)
        callback.didStepperValueChanged(Int(sender.value))
    }
}
