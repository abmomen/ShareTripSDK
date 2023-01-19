//
//  InputTextFieldCell.swift
//  SmartyInput
//
//  Created by Sharetrip-iOS on 19/09/2019.
//  Copyright © 2019 TBBD. All rights reserved.
//

import UIKit

//MARK: - InputTextValidator
public protocol InputTextValidator: AnyObject {
    func validate(text: String?) -> Result<Void, AppError>
}

public class InputTextFieldCell: UITableViewCell {
    
    public var didChangeText: (String?) -> Void = { _ in }
    
    private var title: String = "Title Lablel"
    private var state: ValidationState = .normal {
        didSet  {
            onStateChanged()
        }
    }
    
    private weak var validator: InputTextValidator?
    
    // MARK: - SubViews
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .lightGray
        label.text = "Title Label"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Placeholder"
        textField.autocorrectionType = .no
        textField.tintColor = .black
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .greyishBrown
        imageView.image = UIImage(named: "img-sq-circle-mono")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        return imageView
    }()
    
    private lazy var dividerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 2).isActive = true
        view.backgroundColor = .lightGray
        return view
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    // MARK: - Public Functions
    func validateOnInputEnd(with validator: InputTextValidator) {
        self.validator = validator
    }
    
    // MARK: - Utils
    private func setupContraints() {
        selectionStyle = .none
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: dividerView.trailingAnchor),
            
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            textField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            textField.leadingAnchor.constraint(equalTo: dividerView.leadingAnchor, constant: 16),
            textField.bottomAnchor.constraint(equalTo: dividerView.topAnchor, constant: -16),
            textField.trailingAnchor.constraint(equalTo: dividerView.trailingAnchor),
            
            dividerView.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 12),
            dividerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            dividerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            icon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            icon.centerYAnchor.constraint(equalTo: textField.centerYAnchor)
        ])
    }
    
    private func setupUI() {
        textField.delegate = self
        textField.addTarget(self, action: #selector(onTextChanged(_:)), for: .editingChanged)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(textField)
        contentView.addSubview(icon)
        contentView.addSubview(dividerView)
        
        setupContraints()
    }
    
    private func onStateChanged() {
        titleLabel.textColor = state.color
        dividerView.backgroundColor = state.color
        
        switch state {
        case .warning(let message):
            titleLabel.text = message
        default:
            titleLabel.text = title
        }
    }
    
    @objc
    private func onTextChanged(_ textField: UITextField) {
        didChangeText(textField.text)
    }
    
    deinit {
        STLog.info("\(String(describing: self)) deinit")
    }
}

//MARK: - ConfigurableTableViewCellDataContainer
extension InputTextFieldCell: ConfigurableTableViewCellDataContainer {
    public typealias AccecptableViewModelType = InputTextFieldCellData
}

//MARK: - ConfigurableTableViewCell
extension InputTextFieldCell: ConfigurableTableViewCell {
    public func configure(viewModel: ConfigurableTableViewCellData) {
        guard let viewModel = viewModel as? AccecptableViewModelType else {
            STLog.error("Can't convert ConfigurableTableViewCellData as \(String(describing: AccecptableViewModelType.self))")
            return
        }
        
        title = viewModel.title
        state = viewModel.state
        
        textField.text = viewModel.text
        textField.placeholder = viewModel.placeholder
        textField.keyboardType = viewModel.keyboardType
        if let textContentType = viewModel.textContenType {
            textField.textContentType = textContentType
        }
        
        icon.image = UIImage(named: viewModel.imageString)
    }
}

//MARK: - UITextFieldDelegate
extension InputTextFieldCell: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        state = .active
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        didChangeText(textField.text)
        
        if let validator = validator {
            let result = validator.validate(text: textField.text)
            switch result {
            case .failure(.validationError(let message)):
                state = .warning(message)
            default:
                state = .normal
            }
        } else {
            self.state = .normal
        }
    }
}
