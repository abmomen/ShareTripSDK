//
//  SDDateSelectionCellViewModel.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/23/22.
//

import UIKit

public struct SDDateSelectionCellViewModel: ConfigurableTableViewCellData {
    public var title: String
    public var text: String
    public var placeholder: String
    public var imageString: String
    public var datePickerMode: UIDatePicker.Mode
    public var selectedDate: Date?
    public var minDate: Date?
    public var maxDate: Date?
    public var state: ValidationState
    
    public init(
        title: String,
        text: String,
        placeholder: String,
        imageString: String,
        datePickerMode: UIDatePicker.Mode = .date,
        selectedDate: Date? = nil,
        minDate: Date? = nil,
        maxDate: Date? = nil,
        state: ValidationState = .normal
    ) {
        self.title = title
        self.text = text
        self.placeholder = placeholder
        self.imageString = imageString
        self.datePickerMode = datePickerMode
        self.selectedDate = selectedDate
        self.minDate = minDate
        self.maxDate = maxDate
        self.state = state
    }
}
