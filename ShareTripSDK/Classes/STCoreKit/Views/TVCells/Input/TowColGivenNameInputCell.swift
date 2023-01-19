//
//  SDFirstNameInputCell.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 13/11/2019.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

public struct TowColGivenNameInputCellData {
    public let imageString: String
    public let titleNameTitle: String
    public let titleNameText: String
    public let givenNameTitle: String
    public let givenNameText: String
    public let pickerData: [String]
    public let titleNameState: ValidationState
    public let givenNameState: ValidationState
    public let indexPath: IndexPath?
    public let delegate: TowColGivenNameInputCellDelegate?
    
    public init(imageString: String, titleNameTitle: String, titleNameText: String, givenNameTitle: String, givenNameText: String, pickerData: [String], titleNameState: ValidationState = .normal, givenNameState: ValidationState = .normal, indexPath: IndexPath? = nil, delegate: TowColGivenNameInputCellDelegate? = nil) {
        self.imageString = imageString
        self.titleNameTitle = titleNameTitle
        self.titleNameText = titleNameText
        self.givenNameTitle = givenNameTitle
        self.givenNameText = givenNameText
        self.pickerData = pickerData
        self.titleNameState = titleNameState
        self.givenNameState = givenNameState
        self.indexPath = indexPath
        self.delegate = delegate
    }
}

public protocol TowColGivenNameInputCellDelegate: AnyObject {
    func titleNameChanged(for indexPath: IndexPath?, text: String, selectedRow: Int)
    func givenNameChanged(for indexPath: IndexPath?, text: String)
}

public class TowColGivenNameInputCell: UITableViewCell {
    
    //MARK:- IBOutlets
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleNameTitleLabel: UILabel!
    @IBOutlet private weak var titleNameTextField: NoSelectTextField!
    @IBOutlet private weak var titleNameDividerView: UIView!
    @IBOutlet private weak var givenNameTitleLabel: UILabel!
    @IBOutlet private weak var givenNameTextFiled: UITextField!
    @IBOutlet private weak var givenNameDividerView: UIView!
    
    //MARK:- Properties
    private var indexPath: IndexPath?
    private var titleNameState: ValidationState = .normal {
        didSet {
            onTitleNameTextFieldStateChanged()
        }
    }
    private var givenNameState: ValidationState = .normal {
        didSet {
            onGivenNameTextFiledStateChanged()
        }
    }
    private var picker: DataPickerView?
    private var pickerAccessory: UIToolbar?
    private var titleNameTitle: String = ""
    private var givenNameTitle: String = ""
    private weak var delegate: TowColGivenNameInputCellDelegate?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK:- Config
    public func configure(_ data: TowColGivenNameInputCellData) {
        selectionStyle = .none
        titleNameTextField.delegate = self
        givenNameTextFiled.delegate = self
        givenNameTextFiled.addTarget(self, action: #selector(onGivenNameChanged(_:)), for: .editingChanged)
        
        //right down arrow
        let downArrowImageView = UIImageView(image: UIImage(named: "arrow-down-mono"))
        downArrowImageView.contentMode = UIView.ContentMode.center
        titleNameTextField.rightView = downArrowImageView
        titleNameTextField.rightView?.tintColor = UIColor.blueGray
        titleNameTextField.rightViewMode = .always
        
        iconImageView.image = UIImage(named: data.imageString)
        
        titleNameTitle = data.titleNameTitle
        titleNameTitleLabel.text = titleNameTitle
        titleNameTextField.text = data.titleNameText
        
        givenNameTitle = data.givenNameTitle
        givenNameTitleLabel.text = givenNameTitle
        givenNameTextFiled.text = data.givenNameText
        
        titleNameState = data.titleNameState
        givenNameState = data.givenNameState
        
        indexPath = data.indexPath
        
        picker = DataPickerView()
        picker?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        picker?.data = data.pickerData
        titleNameTextField.inputView = picker
        
        pickerAccessory = UIToolbar(frame:CGRect(x:0, y:0, width: UIScreen.main.bounds.width, height: 44))
        pickerAccessory?.autoresizingMask = .flexibleHeight
        pickerAccessory?.barStyle = .default
        pickerAccessory?.barTintColor = UIColor.paleGray
        pickerAccessory?.backgroundColor = UIColor.paleGray
        pickerAccessory?.isTranslucent = false
        
        delegate = data.delegate
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBtnClicked(_:)))
        cancelButton.tintColor = UIColor(hex: 0x030303, alpha: 1.0)
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //a flexible space between the two buttons
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action:
                                            #selector(doneBtnClicked(_:)))
        doneButton.tintColor = UIColor(hex: 0x030303, alpha: 1.0)
        pickerAccessory?.items = [cancelButton, flexSpace, doneButton]
        titleNameTextField.inputAccessoryView = pickerAccessory
    }
    
    private func onTitleNameTextFieldStateChanged() {
        titleNameTitleLabel.textColor = titleNameState.color
        titleNameDividerView.backgroundColor = titleNameState.color
        switch titleNameState {
        case .warning(let message):
            titleNameTitleLabel.text = message
        default:
            titleNameTitleLabel.text = titleNameTitle
        }
    }
    
    private func onGivenNameTextFiledStateChanged() {
        givenNameTitleLabel.textColor = titleNameState.color
        givenNameDividerView.backgroundColor = titleNameState.color
        switch titleNameState {
        case .warning(let message):
            givenNameTitleLabel.text = message
        default:
            givenNameTitleLabel.text = titleNameTitle
        }
    }
    
    @objc
    func cancelBtnClicked(_ button: UIBarButtonItem?) {
        titleNameTextField.resignFirstResponder()
    }
    
    @objc
    func doneBtnClicked(_ button: UIBarButtonItem?) {
        titleNameTextField.resignFirstResponder()
        titleNameTextField.text = picker?.selectedValue
        
        if let selectedText = picker?.selectedValue,
           let selectedRow = picker?.selectedRow,
           selectedRow > -1 {
            delegate?.titleNameChanged(for: indexPath, text: selectedText, selectedRow: selectedRow)
        }
    }
    
    @objc
    private func onGivenNameChanged(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        delegate?.givenNameChanged(for: indexPath, text: text)
    }
}

//MARK:- UITextFieldDelegate
extension TowColGivenNameInputCell: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == titleNameTextField {
            titleNameState = .active
        } else if textField == givenNameTextFiled {
            givenNameState = .active
        }
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == titleNameTextField {
            titleNameState = .normal
        } else if textField == givenNameTextFiled {
            givenNameState = .normal
        }
    }
}
