//
//  FlightEditContactButtonCell.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 11/27/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

class FlightEditContactButtonCell: UITableViewCell {

    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    var editButtonAction: (() -> ())?
    var saveButtonAction: (() -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(showEdit: Bool, showSave: Bool) {
        editButton.isHidden = !showEdit
        saveButton.isHidden = !showSave
    }
    @IBAction func editButtonTapped(_ sender: UIButton) {
        editButtonAction?()
    }
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        saveButtonAction?()
    }

}
