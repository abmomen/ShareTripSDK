//
//  InputTextCell.swift
//  TBBD
//
//  Created by TBBD on 4/8/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

public protocol InputTextCellDelegate: AnyObject {
    func inputTextDidChange(_ text: String?, indexPath: IndexPath?)
}

public class InputTextCell: UITableViewCell {
    
    public let inputTextField = UITextField()
    
    public weak var delegate: InputTextCellDelegate?
    
    private var indexPath: IndexPath?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    public func configure(text: String?, placeholder: String, indexPath: IndexPath, delegate: InputTextCellDelegate){
        self.delegate = delegate
        self.indexPath = indexPath
        
        inputTextField.text = text
        inputTextField.placeholder = placeholder
    }
    
    @objc
    private func inputTextDidChange(_ sender: Any) {
        delegate?.inputTextDidChange(inputTextField.text, indexPath: indexPath)
    }
    
    private func setupView() {
        inputTextField.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        inputTextField.textColor = UIColor.black
        inputTextField.borderStyle = .roundedRect
        inputTextField.layer.cornerRadius = 4.0
        inputTextField.layer.borderWidth = 1.0
        inputTextField.layer.borderColor = UIColor.blueGray.cgColor
        inputTextField.delegate = self
        
        //Left Padding
        inputTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8.0, height: inputTextField.frame.height))
        inputTextField.leftViewMode = .always
        
        let searchImageView = UIImageView(image: UIImage(named: "search-mono"))
        if let size = searchImageView.image?.size {
            searchImageView.frame = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        }
        
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: searchImageView.frame.width + 10.0, height: searchImageView.frame.width))
        rightView.addSubview(searchImageView)
        
        searchImageView.contentMode = UIView.ContentMode.center
        inputTextField.rightView = rightView
        inputTextField.rightView?.tintColor = UIColor.blueGray
        inputTextField.rightViewMode = .always
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        inputTextField.addTarget(self, action: #selector(inputTextDidChange(_:)), for: .editingChanged)
        
        contentView.addSubview(inputTextField)
        
        NSLayoutConstraint.activate([
            inputTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            inputTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            inputTextField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            inputTextField.heightAnchor.constraint(equalToConstant: 44.0),
        ])
    }
}

//MARK:- UITextFieldDelegate
extension InputTextCell: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
