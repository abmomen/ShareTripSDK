//
//  RetryInfoCardCell.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 23/02/2020.
//  Copyright © 2020 TBBD IOS. All rights reserved.
//

import UIKit

public class RetryInfoCardCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func configure(title: String) {
        titleLabel.text = title
    }
}
