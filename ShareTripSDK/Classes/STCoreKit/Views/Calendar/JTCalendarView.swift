//
//  JTCalendarView.swift
//  ShareTrip
//
//  Created by Nazmul Islam on 25/3/20.
//  Copyright © 2020 TBBD IOS. All rights reserved.
//

import UIKit
import JTAppleCalendar

public struct JTCalendarDateViewData {
    let title: String
    let imageStr: String
    var selectedDate: Date?
    
    public init(title: String, imageStr: String = "calander-mono", selectedDate: Date? = nil) {
        self.title = title
        self.imageStr = imageStr
        if let date = selectedDate {
            self.selectedDate = Calendar(identifier: .gregorian).startOfDay(for: date)
        }
    }
}

public class JTCalendarView: UIView, NibBased {
    
    // MARK: - Outlets
    @IBOutlet public weak var calendar: JTACMonthView!
    
    @IBOutlet private weak var dateView: UIView!
    @IBOutlet private weak var firstDateView: UIView!
    @IBOutlet private weak var firstImageView: UIImageView!
    @IBOutlet private weak var firstTitleLabel: UILabel!
    @IBOutlet private weak var firstDateLabel: UILabel!
    
    @IBOutlet private weak var secondDateView: UIView!
    @IBOutlet private weak var secondImageView: UIImageView!
    @IBOutlet private weak var secondTitleLabel: UILabel!
    @IBOutlet private weak var secondDateLabel: UILabel!
    
    @IBOutlet private weak var applyButton: UIButton!
    
    typealias ApplyButtonTapCallback = () -> Void
    var applyButtonTapCallback: ApplyButtonTapCallback?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    //MARK:- SetupUI
    private func setupUI() {
        calendar.scrollingMode = .none
        
        let cellNib = UINib(nibName: "\(JTDateCell.self)", bundle: Bundle(for: JTDateCell.self))
        calendar.register(cellNib, forCellWithReuseIdentifier: "\(JTDateCell.self)")
        
        let headerNib = UINib(nibName: "\(JTCalendarHeader.self)", bundle: Bundle(for: JTCalendarHeader.self))
        calendar.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(JTCalendarHeader.self)")
        
        let calendarWidth = Double(UIScreen.main.bounds.size.width)
        calendar.cellSize = cellWidth(calendarWidth: calendarWidth)
        
        dateView.layer.cornerRadius = 8.0
        dateView.addZeplinShadow(color: .black, alpha: 0.16, x: 0, y: 0, blur: 10.0, spread: 0.0)
    }
    
    public func configure(firstDateData: JTCalendarDateViewData,
                   secondDateData: JTCalendarDateViewData? = nil) {
        
        firstImageView.image = UIImage(named:  firstDateData.imageStr)
        firstTitleLabel.text = firstDateData.title
        
        if let secondDateData = secondDateData {
            secondDateView.isHidden = false
            secondImageView.image = UIImage(named: secondDateData.imageStr)
            secondTitleLabel.text = secondDateData.title
        } else {
            secondDateView.isHidden = true
        }
        
        let firstDate = firstDateData.selectedDate ?? Date()
        let secondDate = secondDateData?.selectedDate ?? firstDate
        setDateText(firstDate: firstDate, secondDate: secondDate)
    }
    

    @IBAction func onApplyButtonTapped(_ sender: Any) {
        applyButtonTapCallback?()
    }
    
    public func setApplyButtonStatus(_ enabled: Bool) {
        applyButton.isEnabled = enabled
        applyButton.backgroundColor = enabled ? .clearBlue : UIColor.clearBlue.withAlphaComponent(0.7)
    }
    
    public func setDateText(firstDate: Date,  secondDate: Date? = nil) {
        let secondDate = secondDate ?? firstDate
        firstDateLabel.text = firstDate.toString(format: .shortDate).uppercased()
        secondDateLabel.text = secondDate.toString(format: .shortDate).uppercased()
    }
    
    private func cellWidth(calendarWidth: Double) -> CGFloat {
        let numberOfCellPerRow = 7.0
        let cellOffset = 5.0
        let cellWidth = floor((calendarWidth + cellOffset) / numberOfCellPerRow) - cellOffset
        return CGFloat(cellWidth)
    }
}
