//
//  InputTextSelectionCellData.swift
//  STCoreKit
//
//  Created by ST-iOS on 12/1/22.
//

public struct InputTextSelectionCellData: ConfigurableTableViewCellData {
    public let title: String
    public let text: String
    public let placeholder: String
    public let imageString: String
    public let pickerData: [String]
    public let selectedRow: Int?
    public var state: ValidationState
    
    public init(
        title: String,
        text: String,
        placeholder: String,
        imageString: String,
        pickerData: [String],
        selectedRow: Int?,
        state: ValidationState
    ) {
        self.title = title
        self.text = text
        self.placeholder = placeholder
        self.imageString = imageString
        self.pickerData = pickerData
        self.selectedRow = selectedRow
        self.state = state
    }
    
    public init(
        title: String,
        text: String,
        placeholder: String,
        imageString: String,
        pickerData: [String],
        selectedRow: Int?
    ) {
        self.title = title
        self.text = text
        self.placeholder = placeholder
        self.imageString = imageString
        self.pickerData = pickerData
        self.selectedRow = selectedRow
        self.state = .normal
    }
}
