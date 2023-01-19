//
//  EditableContactCell.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 11/26/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

public class EditableContactCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var editTextField: UITextField!

    private var cellIndexPath: IndexPath!
    private var callbackClosure: ((IndexPath, String?) -> Void)?

    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        setupView()
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    public func setupView() {
        editTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }

    public func configure(imageName: String, titleText: String, subTitleText: String?, editingMode: Bool, cellIndexPath: IndexPath, callbackClosure: ((_ cellIndexPath: IndexPath, _ value: String?) -> Void)?) {

        self.cellIndexPath = cellIndexPath
        self.callbackClosure = callbackClosure

        subTitleLabel.isHidden = editingMode
        editView.isHidden = !editingMode

        imgView.image = UIImage(named: imageName)
        titleLabel.text = titleText
        subTitleLabel.text = subTitleText
        editTextField.text = subTitleText
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        callbackClosure?(cellIndexPath, editTextField.text)
    }
}
