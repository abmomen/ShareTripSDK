//
//  FlightSortingButtonGroups.swift
//  ShareTrip
//
//  Created by Nazmul Islam on 15/4/20.
//  Copyright © 2020 ShareTrip. All rights reserved.
//

import UIKit

protocol FlightSortingButtonGroupDelegate: AnyObject {
    func sortingButtonTapped(buttonType: FlightSortingOptions, isOn: Bool)
}

class FlightSortingButtonGroup: UIView {
    @IBOutlet weak var earliestButton: FlightSortingButton!
    @IBOutlet weak var cheapestButton: FlightSortingButton!
    @IBOutlet weak var fastestButton: FlightSortingButton!

    private let height = 38
    @IBOutlet weak var heightAnchorLC: NSLayoutConstraint!
    private var sortingButtons: [FlightSortingButton] {
        return [earliestButton, cheapestButton, fastestButton]
    }

    private weak var delegate: FlightSortingButtonGroupDelegate?
    func setup(delegate: FlightSortingButtonGroupDelegate?) {
        earliestButton.type = .earliest
        cheapestButton.type = .cheapest
        fastestButton.type = .fastest
        self.delegate = delegate
    }
    
    private var isFirstSearch = false
    
    func setSelected(option: FlightSortingOptions) {
        if !isFirstSearch {
            deselectAll()
            switch option {
            case .earliest:
                earliestButton.select()
            case .cheapest:
                cheapestButton.select()
            case .fastest:
                fastestButton.select()
            default:
                break
            }
        }
        isFirstSearch = true
    }

    func deselectAll() {
        for button in sortingButtons {
            button.deselect()
        }
    }

    func hide() {
        isHidden = true
        heightAnchorLC.constant = 0
    }

    func show() {
        heightAnchorLC.constant = CGFloat(height)
        isHidden = false
    }

    func enable() {
        for button in  sortingButtons {
            button.isEnabled = true
            button.alpha = 1.0
        }
    }

    func disable() {
        for button in sortingButtons {
            button.isEnabled = false
            button.alpha = 0.6
        }
    }

    @IBAction func onSortingButtonTapped(_ button: FlightSortingButton) {
        let alreadyActive = button.active
        deselectAll()
        if !alreadyActive {
            button.select()
        }
        delegate?.sortingButtonTapped(buttonType: button.type, isOn: button.active)
    }
}
