//
//  LeftRightInfoCell.swift
//  STCoreKit
//
//  Created by ST-iOS on 12/4/22.
//

import UIKit

public class LeftRightInfoCell: UITableViewCell {
    
    public let leftLabel = UILabel()
    let rightLabel = UILabel()
    
    public weak var delegate: SliderCellDelegate?
    
    //Private Properties
    private var cellType: SliderCellType!
    
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
        
        leftLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        leftLabel.textColor = UIColor.black
        leftLabel.textAlignment = .left
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(leftLabel)
        
        rightLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .semibold)
        rightLabel.textColor = UIColor.black
        rightLabel.textAlignment = .right
        rightLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(rightLabel)
        
        NSLayoutConstraint.activate([
            leftLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
            leftLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            rightLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.0),
            rightLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    public func configure(leftValue: String, rightValue: String){
        leftLabel.text = leftValue
        rightLabel.text = rightValue
    }
}

