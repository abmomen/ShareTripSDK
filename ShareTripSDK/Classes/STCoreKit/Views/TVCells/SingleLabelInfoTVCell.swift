//
//  SingleLabelInfoTVCell.swift
//  ShareTrip
//
//  Created by ShareTrip iOS on 18/4/21.
//  Copyright © 2021 ShareTrip. All rights reserved.
//

import UIKit

public class SingleLabelInfoTVCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var singleInfoLabel: UILabel!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public var title: String = "" {
        didSet {
            singleInfoLabel.text = title
        }
    }
    
    public func config(labelText: NSAttributedString, backgroundColor: UIColor){
        containerView.backgroundColor = backgroundColor
        singleInfoLabel.attributedText = labelText
    }
}
