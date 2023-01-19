//
//  InputTextSelectionCell.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 23/09/2019.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

public class InputTextSelectionCell: UITableViewCell {
    
    public var didSelectText: (String?, Int) -> Void = { _, _ in }
    
    private var title: String = "Title Label"
    private var state: ValidationState = .normal {
        didSet  {
            onStateChanged()
        }
    }
    
    private var picker: DataPickerView?
    private var pickerAccessory: UIToolbar?
    
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
    
    private lazy var textField: NoSelectTextField = {
        let textField = NoSelectTextField()
        textField.placeholder = "Placeholder"
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let downArrowImageView = UIImageView(image: UIImage(named: "arrow-down-mono"))
        downArrowImageView.contentMode = UIView.ContentMode.center
        textField.rightView = downArrowImageView
        textField.rightView?.tintColor = UIColor.blueGray
        textField.rightViewMode = .always
        
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
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(textField)
        contentView.addSubview(icon)
        contentView.addSubview(dividerView)
        
        setupContraints()
        
        picker = DataPickerView()
        picker?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        textField.inputView = picker
        
        pickerAccessory = UIToolbar(frame:CGRect(x:0, y:0, width: UIScreen.main.bounds.width, height: 44))
        pickerAccessory?.autoresizingMask = .flexibleHeight
        pickerAccessory?.barStyle = .default
        pickerAccessory?.barTintColor = UIColor.paleGray
        pickerAccessory?.backgroundColor = UIColor.paleGray
        pickerAccessory?.isTranslucent = false
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBtnClicked(_:)))
        cancelButton.tintColor = UIColor(hex: 0x030303, alpha: 1.0)
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action:
                                            #selector(doneBtnClicked(_:)))
        doneButton.tintColor = UIColor(hex: 0x030303, alpha: 1.0)
        pickerAccessory?.items = [cancelButton, flexSpace, doneButton]
        textField.inputAccessoryView = pickerAccessory
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
    
    deinit {
        STLog.info("\(String(describing: self)) deinit")
    }
    
    //MARK: - IBActions
    @objc
    private func cancelBtnClicked(_ button: UIBarButtonItem?) {
        textField.resignFirstResponder()
    }
    
    @objc
    private func doneBtnClicked(_ button: UIBarButtonItem?) {
        textField.resignFirstResponder()
        textField.text = picker?.selectedValue
        
        if let selectedText = picker?.selectedValue, let selectedRow = picker?.selectedRow, selectedRow > -1 {
            didSelectText(selectedText, selectedRow)
        }
    }
    
}

//MARK: - ConfigurableTableViewCellDataContainer
extension InputTextSelectionCell: ConfigurableTableViewCellDataContainer {
    public typealias AccecptableViewModelType = InputTextSelectionCellData
}

//MARK: - ConfigurableTableViewCell
extension InputTextSelectionCell: ConfigurableTableViewCell {
    public func configure(viewModel: ConfigurableTableViewCellData) {
        
        guard let viewModel = viewModel as? AccecptableViewModelType else {
            STLog.error("Can't convert ConfigurableTableViewCellData as \(String(describing: AccecptableViewModelType.self))")
            return
        }
        
        title = viewModel.title
        state = viewModel.state
        
        textField.text = viewModel.text
        textField.placeholder = viewModel.placeholder
        
        icon.image = UIImage(named: viewModel.imageString)
        
        picker?.data = viewModel.pickerData
        if let selectedRow = viewModel.selectedRow {
            picker?.selectRow(selectedRow, inComponent: 0, animated: false)
        }
    }
}

//MARK: - UITextFieldDelegate
extension InputTextSelectionCell: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        state = .active
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.state = .normal
    }
}
