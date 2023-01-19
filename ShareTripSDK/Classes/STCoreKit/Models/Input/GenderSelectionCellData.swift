//
//  GenderSelectionCellData.swift
//  STCoreKit
//
//  Created by ST-iOS on 12/1/22.
//

public struct GenderSelectionCellData: ConfigurableTableViewCellData {
    public let title: String
    public let selectedGender: GenderType
    public var state: ValidationState
    
    public init(
        title: String,
        selectedGender: GenderType,
        state: ValidationState = .normal
    ) {
        self.title = title
        self.selectedGender = selectedGender
        self.state = state
    }
}
