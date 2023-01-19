//
//  LastNameInputCell.swift
//  TBBD
//
//  Created by Mac on 5/12/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

public protocol LastNameInputCellDelegate: AnyObject {
    func lastNameChanged(name: String, indexPath: IndexPath)
}

public class LastNameInputCell: UITableViewCell {

    public var cellIndexPath: IndexPath!
    public weak var delegate: LastNameInputCellDelegate?
    
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var lastNameTextField: UITextField!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        lastNameTextField.addTarget(self, action: #selector(lastNameTextFieldDidChange(textField:)), for: .editingChanged)
        lastNameTextField.addDoneToolbar()
    }
    
    @objc
    private func lastNameTextFieldDidChange(textField: UITextField){
        delegate?.lastNameChanged(name: textField.text ?? "", indexPath: cellIndexPath)
    }
}
