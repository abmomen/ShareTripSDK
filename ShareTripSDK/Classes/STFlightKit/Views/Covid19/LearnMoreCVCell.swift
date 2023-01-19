//
//  LearnMoreCVCell.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 14/03/2021.
//  Copyright © 2021 ShareTrip. All rights reserved.
//

import UIKit
import Kingfisher

class LearnMoreCVCell: UICollectionViewCell {

    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    
    private var covid19TestCenterDetails: Covid19TestCenterDetails?
    private var travelInsurnceDetails: TravelInsuranceDetails?
    //private var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 4.0
        imageView.layer.cornerRadius = 4.0
    }
    
    // MARK: - Init
    func configure(covid19TestCenterDetails :Covid19TestCenterDetails?) {
        self.covid19TestCenterDetails = covid19TestCenterDetails
        setupUI()
    }
    
    func configureForInsurance(detail: TravelInsuranceDetails?) {
        self.travelInsurnceDetails = detail
        setupUIForInsurance()
    }
    
    // MARK: - Utils
    func setupUI(){
        titleLabel.text = self.covid19TestCenterDetails?.name ?? ""
        let url = URL(string: covid19TestCenterDetails?.imageUrl ?? "")
        let placeholder = UIImage(named: "placeholder-mono")
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url, placeholder: placeholder)
    }
    
    func setupUIForInsurance() {
        titleLabel.text = self.travelInsurnceDetails?.name ?? ""
        let url = URL(string: travelInsurnceDetails?.imageUrl ?? "")
        let placeholder = UIImage(named: "placeholder-mono")
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url, placeholder: placeholder)
        }
  }
