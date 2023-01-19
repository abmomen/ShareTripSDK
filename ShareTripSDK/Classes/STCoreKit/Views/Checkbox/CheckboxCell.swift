//
//  CheckboxCell.swift
//  TBBD
//
//  Created by TBBD on 4/4/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

public class CheckboxCell: UITableViewCell {
    public var didTapCheckbox: (Bool) -> Void = { _ in }
    
    //Private Properties
    private let checkbox = GDCheckbox()
    private let titleLabel = UILabel()
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    //MARK:- SetupView
    private func setupView() {
        checkbox.checkColor = .white
        checkbox.checkWidth = 3.0
        checkbox.containerColor = UIColor.blueGray
        checkbox.containerFillColor = UIColor.appPrimary
        checkbox.containerWidth = 2.0
        checkbox.isCircular = false
        checkbox.isOn = false
        checkbox.isRadiobox = false
        checkbox.isSquare = false
        checkbox.shouldAnimate = true
        checkbox.shouldFillContainer = true
        checkbox.addTarget(self, action: #selector(checkboxValueChanged), for: .valueChanged)
        
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = UIColor.black
        
        contentView.addSubview(checkbox)
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            checkbox.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            checkbox.widthAnchor.constraint(equalToConstant: 22.0),
            checkbox.heightAnchor.constraint(equalToConstant: 22.0),
            checkbox.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: checkbox.trailingAnchor, constant: 12.0),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            titleLabel.topAnchor.constraint(equalTo: checkbox.topAnchor)
        ])
    }
    
    public func configure(title: String, checkboxChecked: Bool){
        selectionStyle = .none
        checkbox.isOn = checkboxChecked
        titleLabel.text = title
    }
    
    @objc
    private func checkboxValueChanged(){
        didTapCheckbox(checkbox.isOn)
    }
    
    public func selectCheckbox() {
        checkbox.isOn.toggle()
        checkboxValueChanged()
    }
}

//MARK:- ConfigurableTableViewCellDataContainer
extension CheckboxCell: ConfigurableTableViewCellDataContainer {
    public typealias AccecptableViewModelType = CheckboxCellData
}

//MARK:- ConfigurableTableViewCell
extension CheckboxCell: ConfigurableTableViewCell {
    public func configure(viewModel: ConfigurableTableViewCellData) {
        guard let viewModel = viewModel as? AccecptableViewModelType else {
            STLog.error("Can't convert ConfigurableTableViewCellData as \(String(describing: AccecptableViewModelType.self))")
            return
        }
        
        selectionStyle = .none
        titleLabel.text = viewModel.title
        checkbox.isOn = viewModel.checkboxChecked
        
        if viewModel.enabled {
            checkbox.isEnabled = true
            titleLabel.textColor = .black
        } else {
            checkbox.isEnabled = false
            titleLabel.textColor = .templateGray
        }
    }
}
