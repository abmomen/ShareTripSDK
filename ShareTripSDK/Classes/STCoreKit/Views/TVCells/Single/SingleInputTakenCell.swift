//
//  SingleInputTakenCell.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 02/09/2020.
//  Copyright © 2020 ShareTrip. All rights reserved.
//

import UIKit

public class SingleInputTakenCell: UITableViewCell {

    @IBOutlet private weak var topDotsImageView: UIImageView!
    @IBOutlet private weak var inputTypeImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var underlineView: UIView!
    @IBOutlet private weak var inputTextField: UITextField!

    private var cellIndexPath: IndexPath!
    private var callbackClosure: ((IndexPath, String) -> Void)?

    public override func awakeFromNib() {
        super.awakeFromNib()
        inputTextField.addTarget(self, action: #selector(SingleInputTakenCell.textFieldDidChange(_:)), for: .editingChanged)
    }

    public func configure(indexPath: IndexPath, singleInputData: SingleInputTitleData, callbackClosure: ((_ cellIndexPath: IndexPath,_ textString: String) -> Void)?){
        titleLabel.text = singleInputData.titleLabel
        cellIndexPath = indexPath
        self.callbackClosure = callbackClosure

        if indexPath.row == 0 {
            topDotsImageView.isHidden = true
        } else {
            topDotsImageView.isHidden = false
        }

        if singleInputData.inputValue != nil {
            let placeholderText = NSAttributedString(string: singleInputData.placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.6)])
            inputTextField.attributedPlaceholder = placeholderText

        } else {
            let placeholderText = NSAttributedString(string: singleInputData.placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            inputTextField.attributedPlaceholder = placeholderText
        }
        inputTypeImageView.image = UIImage(named: singleInputData.inputTypeImage)?.tint(with: .white)
    }

    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        guard let textFieldText = textField.text else {return}
        callbackClosure?(cellIndexPath, textFieldText)
    }
}


