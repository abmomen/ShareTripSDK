//
//  FlightEditContactButtonCell.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 11/27/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

class FlightEditContactButtonCell: UITableViewCell {

    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var saveButton: UIButton!
    
    var editButtonAction: (() -> ())?
    var saveButtonAction: (() -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(showEdit: Bool, showSave: Bool) {
        editButton.isHidden = !showEdit
        saveButton.isHidden = !showSave
        editButton.tintColor = .appPrimary
        saveButton.tintColor = .appPrimary
    }
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        editButtonAction?()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        saveButtonAction?()
    }

}
