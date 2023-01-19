//
//  SingleLineInfoCardCell.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 01/12/2019.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

public class SingleLineInfoCardCell: UITableViewCell {
    
    @IBOutlet private weak var containedView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
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
    
    private func setAsSelectedOrHighlighted(_ selectedOrHighlighted: Bool, animated: Bool) {
        
        let action: () -> Void = { [weak self] in
            // Set animatable properties
            self?.containedView?.backgroundColor = selectedOrHighlighted ? .paleGray: .white
        }
        
        if animated {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: action, completion: nil)
        } else {
            action()
        }
    }
    
    public func configure(title: String) {
        titleLabel.text = title
    }
}
