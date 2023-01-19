//
//  InfoDetailCell.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 11/26/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

public struct VerifyInfoData {
    public var title: String
    public var subTitle: String
    public var image: String

    public init(title: String, subTitle: String, image: String) {
        self.title = title.count > 0 ? title : "-"
        self.subTitle = subTitle.count > 0 ? subTitle : "-"
        self.image = image
    }
}

public class InfoDetailCell: UITableViewCell {

    @IBOutlet weak var imageViewOne: UIImageView!
    @IBOutlet weak var titleLabelOne: UILabel!
    @IBOutlet weak var subtitleLabelOne: UILabel!
    @IBOutlet weak var imageViewTwo: UIImageView!
    @IBOutlet weak var titleLabelTwo: UILabel!
    @IBOutlet weak var subtitleLabelTwo: UILabel!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    public func configure(infoDataOne: VerifyInfoData?, infoDataTwo: VerifyInfoData?){
        if let dataOne = infoDataOne {
            imageViewOne.image = UIImage(named: dataOne.image)
            titleLabelOne.text = dataOne.title
            subtitleLabelOne.text = dataOne.subTitle
        } else {
            titleLabelOne.text = "-"
            subtitleLabelOne.text = "-"
        }

        if let dataTwo = infoDataTwo {
            imageViewTwo.image = UIImage(named: dataTwo.image)
            titleLabelTwo.text = dataTwo.title
            subtitleLabelTwo.text = dataTwo.subTitle
        } else {
            titleLabelTwo.text = "-"
            subtitleLabelTwo.text = "-"
        }
    }
}
