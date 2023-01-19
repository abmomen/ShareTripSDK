//
//  SingleLineSelectCell.swift
//  ShareTrip
//
//  Created by Mac on 2/2/20.
//  Copyright © 2020 TBBD IOS. All rights reserved.
//

import UIKit

public struct SingleLineSelectCellData {
    public let title: String
    public var selected: Bool
    
    public init(title: String, selected: Bool) {
        self.title = title
        self.selected = selected
    }
}

public class SingleLineSelectCell: UITableViewCell {
    
    private lazy var cellContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 4.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        label.minimumScaleFactor = 0.6
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var checkmarkImageView: UIImageView = {
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
    
    public func configure(cellData: SingleLineSelectCellData){
        titleLabel.text = cellData.title
        titleLabel.textColor = cellData.selected ? UIColor.appPrimary : .black
        checkmarkImageView.isHidden = !cellData.selected
    }
    
    private func setupView() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(cellContainerView)
        cellContainerView.addSubview(titleLabel)
        cellContainerView.addSubview(checkmarkImageView)
        
        NSLayoutConstraint.activate([
            cellContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0),
            cellContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.0),
            cellContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 1.0),
            cellContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1.0),
            
            titleLabel.leadingAnchor.constraint(equalTo: cellContainerView.leadingAnchor, constant: 12.0),
            titleLabel.centerYAnchor.constraint(equalTo: cellContainerView.centerYAnchor),
            
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 24.0),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 24.0),
            checkmarkImageView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 12.0),
            checkmarkImageView.trailingAnchor.constraint(equalTo: cellContainerView.trailingAnchor, constant: -16.0),
            checkmarkImageView.centerYAnchor.constraint(equalTo: cellContainerView.centerYAnchor)
        ])
    }
}

