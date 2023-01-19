//
//  SingleInfoCellData.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/28/22.
//

import Foundation

public struct SingleInfoCellData: ConfigurableTableViewCellData {
    public var titlte: String
    public var isValid: Bool
    
    public init(titlte: String, isValid: Bool) {
        self.titlte = titlte
        self.isValid = isValid
    }
}
