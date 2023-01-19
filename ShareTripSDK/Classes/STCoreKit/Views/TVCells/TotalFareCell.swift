//
//  TotalFareCell.swift
//  STCoreKit
//
//  Created by ST-iOS on 12/4/22.
//

import UIKit

public class TotalFareCell: UITableViewCell {
    private var cellType: SliderCellType!
    
    private lazy var totalTitleLabel:  UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Sub-Total"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.black
        label.textAlignment = .left
        return label
    }()
    
    private lazy var discountTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Discount"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.black
        label.textAlignment = .left
        return label
    }()
    
    private lazy var totalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = UIColor.black
        label.textAlignment = .right
        return label
    }()
    
    private lazy var discountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = UIColor.black
        label.textAlignment = .right
        return label
    }()
    
    weak var delegate: SliderCellDelegate?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
      
        contentView.addSubview(totalTitleLabel)
        contentView.addSubview(discountTitleLabel)
        contentView.addSubview(totalLabel)
        contentView.addSubview(discountLabel)
        
        NSLayoutConstraint.activate([
            totalTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12.0),
            totalTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
          
            discountTitleLabel.topAnchor.constraint(equalTo: totalTitleLabel.bottomAnchor, constant: 4.0),
            discountTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
            discountTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4.0),
            
            totalLabel.centerYAnchor.constraint(equalTo: totalTitleLabel.centerYAnchor),
            totalLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.0),
            
            discountLabel.centerYAnchor.constraint(equalTo: discountTitleLabel.centerYAnchor),
            discountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.0)
        ])
    }
    
    public func configure(subTotal: Double, discount: Double){
        totalLabel.text = subTotal.withCommas()
        discountLabel.text = "- " + discount.withCommas()
    }
}

