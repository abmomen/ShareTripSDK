//
//  SingleInfoCell.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 16/10/2019.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

public class SingleInfoCell: UITableViewCell {
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        tintColor = UIColor.appPrimary
        textLabel?.textAlignment = .left
        textLabel?.textColor = UIColor(hex: 0x212121)
        contentView.backgroundColor = .white
        textLabel?.backgroundColor = .clear
        accessoryView = UIImageView(image: UIImage(named: "arrow-right-mono"))
    }
}

extension SingleInfoCell: ConfigurableTableViewCellDataContainer {
    public typealias AccecptableViewModelType = SingleInfoCellData
}

extension SingleInfoCell: ConfigurableTableViewCell {
    public func configure(viewModel: ConfigurableTableViewCellData) {
        guard let viewModel = viewModel as? AccecptableViewModelType else {
            STLog.error("Can't convert ConfigurableTableViewCellData as \(String(describing: AccecptableViewModelType.self))")
            return
        }
        textLabel?.text = viewModel.titlte
        if viewModel.isValid {
            tintColor = .weirdGreen
            accessoryView = UIImageView(image: UIImage(named: "done-mono"))
        } else {
            tintColor = .appPrimary
            accessoryView = UIImageView(image: UIImage(named: "arrow-right-mono"))
        }
    }
}
