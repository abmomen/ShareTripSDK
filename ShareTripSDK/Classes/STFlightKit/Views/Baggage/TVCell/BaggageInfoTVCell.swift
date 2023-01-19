//
//  BaggageInfoTVCell.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 07/03/2021.
//  Copyright © 2021 ShareTrip. All rights reserved.
//

import UIKit


enum BaggageHistoryType {
    case basic
    case extra
}

class BaggageInfoTVCell: UITableViewCell {

    @IBOutlet weak private var routeTitleLabel: UILabel!
    @IBOutlet weak private var stackView: UIStackView!
    private var route: String?
    private var basicBaggageInfo: [BaggageDetail]?
    private var extraBaggageInfo: [ExtraBaggageDetailInfo]?
    private var baggageType: BaggageHistoryType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func config(route: String, basicBaggageInfo: [BaggageDetail] = [BaggageDetail](), extraBaggageInfo: [ExtraBaggageDetailInfo] =  [ExtraBaggageDetailInfo](), baggageType: BaggageHistoryType) {
        self.route = route
        self.basicBaggageInfo = basicBaggageInfo
        self.extraBaggageInfo = extraBaggageInfo
        self.baggageType = baggageType
        setupView()
    }
    
    private func setupView() {
        routeTitleLabel.text = self.route
        for view in stackView.subviews { view.removeFromSuperview() }
        setupStackView()
        
    }
    
    fileprivate func setupStackView() {
        if self.baggageType == BaggageHistoryType.basic {
            let totalBasicBaggages = basicBaggageInfo?.count ?? 0
            for item in 0..<totalBasicBaggages {
                stackView.addArrangedSubview(
                    BaggageHistoryInfoView(
                        baggageHolderName: "\(basicBaggageInfo?[item].name ?? "") : ",
                        baggageQuantities: "\(Int(basicBaggageInfo?[item].weight ?? 0)) \(basicBaggageInfo?[item].unit ?? "")",
                        baggagePrice: "",
                        baggageType: self.baggageType ?? .basic)
                )
            }
        } else if self.baggageType == BaggageHistoryType.extra {
            let detailsBaggage = extraBaggageInfo?.count ?? 0
            if detailsBaggage == 0 {
                stackView.addArrangedSubview(
                    BaggageHistoryInfoView(
                        baggageHolderName: "No baggage added for this flight",
                        baggageQuantities: "",
                        baggagePrice: "",
                        baggageType: self.baggageType ?? .basic)
                )
            } else {
                for item in 0..<detailsBaggage {
                    stackView.addArrangedSubview(
                        BaggageHistoryInfoView(
                            baggageHolderName: "\(extraBaggageInfo?[item].name ?? "") : ",
                            baggageQuantities: extraBaggageInfo?[item].weight ?? "0Kg",
                            baggagePrice: "\(extraBaggageInfo?[item].currency ?? "BDT ") \((Int(extraBaggageInfo?[item].price ?? 0)).withCommas())",
                            baggageType: self.baggageType ?? .basic)
                    )
                }
            }
        }
    }
}

class BaggageHistoryInfoView: UIView {
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var baggageInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Total Baggage"
        label.textColor = .black
        return label
    }()
    
    private lazy var baggagePriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "3000 BDT"
        label.textAlignment = .right
        label.textColor = .black
        return label
    }()
    
    init(baggageHolderName: String, baggageQuantities: String, baggagePrice: String, baggageType: BaggageHistoryType ) {
        super.init(frame: .zero)
        
        let attributedString = NSMutableAttributedString(string: "\(baggageHolderName)")
        let boldString = NSMutableAttributedString(string: baggageQuantities, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedString.append(boldString)
        baggageInfoLabel.attributedText = attributedString
        
        baggageType == .basic ? (baggagePriceLabel.isHidden = true) : (baggagePriceLabel.isHidden = false)
        baggagePriceLabel.text = baggagePrice
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(containerView)
        containerView.addSubview(baggageInfoLabel)
        containerView.addSubview(baggagePriceLabel)
        NSLayoutConstraint.activate ([
            
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 30.0),
            
            baggageInfoLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            baggageInfoLabel.trailingAnchor.constraint(equalTo: baggagePriceLabel.leadingAnchor),
            baggageInfoLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8.0),
            baggageInfoLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 8.0),
            
            baggagePriceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            baggagePriceLabel.topAnchor.constraint(equalTo: baggageInfoLabel.topAnchor),
            baggagePriceLabel.bottomAnchor.constraint(equalTo: baggageInfoLabel.bottomAnchor)
        ])
        
        baggageInfoLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        baggageInfoLabel.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: .horizontal)
        
        baggagePriceLabel.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
        baggagePriceLabel.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .horizontal)
    }
}
