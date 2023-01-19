//
//  DateFormatterExtension.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/20/22.
//

import Foundation

extension DateFormatter {
    static var articleDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
}
