//
//  SearchCountryTVCell.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 26/07/2020.
//  Copyright © 2020 ShareTrip. All rights reserved.
//

import UIKit

public class SearchCountryTVCell: UITableViewCell {
    
    @IBOutlet weak private var countryNameLabel: UILabel!
    @IBOutlet weak private var visaInfoLabel: UILabel!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func configureCell(with countryName: String,_ visaRequirement: String, and indexPath: Int){
        self.countryNameLabel.text = countryName
        self.visaInfoLabel.text = visaRequirement
    }
    
}
