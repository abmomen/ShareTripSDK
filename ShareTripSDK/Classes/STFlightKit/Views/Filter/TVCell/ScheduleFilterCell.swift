//
//  ScheduleFilterCell.swift
//  ShareTrip
//
//  Created by Mac on 12/5/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit
import STCoreKit

class ScheduleFilterCell: UITableViewCell {
    
    lazy var cellContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 4.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        label.minimumScaleFactor = 0.6
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "done-mono")
        imageView.tintColor = UIColor.clearBlue
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    //Private Properties
    private var cellIndexPath: IndexPath!
    private var callbackClosure: ((IndexPath, Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(cellContainerView)
        cellContainerView.addSubview(titleImageView)
        cellContainerView.addSubview(titleLabel)
        cellContainerView.addSubview(checkmarkImageView)
        
        cellContainerView.translatesAutoresizingMaskIntoConstraints = false
        cellContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0).isActive = true
        cellContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.0).isActive = true
        cellContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 1.0).isActive = true
        cellContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1.0).isActive = true
        
        titleImageView.leadingAnchor.constraint(equalTo: cellContainerView.leadingAnchor, constant: 16.0).isActive = true
        titleImageView.widthAnchor.constraint(equalToConstant: 24.0).isActive = true
        titleImageView.heightAnchor.constraint(equalToConstant: 24.0).isActive = true
        titleImageView.centerYAnchor.constraint(equalTo: cellContainerView.centerYAnchor).isActive = true

        titleLabel.leadingAnchor.constraint(equalTo: titleImageView.trailingAnchor, constant: 12.0).isActive = true
        //titleLabel.trailingAnchor.constraint(equalTo: cellContainerView.trailingAnchor, constant: -16.0).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: cellContainerView.centerYAnchor).isActive = true
        
        checkmarkImageView.widthAnchor.constraint(equalToConstant: 24.0).isActive = true
        checkmarkImageView.heightAnchor.constraint(equalToConstant: 24.0).isActive = true
        checkmarkImageView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 12.0).isActive = true
        checkmarkImageView.trailingAnchor.constraint(equalTo: cellContainerView.trailingAnchor, constant: -16.0).isActive = true
        checkmarkImageView.centerYAnchor.constraint(equalTo: cellContainerView.centerYAnchor).isActive = true
    }
    
    func configure(cellData: ScheduleFilterCellData){
        titleLabel.text = cellData.title
        titleImageView.image = UIImage(named: cellData.titleImage)
        titleLabel.textColor = cellData.selected ? UIColor.appPrimary : .black
        titleImageView.tintColor = cellData.selected ? UIColor.appPrimary : UIColor.greyishBrown
        
        //accessoryType = cellData.selected ? .checkmark : .none
        checkmarkImageView.isHidden = !cellData.selected
    }

}
