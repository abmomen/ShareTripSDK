//
//  FlightBookingCell.swift
//  TBBD
//
//  Created by TBBD on 4/10/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit
import STCoreKit

public class FlightBookingCell: UITableViewCell {

    @IBOutlet public weak var containerView: UIView!
    @IBOutlet private weak var routeLabel: UILabel!
    @IBOutlet private weak var fareLabel: UILabel!
    @IBOutlet private weak var travelersLabel: UILabel!
    @IBOutlet private weak var dateRangeLabel: UILabel!
    @IBOutlet private weak var ticketIDLabel: UILabel!
    @IBOutlet private weak var pnrLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var tripCoinLabel: UILabel!
    @IBOutlet private weak var cellContainerHeightLC: NSLayoutConstraint!

    private var showHighlightAnimation = true

    public override func awakeFromNib() {
        super.awakeFromNib()
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        setAsSelectedOrHighlighted(selected, animated: animated)
        super.setSelected(selected, animated: animated)
    }

    public override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        setAsSelectedOrHighlighted(highlighted, animated: animated)
        super.setHighlighted(highlighted, animated: animated)
    }

    private func setAsSelectedOrHighlighted(_ selectedOrHighlighted: Bool, animated: Bool) {
        guard showHighlightAnimation else { return }

        let action: () -> Void = { [weak self] in
            self?.containerView.backgroundColor = selectedOrHighlighted ? .paleGray: .white
        }

        if animated {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: action, completion: nil)
        } else {
            action()
        }
    }
    
    //MARK:- Helpers
    public func configure(historyOption: BookingHistoryOption, history: FlightBookingHistory, showHighlightAnimation: Bool = true ,cellHeight: CGFloat? = nil) {

        //Set Date Label
        if history.searchParams.tripType == TripType.roundTrip || history.searchParams.tripType == TripType.multiCity{
            let firstDate = history.searchParamDetails.first?.departureDateTime.toDate()
            let lastDate = history.searchParamDetails.last?.departureDateTime.toDate()
            dateRangeLabel.text = "\(firstDate?.toString(format: .shortDate) ?? "") - \(lastDate?.toString(format: .shortDate) ?? "")"
        } else if history.searchParams.tripType == TripType.oneWay {
            let firstDate = history.searchParamDetails.first?.departureDateTime.toDate()
            dateRangeLabel.text = "\(firstDate?.toString(format: .shortDate) ?? "")"
        }

        containerView.layer.cornerRadius = 8.0
        self.showHighlightAnimation = showHighlightAnimation

        //Route Label
        var fullString: NSMutableAttributedString!
        // create our NSTextAttachment
        let imageStr = (history.searchParams.tripType == TripType.roundTrip) ? "round-trip" : "oneway-mono"
        let image = UIImage(named: imageStr)!
        let rect = CGRect(x: 0, y: ((routeLabel.font.capHeight) - image.size.height).rounded() / 2, width: image.size.width, height: image.size.height)
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image
        imageAttachment.bounds = rect
        
        // wrap the attachment in its own attributed string so we can append it
        let imageString = NSAttributedString(attachment: imageAttachment)
        
        // add the NSTextAttachment wrapper to our full string, then add some more text.
        
        switch history.searchParams.tripType {
        case .oneWay, .roundTrip:
            if let searchParamDetail = history.searchParamDetails.first {
                fullString = NSMutableAttributedString(string: "\(searchParamDetail.origin) ")
                fullString.append(imageString)
                fullString.append(NSAttributedString(string: " \(searchParamDetail.destination)"))
            }
        case .multiCity:
            let count = history.searchParamDetails.count
            if count > 1 {
                
                let searchParamDetail = history.searchParamDetails.first!
                fullString = NSMutableAttributedString(string: "\(searchParamDetail.origin) ")
                fullString.append(imageString)
                fullString.append(NSAttributedString(string: " \(searchParamDetail.destination)"))
                
                for index in 1..<count {
                    let searchParamDetail = history.searchParamDetails[index]
                    fullString.append(NSAttributedString(string: " "))
                    fullString.append(imageString)
                    fullString.append(NSAttributedString(string: " \(searchParamDetail.destination)"))
                }
                
            } else {
                if let searchParamDetail = history.searchParamDetails.first {
                    fullString = NSMutableAttributedString(string: "\(searchParamDetail.origin) ")
                    fullString.append(imageString)
                    fullString.append(NSAttributedString(string: " \(searchParamDetail.destination)"))
                }
            }
        }
        
        routeLabel.attributedText = fullString
        if let gatewayAmount = history.gatewayAmount {
            fareLabel.text = "\(history.gatewayCurrency ?? history.bookingCurrency) \(gatewayAmount.withCommas())"
        } else {
            fareLabel.text = "\(history.bookingCurrency) \(history.actualAmount?.withCommas() ?? "")"
        }
        
        travelersLabel.text = "\(history.travellers.count)"
        
        ticketIDLabel.text = history.bookingCode
        pnrLabel.text = history.pnrCode

        var statusText = history.bookingStatus.rawValue.uppercased()
        var textColor: UIColor!
        
        switch history.bookingStatus {
        case .pending:
            textColor = UIColor.black
        case .booked:
            switch history.paymentStatus {
            case .paid:
                textColor = UIColor.midGreen
            case .unpaid:
                statusText = PaymentStatus.unpaid.rawValue.uppercased()
                textColor = UIColor.reddish
            }
        case .issued, .completed:
            textColor = UIColor.midGreen
            
        case .declined, .canceled:
            textColor = UIColor.reddish
        }
        
        prepareStatusLabel(text: statusText, textColor: textColor)
        tripCoinLabel.text = String(history.points.earning.withCommas())

        if let cellHeight = cellHeight {
            cellContainerHeightLC.constant = cellHeight
        }
    }
    
    public func prepareStatusLabel(text: String, textColor: UIColor){
        statusLabel.text = text
        statusLabel.textColor = textColor
    }
    
    public func AttributedTextwithImgaeSuffixAndPrefix(AttributeImage1 : UIImage , AttributedText : String ,AttributeImage2 : UIImage,  LabelBound : UILabel) -> NSMutableAttributedString
    {
        let fullString = NSMutableAttributedString(string: "  ")
        let image1Attachment = NSTextAttachment()
        image1Attachment.bounds = CGRect(x: 0, y: ((LabelBound.font.capHeight) - AttributeImage1.size.height).rounded() / 2, width: AttributeImage1.size.width, height: AttributeImage1.size.height)
        image1Attachment.image = AttributeImage1
        let image1String = NSAttributedString(attachment: image1Attachment)
        let image2Attachment = NSTextAttachment()
        image2Attachment.bounds = CGRect(x: 0, y: ((LabelBound.font.capHeight) - AttributeImage2.size.height).rounded() / 2, width: AttributeImage2.size.width, height: AttributeImage2.size.height)
        image2Attachment.image = AttributeImage2
        let image2String = NSAttributedString(attachment: image2Attachment)
        fullString.append(image1String)
        fullString.append(NSAttributedString(string: AttributedText))
        fullString.append(image2String)
        return fullString
    }
    
}
