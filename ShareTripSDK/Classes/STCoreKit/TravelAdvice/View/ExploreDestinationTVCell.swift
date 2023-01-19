//
//  canIGOTVCell.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 10/11/2020.
//  Copyright © 2020 ShareTrip. All rights reserved.
//

import UIKit

public class ExploreDestinationTVCell: UITableViewCell {

    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var subtitleLabel: UILabel!
    @IBOutlet weak private var iconImageView: UIImageView!

    private var cellIndexPath: IndexPath!
    private var callbackClosure: ((IndexPath) -> Void)?

    //MARK: - Cell LifeCycle
    public override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    //MARK: - IBAction
    @IBAction func exploreButtonTap(_ sender: Any) {
        callbackClosure?(cellIndexPath)
    }
    //MARK: - Utils
    public func configureCell(title: String, _ subtitle: String, _ indexPath: IndexPath ,_ imageName: String, callbackClosure: ((_ cellIndexPath: IndexPath) -> Void)?) {
        cellIndexPath = indexPath
        self.callbackClosure = callbackClosure
        self.titleLabel.text = title
        self.subtitleLabel.text = subtitle
    }

    private func setup(){
        containerView.layer.cornerRadius = 8.0
    }
}
