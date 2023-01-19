//
//  FilterCell.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 12/2/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

public class FilterCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var arrowImageView: UIImageView!
    @IBOutlet private weak var cellCointainerView: UIView!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        cellCointainerView.layer.cornerRadius = 4.0
        selectionStyle = .none
    }
    
    public override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        setAsSelectedOrHighlighted(highlighted, animated: animated)
        super.setHighlighted(highlighted, animated: animated)
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        setAsSelectedOrHighlighted(selected, animated: animated)
        super.setSelected(selected, animated: animated)
    }
    
    public func setAsSelectedOrHighlighted(_ selectedOrHighlighted: Bool, animated: Bool) {
        
        let action: () -> Void = { [weak self] in
            // Set animatable properties
            self?.cellCointainerView.backgroundColor = selectedOrHighlighted ? .paleGray: .white
        }
        
        if animated {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: action, completion: nil)
        } else {
            action()
        }
    }
    
    public func configure(title: String, subTitle: String){
        titleLabel.text = title
        subTitleLabel.text = subTitle
        
    }
}
