//
//  SDdateSelectionCell.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 23/09/2019.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

protocol InputDateValidator: AnyObject {
    func validate(date: Date?) -> Result<Void, AppError>
}

public extension SDDateSelectionCell {
    class Callback {
        public var didSelectedDate: (Date) -> Void = { _ in }
    }
}

public class SDDateSelectionCell: UITableViewCell {
    private var title: String = "Title Lablel"
    
    private var state: ValidationState = .normal {
        didSet  {
            onStateChanged()
        }
    }
    
    private weak var validator: InputDateValidator?
    
    private var picker = CustomSystemDatePicker()
    private var pickerAccessory = DoneCancelToolbar()
    
    public let callback = Callback()
    
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
        
        //right down arrow
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
    
    // MARK: - Public Functions
    
    func validateOnInputEnd(with validator: InputDateValidator) {
        self.validator = validator
    }
    
    // MARK: - Private functions
    
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
        
        textField.inputView = picker
        textField.inputAccessoryView = pickerAccessory
        pickerAccessory.doneAction = doneBtnClicked
        pickerAccessory.cancelAction = cancelBtnClicked
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
    private func cancelBtnClicked() {
        textField.resignFirstResponder()
    }
    
    @objc
    private func doneBtnClicked() {
        textField.resignFirstResponder()
        
        var format = ""
        switch picker.datePickerMode {
        case .time:
            format = Constants.App.timeFormat
        case .date:
            format = DateFormatType.custom(Constants.App.dateFormat).stringFormat
        default:
            format = Constants.App.dateTimeFormat
        }
        
        textField.text = picker.date.toString(format: .custom(format))
        callback.didSelectedDate(picker.date)
    }
    
    deinit {
        STLog.info("\(String(describing: self)) deinit")
    }
}

//MARK: - Extensions
extension SDDateSelectionCell: ConfigurableTableViewCellDataContainer {
    public typealias AccecptableViewModelType = SDDateSelectionCellViewModel
}

extension SDDateSelectionCell: ConfigurableTableViewCell {
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
        
        picker.datePickerMode = viewModel.datePickerMode
        if let selectedDate = viewModel.selectedDate {
            picker.date = selectedDate
        }
        picker.minimumDate = viewModel.minDate
        picker.maximumDate = viewModel.maxDate
    }
}

extension SDDateSelectionCell: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        state = .active
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if let validator = validator {
            let result = validator.validate(date: picker.date)
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
