//
//  RightArrowTitleCell.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 1/26/20.
//  Copyright © 2020 TBBD IOS. All rights reserved.
//

import UIKit

public class RightArrowTitleCell: UITableViewCell {
    
    @IBOutlet private weak var cellContainer: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var rightArrowImageView: UIImageView!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        cellContainer.layer.cornerRadius = 4.0
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        setAsSelectedOrHighlighted(selected, animated: animated)
        super.setSelected(selected, animated: animated)
    }
    
    public override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        setAsSelectedOrHighlighted(highlighted, animated: animated)
        super.setHighlighted(highlighted, animated: animated)
    }
    
    private func setAsSelectedOrHighlighted(_ selectedOrHighlighted: Bool, animated: Bool) {
        let action: () -> Void = { [weak self] in
            self?.cellContainer.backgroundColor = selectedOrHighlighted ? .paleGray: .white
        }
        
        if animated {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: action, completion: nil)
        } else {
            action()
        }
    }
    
    public func configure(title: String, checked: Bool) {
        titleLabel.text = title
        if checked {
            rightArrowImageView.image = UIImage(named: "done-mono")
            rightArrowImageView.tintColor = .weirdGreen
        } else {
            rightArrowImageView.image = UIImage(named: "arrow-right-mono")
            rightArrowImageView.tintColor = .appPrimary
        }
    }
}
