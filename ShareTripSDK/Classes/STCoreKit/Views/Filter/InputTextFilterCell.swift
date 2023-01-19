//
//  InputTextFilterCell.swift
//  ShareTrip
//
//  Created by Mac on 2/3/20.
//  Copyright © 2020 TBBD IOS. All rights reserved.
//

import UIKit

public protocol InputTextFilterCellDelegate: AnyObject {
    func inputTextDidChange(_ text: String?, indexPath: IndexPath?)
}

public class InputTextFilterCell: UITableViewCell {
    
    lazy var cellContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 4.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.blueGray
        label.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        label.minimumScaleFactor = 0.6
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        textField.textColor = UIColor.black
        textField.borderStyle = .none
        textField.layer.cornerRadius = 4.0
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let horizontalLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blueGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 2.0).isActive = true
        return view
    }()
    
    weak var delegate: InputTextFilterCellDelegate?
    
    //Private Properties
    private var indexPath: IndexPath?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(cellContainerView)
        
        cellContainerView.addSubview(titleLabel)
        cellContainerView.addSubview(inputTextField)
        cellContainerView.addSubview(horizontalLineView)
        
        inputTextField.delegate = self
        inputTextField.addTarget(self, action: #selector(inputTextDidChange(_:)), for: .editingChanged)
        
        NSLayoutConstraint.activate([
            cellContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0),
            cellContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.0),
            cellContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 1.0),
            cellContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1.0),
            
            titleLabel.leadingAnchor.constraint(equalTo: cellContainerView.leadingAnchor, constant: 32.0),
            titleLabel.trailingAnchor.constraint(equalTo: cellContainerView.trailingAnchor, constant: -32.0),
            titleLabel.topAnchor.constraint(equalTo: cellContainerView.topAnchor, constant: 16.0),
            
            inputTextField.leadingAnchor.constraint(equalTo: cellContainerView.leadingAnchor, constant: 32.0),
            inputTextField.trailingAnchor.constraint(equalTo: cellContainerView.trailingAnchor, constant: -16.0),
            inputTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0),
            inputTextField.heightAnchor.constraint(equalToConstant: 44.0),
            
            horizontalLineView.leadingAnchor.constraint(equalTo: cellContainerView.leadingAnchor, constant: 16),
            horizontalLineView.trailingAnchor.constraint(equalTo: cellContainerView.trailingAnchor, constant: -16),
            horizontalLineView.bottomAnchor.constraint(equalTo: cellContainerView.bottomAnchor, constant: -8.0)
        ])
    }
    
    public func configure(title: String, text: String?, placeholder: String, indexPath: IndexPath, delegate: InputTextFilterCellDelegate){
        self.delegate = delegate
        self.indexPath = indexPath
        
        titleLabel.text = title
        inputTextField.text = text
        inputTextField.placeholder = placeholder
    }
    
    @objc
    private func inputTextDidChange(_ sender: Any) {
        delegate?.inputTextDidChange(inputTextField.text, indexPath: indexPath)
    }
}

//MARK:- UITextFieldDelegate
extension InputTextFilterCell: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
