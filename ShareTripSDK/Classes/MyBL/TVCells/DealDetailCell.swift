//
//  DealsDetailCell.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 4/29/20.
//  Copyright © 2020 ShareTrip. All rights reserved.
//

import UIKit

class DealDetailCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var offerTypeView: UIView!
    @IBOutlet private weak var offerTypeImageView: UIImageView!
    @IBOutlet private weak var offerTypeTitle: UILabel!
    @IBOutlet private weak var contanerView: UIView!
    @IBOutlet weak var fullDescription: UITextView!
    
    func configure(dealsAndUpdates: NotifierDeal) {
        titleLabel.text = dealsAndUpdates.title ?? ""
        fullDescription.text = dealsAndUpdates.description?.trimmingCharacters(in: .whitespacesAndNewlines)
        dateLabel.text = (dealsAndUpdates.timeStamp ?? 0.0).getStringDate()
        offerTypeView.layer.cornerRadius = 8.0
        offerTypeView.isHidden = true
    }
}
