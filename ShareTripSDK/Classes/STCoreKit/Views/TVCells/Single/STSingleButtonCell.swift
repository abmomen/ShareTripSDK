//
//  STSingleButtonCell.swift
//  ShareTrip
//
//  Created by Nazmul Islam on 17/5/20.
//  Copyright © 2020 ShareTrip. All rights reserved.
//

import UIKit

class STSingleButtonCell: UITableViewCell {
    
    @IBOutlet weak var button: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        button.layer.cornerRadius =  4
        button.clipsToBounds = true
    }
    
    private var indexPath: IndexPath?
    
    func configure(
        title: String,
        indexPath: IndexPath? = nil,
        backgroundColor: UIColor = .appPrimary,
        textColor: UIColor = .white
    ) {
        button.setTitle(title, for: .normal)
        self.indexPath = indexPath
        button.backgroundColor = backgroundColor
        button.setTitleColor(textColor, for: .normal)
    }

    typealias ButtonPressCallback = (IndexPath?) -> Void
    var buttonPressCallback: ButtonPressCallback?
    @IBAction private func onButtonPress(_ sender: Any) {
        buttonPressCallback?(indexPath)
    }
}
