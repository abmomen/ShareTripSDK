//
//  FlightNavTitle.swift
//  ShareTrip
//
//  Created by Mac on 10/17/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//
import UIKit


class FlightNavTitleView: UIView {
    
    let viewData: FlightNavTitleViewData

    let topLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bottomLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 10, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = UIColor.white
        //imageView.setImageTintColor(UIColor.white)
        imageView.image = UIImage(named: "arrow-down-mono")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    init(viewData: FlightNavTitleViewData) {
        self.viewData = viewData
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupView() {
        
        // Setup UI
        addSubview(topLabel)
        addSubview(bottomLabel)
        
        topLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        topLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        topLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        //topLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true

        bottomLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bottomLabel.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 0).isActive = true
        bottomLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        if viewData.showArrow {
            addSubview(arrowImageView)
            // Distance depeneded on the priceLabel and distance Label
            arrowImageView.leadingAnchor.constraint(equalTo: bottomLabel.trailingAnchor, constant: 1).isActive = true
            arrowImageView.heightAnchor.constraint(equalToConstant: 12.0).isActive = true
            arrowImageView.widthAnchor.constraint(equalToConstant: 12.0).isActive = true
            arrowImageView.centerYAnchor.constraint(equalTo: bottomLabel.centerYAnchor).isActive = true
            arrowImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        } else {
            bottomLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        }
        
        setupTopTitle()
        setupBottomTitle()
    }
    
    func setupTopTitle() {
        var navTitle: NSMutableAttributedString!

        var imageStr: String!
        switch viewData.flightRouteType {
        case .round:
            imageStr = "round-trip"
        case .oneWay:
            imageStr = "oneway-mono"
        case .multiCity:
            imageStr = "multi-city-mono"
        }
        
        let font = UIFont.systemFont(ofSize: 17, weight: .semibold)

        let image = UIImage.image(name: imageStr)!.tint(with: .white)!
        let rect = CGRect(x: 0, y: ((font.capHeight) - image.size.height).rounded() / 2, width: image.size.width, height: image.size.height)
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image
        imageAttachment.bounds = rect
        
        let attributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: UIColor.white]
        
        // wrap the attachment in its own attributed string so we can append it
        let imageString = NSAttributedString(attachment: imageAttachment)
        navTitle = NSMutableAttributedString(string: "\(viewData.firstText) ", attributes: attributes)
        navTitle.append(imageString)
        navTitle.append(NSAttributedString(string: " \(viewData.secondText)", attributes: attributes))
        
        topLabel.attributedText = navTitle
        topLabel.tintColor = .white
    }
    
    func setupBottomTitle() {

        var dateText: String = ""
        if let firstDate = viewData.firstDate {
            dateText = "\(firstDate.toString(format: DateFormatType.shortDate))"
        }
        if let secondDate = viewData.secondDate {
            dateText = dateText + " - \(secondDate.toString(format: DateFormatType.shortDate))"
        }

        bottomLabel.text = "\(dateText), \(viewData.travellerText)"
    }
}

class FlightNavTitle {
    static func flightNavLabel(flightRouteType: FlightRouteType, firstText: String, secondText: String, font: UIFont) -> UILabel {
        
        var navTitle: NSMutableAttributedString!
        // create our NSTextAttachment
        
        var imageStr: String!
        switch flightRouteType {
        case .round:
            imageStr = "round-trip"
        case .oneWay:
            imageStr = "oneway-mono"
        case .multiCity:
            imageStr = "multi-city-mono"
        }
        
        let image = UIImage.image(name: imageStr)!.tint(with: .white)!
        let rect = CGRect(x: 0, y: ((font.capHeight) - image.size.height).rounded() / 2, width: image.size.width, height: image.size.height)
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image
        imageAttachment.bounds = rect
        
        let attributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: UIColor.white]
        
        // wrap the attachment in its own attributed string so we can append it
        let imageString = NSAttributedString(attachment: imageAttachment)
        navTitle = NSMutableAttributedString(string: "\(firstText) ", attributes: attributes)
        navTitle.append(imageString)
        navTitle.append(NSAttributedString(string: " \(secondText)", attributes: attributes))
        
        //return fullString
        
        let navLabel = UILabel()
        navLabel.attributedText = navTitle
        navLabel.tintColor = .white
        return navLabel
    }
    
    static func flightNavView(flightRouteType: FlightRouteType, firstText: String, secondText: String, font: UIFont) -> UILabel {
        
        var navTitle: NSMutableAttributedString!
        // create our NSTextAttachment
        
        var imageStr: String!
        switch flightRouteType {
        case .round:
            imageStr = "round-trip"
        case .oneWay:
            imageStr = "oneway-mono"
        case .multiCity:
            imageStr = "multi-city-mono"
        }
        
        let image = UIImage(named: imageStr)!.tint(with: .white)!
        let rect = CGRect(x: 0, y: ((font.capHeight) - image.size.height).rounded() / 2, width: image.size.width, height: image.size.height)
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image
        imageAttachment.bounds = rect
        
        let attributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: UIColor.white]
        
        // wrap the attachment in its own attributed string so we can append it
        let imageString = NSAttributedString(attachment: imageAttachment)
        navTitle = NSMutableAttributedString(string: "\(firstText) ", attributes: attributes)
        navTitle.append(imageString)
        navTitle.append(NSAttributedString(string: " \(secondText)", attributes: attributes))
        
        //return fullString
        
        let navLabel = UILabel()
        navLabel.attributedText = navTitle
        navLabel.tintColor = .white
        return navLabel
    }
    
}
