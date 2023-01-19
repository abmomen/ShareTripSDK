//
//  FlightDetailTopCell.swift
//  ShareTrip
//
//  Created by Mac on 10/6/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit


class FlightDetailTopCell: UITableViewCell {

    let tripCoinView = SingleCellTripCoinView.instantiate()
    let shareView = SingleCellShareView.instantiate()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.backgroundColor = UIColor.paleGray
        contentView.addSubview(shareView)
        contentView.addSubview(tripCoinView)

        tripCoinView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive =  true
        tripCoinView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive =  true
        tripCoinView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        
        shareView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive =  true
        shareView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive =  true
        shareView.topAnchor.constraint(equalTo: tripCoinView.bottomAnchor, constant: 2).isActive =  true
        shareView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2).isActive =  true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(earnedTripCoin: Int, redeemedTripCoin: Int, shareButtonAction: ((_ sender: UIButton) -> Void)? = nil) {
        
        shareView.confugure(shareTripCoin: STAppManager.shared.shareTripCoin, shareButtonAction: shareButtonAction)
        tripCoinView.configure(earnedTripCoin: earnedTripCoin, redeemedTripCoin: redeemedTripCoin)
    }
}
