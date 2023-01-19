//
//  SingleButtonCell.swift
//  TBBD
//
//  Created by TBBD on 3/18/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

public enum BookingButtonType {
    case cancelBooking
    case retryBooking
    case resendVoucher
}

public enum SingleButtonType {
    case searchButton
    case retryButton
    case bookingButton (type: BookingButtonType)
    case addPerson
    case cancellBooking
}

public class SingleButtonCell: UITableViewCell {
    
    public let button = UIButton()
    private var leadingConstantLC: NSLayoutConstraint!
    private var trailingConstantLC: NSLayoutConstraint!
    private var heightConstantLC: NSLayoutConstraint!
    private var centerYAnchorLC: NSLayoutConstraint!
    
    private var cellIndexPath: IndexPath!
    private var callbackClosure: ((IndexPath) -> Void)?
    
    //MARK: - Cell life Cycle
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - Initializer
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        button.addTarget(self, action: #selector(singleButtonTapped(_:)), for: .touchUpInside)
        contentView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        leadingConstantLC = button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0)
        trailingConstantLC = button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0)
        heightConstantLC = button.heightAnchor.constraint(equalToConstant: 44.0)
        button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        leadingConstantLC.isActive = true
        trailingConstantLC.isActive = true
        heightConstantLC.isActive = true
    }
    
    //MARK: - Utils
    public func configure(indexPath: IndexPath, buttonTitle: String, buttonType: SingleButtonType, enabled: Bool = true, callbackClosure: ((_ cellIndexPath: IndexPath) -> Void)?){
        
        cellIndexPath = indexPath
        self.callbackClosure = callbackClosure
        
        switch buttonType {
        case .cancellBooking:
            button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        case .searchButton:
            backgroundColor = .clear
            leadingConstantLC.constant = 32.0
            trailingConstantLC.constant = -32.0
            contentView.setNeedsUpdateConstraints()
            button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            button.setTitleColor(UIColor.appPrimary, for: .normal)
            button.backgroundColor = .white
            button.layer.cornerRadius = 4.0
            button.clipsToBounds = true
            
        case .retryButton:
            backgroundColor = .white
            leadingConstantLC.constant = 16.0
            trailingConstantLC.constant = -16.0
            heightConstantLC.constant = 40.0
            contentView.setNeedsUpdateConstraints()
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            button.setTitleColor(.white, for: .normal)
            button.tintColor = .white
            button.backgroundColor = UIColor.reddish
            button.setImage(UIImage(named: "info-mono"), for: .normal)
            button.layer.cornerRadius = 4.0
            button.clipsToBounds = true
            
            button.contentHorizontalAlignment = .left
            button.imageEdgeInsets = UIEdgeInsets(top: 8.0, left: 10.0, bottom: 8.0, right: 0)
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10.0 + 8.0, bottom: 0, right: 0)
            
        case .bookingButton (let bookingButtonType):
            leadingConstantLC.constant = 0
            trailingConstantLC.constant = 0
            heightConstantLC.constant = 44.0
            contentView.setNeedsUpdateConstraints()
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
            switch bookingButtonType {
            case .cancelBooking, .retryBooking:
                button.setTitleColor(.white, for: .normal)
                button.backgroundColor = UIColor.appPrimary
            case .resendVoucher:
                button.setTitleColor(UIColor.appPrimary, for: .normal)
                button.backgroundColor = .white
            }
        case .addPerson:
            backgroundColor = UIColor.paleGray
            let padding = (UIScreen.main.bounds.size.width - 160)/2
            leadingConstantLC.constant = padding
            trailingConstantLC.constant = -1*padding
            contentView.setNeedsUpdateConstraints()
            
            button.backgroundColor = .clear
            button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            
            let image = UIImage(named: "add-person-mono")?.tint(with: UIColor.deepSkyBlue)
            button.setImage(image, for: .normal)
            button.tintColor = UIColor.deepSkyBlue
            button.setTitleColor(UIColor.deepSkyBlue, for: .normal)
        }
        
        button.setTitle(buttonTitle, for: .normal)
        button.isEnabled = enabled
        button.alpha = enabled ? 1.0 : 0.6
    }
    
    //MARK: - IBAction
    @objc
    private func singleButtonTapped(_ sender: UIButton){
        callbackClosure?(cellIndexPath)
    }
}
