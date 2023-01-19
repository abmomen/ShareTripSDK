//
//  FirstNameInputCell.swift
//  TBBD
//
//  Created by Mac on 5/12/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

//MARK: - FirstNameInputCellDelegate
public protocol FirstNameInputCellDelegate: AnyObject {
    func titleChanged(titleType: TitleType, indexPath: IndexPath)
    func firstNameChanged(name: String, indexPath: IndexPath)
}

public class FirstNameInputCell: UITableViewCell {
    
    @IBOutlet public weak var titleTextField: NoSelectTextField!
    @IBOutlet public weak var firstNameTextField: UITextField!
    
    public var cellIndexPath: IndexPath!
    public weak var delegate: FirstNameInputCellDelegate?
    public var picker: DataPickerView?
    public var pickerAccessory: UIToolbar?
    
    //MARK: - Cell life Cycle
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupCell(){
        picker = DataPickerView()
        picker?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        picker?.data = TitleType.allCases.map { $0.rawValue }
        titleTextField.inputView = picker
        
        pickerAccessory = UIToolbar(frame:CGRect(x:0, y:0, width: UIScreen.main.bounds.width, height: 44))
        pickerAccessory?.autoresizingMask = .flexibleHeight
        pickerAccessory?.barStyle = .default
        pickerAccessory?.barTintColor = UIColor.paleGray
        pickerAccessory?.backgroundColor = UIColor.paleGray
        pickerAccessory?.isTranslucent = false
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(FirstNameInputCell.cancelBtnClicked(_:)))
        cancelButton.tintColor = UIColor(hex: 0x030303, alpha: 1.0)
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //a flexible space between the two buttons
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action:
                                            #selector(FirstNameInputCell.doneBtnClicked(_:)))
        doneButton.tintColor = UIColor(hex: 0x030303, alpha: 1.0)
        pickerAccessory?.items = [cancelButton, flexSpace, doneButton]
        titleTextField.inputAccessoryView = pickerAccessory
        let downArrowImageView = UIImageView(image: UIImage(named: "arrow-down-mono"))
        
        downArrowImageView.contentMode = UIView.ContentMode.center
        titleTextField.rightView = downArrowImageView
        titleTextField.rightView?.tintColor = UIColor.blueGray
        titleTextField.rightViewMode = .always
        
        firstNameTextField.addTarget(self, action: #selector(firstNameTextFieldDidChange(textField:)), for: .editingChanged)
        firstNameTextField.addDoneToolbar()
    }
    
    //MARK: - TextField Delegate
    @objc
    private func firstNameTextFieldDidChange(textField: UITextField){
        delegate?.firstNameChanged(name: textField.text ?? "", indexPath: cellIndexPath)
    }
    
    //MARK: - IBActions
    @objc
    public func cancelBtnClicked(_ button: UIBarButtonItem?) {
        titleTextField?.resignFirstResponder()
    }
    
    @objc
    public func doneBtnClicked(_ button: UIBarButtonItem?) {
        titleTextField?.resignFirstResponder()
        titleTextField.text = picker?.selectedValue
        
        let rawValue = picker?.selectedValue ?? TitleType.mr.rawValue
        let titleType: TitleType = TitleType(rawValue: rawValue) ?? .mr
        delegate?.titleChanged(titleType: titleType, indexPath: cellIndexPath)
    }
}
