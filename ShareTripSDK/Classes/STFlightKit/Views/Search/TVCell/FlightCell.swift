//
//  FlightCell.swift
//  ShareTrip
//
//  Created by Mac on 9/25/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit


class FlightCell: UITableViewCell {
    
    @IBOutlet weak var dealsTag: UIView!
    @IBOutlet weak var dealsTagLabel: UILabel!
    @IBOutlet weak var dealsTagTopLC: NSLayoutConstraint!
    @IBOutlet weak var dealsTagHeightLC: NSLayoutConstraint!

    @IBOutlet weak var placeholderContainer: UIView!
    @IBOutlet weak var placeholderStackView: UIStackView!

    @IBOutlet weak var cellCointainerView: UIView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var discountView: UIView!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var discountPriceLabel: UILabel!
    
    //@IBOutlet weak var airlineLogoStackView: UIStackView!
    @IBOutlet weak var flightLegStackView: UIStackView!
    
    @IBOutlet weak var earnPointLabel: UILabel!
//    @IBOutlet weak var sharePointLabel: UILabel!

    @IBOutlet weak var technicalStoppageView: UIView!
    @IBOutlet weak var refundableStatusLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setupView(){
        discountLabel.isHidden = true
        placeholderContainer.layer.cornerRadius = 4.0
        cellCointainerView.layer.cornerRadius = 4.0
        cellCointainerView.clipsToBounds = true
        dealsTag.roundTopLeftAndBottomRightCorners(radius: 4.0)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        setAsSelectedOrHighlighted(highlighted, animated: animated)
        super.setHighlighted(highlighted, animated: animated)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        setAsSelectedOrHighlighted(selected, animated: animated)
        super.setSelected(selected, animated: animated)
    }
    
    func setAsSelectedOrHighlighted(_ selectedOrHighlighted: Bool, animated: Bool) {

        let action: () -> Void = { [weak self] in
            // Set animatable properties
            self?.cellCointainerView.backgroundColor = selectedOrHighlighted ? .paleGray: .white
        }
        
        if animated {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: action, completion: nil)
        } else {
            action()
        }
    }
    
    static var flightLegViewHeight: CGFloat = 56.0
    
    static func getCellHeight(hasDealTag: Bool, legCount: Int = 1, hasTechincalStoppage: Bool) -> CGFloat {
        // 8 + 14 + 40 + 10 + flight leg * legCount  + 8 + 20 + 8
        var height = 58.0 + FlightCell.flightLegViewHeight * CGFloat(legCount) +
            (hasTechincalStoppage ? 52 : 0)
        if hasDealTag {
            height += 26
        }
        return height
    }

    private func showDealTag(dealType: FlightDealType) {
        dealsTag.isHidden = false
        dealsTagLabel.text = dealType.title
        dealsTagTopLC.constant = 0

        if dealType == .preferred {
            dealsTag.backgroundColor = .blueBlue
        } else if dealType == .best {
            dealsTag.backgroundColor = .dealsRed
        }
    }

    private func hideDealTag() {
        dealsTag.isHidden = true
        dealsTagTopLC.constant = -dealsTagHeightLC.constant
    }

    func configure(with viewModel: FlightRow?, legCount: Int){
        
        if let viewModel = viewModel {
            
            //Stop Animating
            stopAnimation()
            placeholderContainer.isHidden = true
            cellCointainerView.isHidden = false
            
            discountLabel.layer.cornerRadius = discountLabel.layer.frame.size.height/2
            discountLabel.layer.masksToBounds = true
            
            if let discountPercentage = viewModel.discountPercentage,
                let discountPriceText = viewModel.discountPriceText, discountPercentage > 0 {
                totalPriceLabel.isHidden = false
                totalPriceLabel.attributedText = "\(viewModel.currency) \(viewModel.totalPriceText)".strikeThrough()
                discountPriceLabel.text = "\(viewModel.currency) \(discountPriceText)"

            } else {
                totalPriceLabel.isHidden = true
                discountLabel.text = ""
                discountPriceLabel.text = "\(viewModel.currency) \(viewModel.totalPriceText)"
            }
            
            //setup flight leg
            if flightLegStackView.subviews.count == viewModel.flightLegDatas.count {
                updateFlightLegViews(viewModel.flightLegDatas)
            } else {
                flightLegStackView.subviews.forEach { view in
                    view.removeFromSuperview()
                }
                let flightLegViews = viewsForFlightLegs(viewModel.flightLegDatas)
                flightLegViews.forEach { flightLegView in
                    flightLegStackView.addArrangedSubview(flightLegView)
                }
            }

            technicalStoppageView.isHidden = !viewModel.hasTechnicalStoppage
            
            //setup tripcoin
            earnPointLabel.text = viewModel.earnPointText
//            sharePointLabel.text = viewModel.sharePointText
            
            //selectionStyle = .default

            refundableStatusLabel.text = viewModel.isRefundable

            if let dealType = viewModel.dealType,
                dealType == .preferred || dealType == .best  {
                showDealTag(dealType: dealType)
            } else {
                hideDealTag()
            }

        } else {
        
            setupPlaceholder(legCount: legCount)
            placeholderContainer.isHidden = false
            cellCointainerView.isHidden = true
            
            startAnimation()
            //selectionStyle = .none
        }
        selectionStyle = .none
    }
    
    func viewsForFlightLegs(_ flightLegDatas: [FlightLegData]) -> [FlightLegView] {
        let flightLegViews = flightLegDatas.map({ flightLegData -> FlightLegView in
            let flightLegView = FlightLegView.instanceFromNib()
            flightLegView.translatesAutoresizingMaskIntoConstraints = false
            flightLegView.config(with: flightLegData)
            return flightLegView
        })
        return flightLegViews
    }
    
    func updateFlightLegViews(_ flightLegDatas: [FlightLegData]){
        for (index, flightLegData) in flightLegDatas.enumerated() {
            if let flightLegView = flightLegStackView.arrangedSubviews[index] as? FlightLegView {
                flightLegView.config(with: flightLegData)
            }
        }
    }
    
    //MARK:- Placeholder

    func getPlaceholderViewsForAnimate() -> [UIView] {
        let obj: [UIView] = placeholderContainer.subviewsRecursive()
        return obj.filter({ (obj) -> Bool in
            obj.tag == -1
        })
    }
    
    func setupPlaceholder(legCount: Int) {

        //setup flight leg placeholder view
        if placeholderStackView.subviews.count != legCount {
                placeholderStackView.subviews.forEach { view in
                view.removeFromSuperview()
            }
            
            for _ in 1...legCount {
                let flightLegPlaceholderView = FlightLegPlaceholderView.instanceFromNib()
                flightLegPlaceholderView.translatesAutoresizingMaskIntoConstraints = false
                placeholderStackView.addArrangedSubview(flightLegPlaceholderView)
            }
        }
        
        //Round the Views
        let sViews = placeholderContainer.subviewsRecursive().filter({ (obj) -> Bool in
            obj.tag < 0
        })
        for view in sViews {
            view.layer.cornerRadius = view.layer.frame.size.height/2
        }
    }

    func startAnimation() {
        
        let animageViews = getPlaceholderViewsForAnimate()
        for animateView in animageViews {
            animateView.clipsToBounds = true
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [UIColor.clear.cgColor, UIColor.white.withAlphaComponent(0.8).cgColor, UIColor.clear.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0.7, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.8)
            gradientLayer.frame = animateView.bounds
            animateView.layer.mask = gradientLayer
            
            let animation = CABasicAnimation(keyPath: "transform.translation.x")
            animation.duration = 1.5
            animation.fromValue = -animateView.frame.size.width
            animation.toValue = animateView.frame.size.width
            animation.repeatCount = .infinity
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            
            gradientLayer.add(animation, forKey: "")
        }
    }
    
    func stopAnimation() {
        
        let animageViews = getPlaceholderViewsForAnimate()
        for animateView in animageViews {
            animateView.layer.removeAllAnimations()
            animateView.layer.mask = nil
        }
    }
}
