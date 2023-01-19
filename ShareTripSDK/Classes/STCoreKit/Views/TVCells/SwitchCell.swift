//
//  SwitchCell.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 12/3/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

public protocol SwitchCellDelegate: AnyObject {
    func switchButtonStatusChanged(status: Bool, cellIndexPath: IndexPath)
}

public class SwitchCell: UITableViewCell {
    
    private weak var delegate: SwitchCellDelegate?
    private var cellIndexPath: IndexPath!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var optionSwitch: UISwitch!
    @IBOutlet weak var cellContainerView: UIView!
    
    //@IBOutlet weak var subTitleLabel: UILabel!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellContainerView.layer.cornerRadius = 4.0
        selectionStyle = .none
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func switchButtonAction(_ sender: UISwitch) {
        delegate?.switchButtonStatusChanged(status: sender.isOn, cellIndexPath: cellIndexPath)
    }
    
    //func configure(title: String, subTitle: String, indexPath: IndexPath, delegate: SwitchCellDelegate) {
    public func configure(title: String, checked: Bool, indexPath: IndexPath, delegate: SwitchCellDelegate) {
        
        titleLabel.text = title
        optionSwitch.setOn(checked, animated: false)
        
        //subTitleLabel.text = subTitle
        cellIndexPath = indexPath
        self.delegate = delegate
    }

}
