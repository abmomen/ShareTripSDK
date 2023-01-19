//
//  JTCalendarHeader.swift
//  ConfigurableCalendar
//
//  Created by Sharetrip-iOS on 02/03/2020.
//  Copyright © 2020 TBBD. All rights reserved.
//

import UIKit
import JTAppleCalendar

class JTCalendarHeader: JTACMonthReusableView {
    
    @IBOutlet private weak var monthLabel: UILabel!
    
    @IBOutlet private weak var dayOneLabel: UILabel!
    @IBOutlet private weak var dayTwoLabel: UILabel!
    @IBOutlet private weak var dayThreeLabel: UILabel!
    @IBOutlet private weak var dayFourLabel: UILabel!
    @IBOutlet private weak var dayFiveLabel: UILabel!
    @IBOutlet private weak var daySixLabel: UILabel!
    @IBOutlet private weak var daySevenLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(monthStr: String) {
        monthLabel.text = monthStr
    }
    
    private let headerFormatter = DateFormatter()
    func configure(startingDateOfTheMonth: Date) {
        headerFormatter.dateFormat = "MMMM yyyy"
        monthLabel.text = headerFormatter.string(from: startingDateOfTheMonth)
    }
}
