//
//  CheckboxCellData.swift
//  STCoreKit
//
//  Created by ST-iOS on 12/1/22.
//

public struct CheckboxCellData: ConfigurableTableViewCellData {
    public let title: String
    public let checkboxChecked: Bool
    public let enabled: Bool
    
    public init(title: String, checkboxChecked: Bool, enabled: Bool) {
        self.title = title
        self.checkboxChecked = checkboxChecked
        self.enabled = enabled
    }
}

