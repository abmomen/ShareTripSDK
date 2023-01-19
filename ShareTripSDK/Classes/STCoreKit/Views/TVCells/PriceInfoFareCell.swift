//
//  PriceInfoFareCell.swift
//  STCoreKit
//
//  Created by ST-iOS on 12/4/22.
//

import UIKit

public protocol PriceInfoFareCellDelegate: AnyObject {
    func showMoreButtonTapped()
}

public class PriceInfoFareCell: UITableViewCell {
    private lazy var titleLabel = UILabel()
    private lazy var baseFareTitleLabel = UILabel()
    private lazy var taxTitleLabel = UILabel()
    private lazy var baseFareLabel = UILabel()
    private lazy var taxLabel = UILabel()

    private lazy var showMoreButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "info-mono"), for: .normal)
        button.tintColor = UIColor.skyBlue
        button.addTarget(self, action: #selector(showMoreButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public weak var delegate: SliderCellDelegate?
    
    //Private Properties
    private var cellType: SliderCellType!
    
    public weak var cellDelegate: PriceInfoFareCellDelegate?
    
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
        
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .left
        
        baseFareTitleLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        baseFareTitleLabel.textColor = UIColor.black
        baseFareTitleLabel.textAlignment = .left
        
        taxTitleLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        taxTitleLabel.textColor = UIColor.black
        taxTitleLabel.textAlignment = .left

        baseFareLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        baseFareLabel.textColor = UIColor.black
        baseFareLabel.textAlignment = .right
        
        taxLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        taxLabel.textColor = UIColor.black
        taxLabel.textAlignment = .right
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(showMoreButton)
        contentView.addSubview(baseFareTitleLabel)
        contentView.addSubview(taxTitleLabel)
        contentView.addSubview(baseFareLabel)
        contentView.addSubview(taxLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        baseFareTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        taxTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        baseFareLabel.translatesAutoresizingMaskIntoConstraints = false
        taxLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12.0),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
            titleLabel.heightAnchor.constraint(equalToConstant: 16.0),
            
            baseFareTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0),
            baseFareTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
            baseFareTitleLabel.heightAnchor.constraint(equalToConstant: 16.0),
            
            showMoreButton.leadingAnchor.constraint(equalTo: baseFareTitleLabel.trailingAnchor, constant: 8.0),
            showMoreButton.centerYAnchor.constraint(equalTo: baseFareTitleLabel.centerYAnchor),
            showMoreButton.heightAnchor.constraint(equalToConstant: 18.0),
            showMoreButton.widthAnchor.constraint(equalToConstant: 18.0),
            
            taxTitleLabel.topAnchor.constraint(equalTo: baseFareTitleLabel.bottomAnchor, constant: 4.0),
            taxTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
            taxTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4.0),
            
            baseFareLabel.centerYAnchor.constraint(equalTo: baseFareTitleLabel.centerYAnchor),
            baseFareLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.0),
            
            taxLabel.centerYAnchor.constraint(equalTo: taxTitleLabel.centerYAnchor),
            taxLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.0)
        ])
    }
    
    public func configure(cellData: PriceInfoFareCellData, conversionRate: Double = 1.0) {
        titleLabel.text = cellData.title
        baseFareTitleLabel.text = cellData.fareTitle
        baseFareLabel.text = String((cellData.fareAmount/conversionRate).rounded(toPlaces: 2).withCommas())
        
        if let taxTitle = cellData.taxTitle, let taxAmount = cellData.taxAmount {
            taxTitleLabel.isHidden = false
            taxLabel.isHidden = false
            taxTitleLabel.text = taxTitle
            taxLabel.text = String((taxAmount / conversionRate).rounded(toPlaces: 2).withCommas())
        } else {
            taxTitleLabel.isHidden = true
            taxLabel.isHidden = true
        }

        if let isShowMoreHidden = cellData.isShowMoreHidden {
            if isShowMoreHidden {
                showMoreButton.isHidden = true
            } else {
                showMoreButton.isHidden = false
                baseFareTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.0).isActive = true
            }
        } else {
            showMoreButton.isHidden = true
        }
    }

    @objc
    private func showMoreButtonTapped() {
        cellDelegate?.showMoreButtonTapped()
    }
}

