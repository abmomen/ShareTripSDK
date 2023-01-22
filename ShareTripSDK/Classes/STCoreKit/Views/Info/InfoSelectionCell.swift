//
//  InfoSelectionCell.swift
//  TBBD
//
//  Created by Mac on 5/12/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

//MARK: - InfoSelectionCellDelegate
public protocol InfoSelectionCellDelegate: AnyObject {
    func infoSelectionChanged(selectedIndex: Int, selectedValue: String, indexPath: IndexPath)
}

public class InfoSelectionCell: UITableViewCell {
    
    @IBOutlet public weak var typeImageView: UIImageView!
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var infoTextField: NoSelectTextField!
    
    private var picker: DataPickerView?
    private var pickerAccessory: UIToolbar?
    private var cellIndexPath: IndexPath!
    public weak var delegate: InfoSelectionCellDelegate?
    
    public var selectedPickerIndex = 0 {
        didSet {
            picker?.selectRow(selectedPickerIndex, inComponent: 0, animated: false)
        }
    }
    
    public var pickerData: [String] = [] {
        didSet {
            self.picker?.data = pickerData
        }
    }
    
    //MARK: - Cell Life Cycle
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Utils
    public func setupCell(){
        picker = DataPickerView()
        picker?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        infoTextField.inputView = picker
        
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
        infoTextField.inputAccessoryView = pickerAccessory
        
        let downArrowImageView = UIImageView(image: UIImage(named: "arrow-down-mono"))
        downArrowImageView.contentMode = UIView.ContentMode.center
        infoTextField.rightView = downArrowImageView
        infoTextField.rightView?.tintColor = UIColor.blueGray
        infoTextField.rightViewMode = .always
        
    }
    
    public func configure(indexPath: IndexPath){
        cellIndexPath = indexPath
    }
    
    //MARK: - IBActions
    @objc
    private func cancelBtnClicked(_ button: UIBarButtonItem?) {
        infoTextField?.resignFirstResponder()
    }
    
    @objc
    func doneBtnClicked(_ button: UIBarButtonItem?) {
        infoTextField?.resignFirstResponder()
        infoTextField.text = picker?.selectedValue
        if let selectedValue = picker?.selectedValue, let index = picker?.selectedRow {
            delegate?.infoSelectionChanged(selectedIndex: index, selectedValue: selectedValue, indexPath: cellIndexPath)
        }
    }
}
