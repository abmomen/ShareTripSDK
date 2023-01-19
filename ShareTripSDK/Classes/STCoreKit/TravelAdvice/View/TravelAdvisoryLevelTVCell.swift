//
//  TravelAdvisoryLevelTVCell.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 23/11/2020.
//  Copyright © 2020 ShareTrip. All rights reserved.
//

import UIKit

class TravelAdvisoryLevelTVCell: UITableViewCell {

    @IBOutlet weak private var containerView: UIView!
    private var callbackClosure: ((IndexPath) -> Void)?
    private var cellIndexPath: IndexPath!
    
    //MARK: - Cell life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 8.0
    }

    //MARK: - Utils
    func configure(indexPath: IndexPath, callbackClosure: ((_ cellIndexPath: IndexPath) -> Void)?){
        cellIndexPath = indexPath
        self.callbackClosure = callbackClosure
    }

    @IBAction func travelAdvisoryLevelBtntap(_ sender: Any) {
        callbackClosure?(cellIndexPath)
    }

}
