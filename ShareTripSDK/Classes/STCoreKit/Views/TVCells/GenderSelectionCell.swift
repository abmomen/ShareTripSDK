//
//  GenderSelectionCell.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 23/09/2019.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

public class GenderSelectionCell: UITableViewCell {
    public var didSelectGender: (GenderType) -> Void = { _ in }
    
    // MARK: - Private Properties
    private var title: String = "Title Lablel"
    private var state: ValidationState = .normal {
        didSet  {
            onStateChanged()
        }
    }
    private var selectedGenderType: GenderType = .male {
        didSet {
            didSelectGender(selectedGenderType)
            onGenderSelectionChanged()
        }
    }
    
    // MARK: - Subviews
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .lightGray
        label.text = "Title Label"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var maleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 1
        button.tintColor = .greyishBrown
        button.layer.borderColor = UIColor.templateGray.cgColor
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Male", for: .normal)
        button.setImage(UIImage(named: "male-mono"), for: .normal)
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return button
    }()
    
    private lazy var femaleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 1
        button.tintColor = .greyishBrown
        button.layer.borderColor = UIColor.templateGray.cgColor
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Female", for: .normal)
        button.setImage(UIImage(named: "female-mono"), for: .normal)
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return button
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
    
    // MARK: - Private functions
    private func onGenderSelectionChanged() {
        state = .normal
        
        switch selectedGenderType {
        case .male:
            maleButton.tintColor = .appPrimary
            maleButton.layer.borderColor = UIColor.appPrimary.cgColor
            femaleButton.tintColor = .templateGray
            femaleButton.layer.borderColor = UIColor.templateGray.cgColor
        case .female:
            femaleButton.tintColor = .appPrimary
            femaleButton.layer.borderColor = UIColor.appPrimary.cgColor
            maleButton.tintColor = .templateGray
            maleButton.layer.borderColor = UIColor.templateGray.cgColor
        default:
            break
        }
    }
    
    private func onStateChanged() {
        titleLabel.textColor = state.color
        
        switch state {
        case .warning(let message):
            titleLabel.text = message
        default:
            titleLabel.text = title
        }
    }
    
    @objc
    private func onMaleButtonTapped(_ sender: UIButton) {
        selectedGenderType = .male
    }
    
    @objc
    private func onFemaleButtonTapped(_ sender: UIButton) {
        selectedGenderType = .female
    }
    
    private func setupConstraints() {
        selectionStyle = .none
        
        contentView.addSubview(titleLabel)
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.addArrangedSubview(maleButton)
        stackView.addArrangedSubview(femaleButton)
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 60),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func setupUI() {
        setupConstraints()
        
        maleButton.addTarget(self, action: #selector(onMaleButtonTapped(_:)), for: .touchUpInside)
        femaleButton.addTarget(self, action: #selector(onFemaleButtonTapped(_:)), for: .touchUpInside)
    }
    
    
    deinit {
        STLog.info("\(String(describing: self)) deinit")
    }
}

extension GenderSelectionCell: ConfigurableTableViewCellDataContainer {
    public typealias AccecptableViewModelType = GenderSelectionCellData
}

extension GenderSelectionCell: ConfigurableTableViewCell {
    public func configure(viewModel: ConfigurableTableViewCellData) {
        guard let viewModel = viewModel as? AccecptableViewModelType else {
            STLog.error("Can't convert ConfigurableTableViewCellData as \(String(describing: AccecptableViewModelType.self))")
            return
        }
        
        title = viewModel.title
        selectedGenderType = viewModel.selectedGender
        state = viewModel.state
    }
}
