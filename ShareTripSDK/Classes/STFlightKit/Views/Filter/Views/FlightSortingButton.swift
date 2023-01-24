//
//  FlightSortingButton.swift
//  ShareTrip
//
//  Created by Nazmul Islam on 15/4/20.
//  Copyright © 2020 ShareTrip. All rights reserved.
//

import UIKit

class FlightSortingButton: UIButton {
    var active: Bool = false
    var type: FlightSortingOptions = .earliest {
        didSet {
            setTitle(type.rawValue.uppercased(), for: .normal)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    func setup() {
        layer.cornerRadius = 4
        setTitle(type.rawValue.uppercased(), for: .normal)
        deselect()
    }

    func select() {
        active = true
        backgroundColor = .appPrimary
        layer.borderWidth = 0
        setTitleColor(.white, for: .normal)
    }

    func deselect() {
        active = false
        backgroundColor = .clear
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.cgColor
        setTitleColor(.blueGray, for: .normal)
    }
}
