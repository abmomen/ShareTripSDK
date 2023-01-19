//
//  FilterResetCell.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 12/2/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

public protocol FilterResetCellDelegate: AnyObject {
    func filterResetButtonTapped()
}

public class FilterResetCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var resetButton: UIButton!
    
    private weak var delegate: FilterResetCellDelegate!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func configure(subtitle: String, delegate: FilterResetCellDelegate){
        subtitleLabel.text = subtitle
        self.delegate = delegate
    }
    
    @IBAction private func resetButtonAction(_ sender: UIButton) {
        delegate.filterResetButtonTapped()
    }
}
