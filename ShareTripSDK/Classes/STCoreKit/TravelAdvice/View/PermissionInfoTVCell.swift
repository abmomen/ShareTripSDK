//
//  PermissionInfoTVCell.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 10/11/2020.
//  Copyright © 2020 ShareTrip. All rights reserved.
//

import UIKit

enum travelPermission: String {
    case permitted = "green"
    case moderate = "amber"
    case prohibited = "red"
    case unknown
}
class PermissionInfoTVCell: UITableViewCell {

    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var destinationNameLabel: UILabel!
    @IBOutlet weak private var permissionInfoContainerView: UIView!
    @IBOutlet weak private var permissionImageView: UIImageView!
    @IBOutlet weak private var permissionLabel: UILabel!

    //MARK: - Cell LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    //MARK: - Utils
    private func initialSetup(){
        containerView.layer.cornerRadius = 8.0
        permissionInfoContainerView.layer.cornerRadius = 8.0
    }
    func configureCell(indexPath: IndexPath, travelAdviceVM: TravelAdviceViewModel) {
        destinationNameLabel.text = "Destination: \(travelAdviceVM.getDestinationDetailsData().countryName)"

        if travelAdviceVM.getDestinationDetailsData().riskLevel == travelPermission.permitted.rawValue {
            permissionImageView.image = UIImage(named: "done-mono")?.tint(with: UIColor(hex: 0x43a046))
            permissionLabel.textColor = UIColor(hex: 0x43a046)
            permissionInfoContainerView.backgroundColor =  UIColor(hex: 0xf4f9f4)
            permissionLabel.text = "Risk Level: \(travelPermission.permitted.rawValue.capitalizingFirstLetter())"
        } else if travelAdviceVM.getDestinationDetailsData().riskLevel == travelPermission.prohibited.rawValue {
            permissionImageView.image = UIImage(named: "done-mono")?.tint(with: UIColor.red)
            permissionLabel.textColor = UIColor.red
            permissionInfoContainerView.backgroundColor =  UIColor(hex: 0xfff3f3)
            permissionLabel.text = "Risk Level: \(travelPermission.prohibited.rawValue.capitalizingFirstLetter())"
        } else {
            permissionImageView.image = UIImage(named: "done-mono")?.tint(with: UIColor.orange)
            permissionLabel.textColor = UIColor.orange
            permissionInfoContainerView.backgroundColor =  UIColor(hex: 0xfefaf3)
            permissionLabel.text = "Risk Level: \(travelPermission.moderate.rawValue.capitalizingFirstLetter())"
        }
    }
}

