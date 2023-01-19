//
//  CovidInfoCell.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 11/03/2021.
//  Copyright © 2021 ShareTrip. All rights reserved.
//

import UIKit

class CovidInfoCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var tickImageView: UIImageView!
    @IBOutlet weak private var textField: UITextField!
    @IBOutlet weak private var addressInputView: UIView!
    @IBOutlet weak private var addressContainerView: UIView!
    
    @IBOutlet weak private var addressViewHLC: NSLayoutConstraint!
    @IBOutlet weak private var addressLabelHLC: NSLayoutConstraint!
    @IBOutlet weak private var addressTextFieldHLC: NSLayoutConstraint!
    @IBOutlet weak private var dividerViewHLC: NSLayoutConstraint!
    
    private var indexPath: IndexPath!
    private var callbackClosure: ((IndexPath, String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        contentView.layer.cornerRadius = 4.0
        addressInputView.layer.cornerRadius = 4.0
    }
    
    //MARK:- Init
    func configure(indexPath: IndexPath, text: String, selected: Bool, isTextInputHidden: Bool, testAddress: String, callbackClosure: ((_ cellIndexPath: IndexPath,_ textString: String) -> Void)?) {
        titleLabel.text = text
        tickImageView.isHidden = !selected
        setAddressViewVisibility(with: isTextInputHidden)
        if testAddress != "" {
            textField.text = testAddress
        }
        
        textField.delegate = self
        textField.addTarget(self, action: #selector(onTextChanged(_:)), for: .editingChanged)
        
        self.indexPath = indexPath
        self.callbackClosure = callbackClosure
    }
    
    //MARK:- Utils
    func select() {
        tickImageView.isHidden = false
    }

    func deselect() {
        tickImageView.isHidden = true
    }
    
    func setAddressViewVisibility(with status: Bool) {
        if status == false {
            addressViewHLC.constant = 0.0
            addressLabelHLC.constant = 0.0
            addressTextFieldHLC.constant = 0.0
            dividerViewHLC.constant = 0.0
        } else {
            addressViewHLC.constant = 103.0
            addressLabelHLC.constant = 15.0
            addressTextFieldHLC.constant = 60.0
            dividerViewHLC.constant = 2.0
        }
        addressContainerView.isHidden = !status
    }
    
    //MARK:- IBAction
    @objc private func onTextChanged(_ textField: UITextField) {
        guard let textFieldText = textField.text else {return}
        callbackClosure?(indexPath, textFieldText)
    }
}

