//
//  InfoTextFieldCell.swift
//  TBBD
//
//  Created by Mac on 5/12/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

public protocol InfoTextFieldCellDelegate: AnyObject {
    func infoChanged(text: String, indexPath: IndexPath)
}

public class InfoTextFieldCell: UITableViewCell {

    @IBOutlet public weak var typeImageView: UIImageView!
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var infoTextField: UITextField!
    
    public weak var delegate: InfoTextFieldCellDelegate?
    private var cellIndexpath: IndexPath!
    
    //MARK: - Cell Life Cycle
    public override func awakeFromNib() {
        super.awakeFromNib()
        infoTextField.autocorrectionType = .no
        infoTextField.addTarget(self, action: #selector(infoTextFieldDidChange(textField:)), for: .editingChanged)
        infoTextField.addDoneToolbar()
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    //MARK: - Utils
    public func configure(cellIndexpath: IndexPath, delegate: InfoTextFieldCellDelegate?, title: String, placeholder: String, typeImage: String, keyboardType: UIKeyboardType = .default, textContentType: UITextContentType? = nil){
        self.cellIndexpath = cellIndexpath
        self.delegate = delegate
        
        self.titleLabel.text = title
        self.typeImageView.image = UIImage(named: typeImage)
        self.infoTextField.placeholder = placeholder
        
        infoTextField.keyboardType = keyboardType
        if let textContentType = textContentType {
            infoTextField.textContentType = textContentType
        }
    }

    //MARK: - TextField Delegate
    @objc private func infoTextFieldDidChange(textField: UITextField){
        delegate?.infoChanged(text: textField.text ?? "", indexPath: cellIndexpath)
    }
}
