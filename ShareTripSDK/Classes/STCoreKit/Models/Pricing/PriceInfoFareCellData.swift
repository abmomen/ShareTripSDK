//
//  PriceInfoFareCellData.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/22/22.
//

import Foundation

public struct PriceInfoFareCellData {
    public let title: String?
    public let fareTitle: String
    public let fareAmount: Double
    public let taxTitle: String?
    public let taxAmount: Double?
    public let isShowMoreHidden: Bool?

    public init(
        title: String?,
        fareTitle: String,
        fareAmount: Double,
        taxTitle: String?,
        taxAmount: Double?,
        isShowMoreHidden: Bool? = true
    ) {
        self.title = title
        self.fareTitle = fareTitle
        self.fareAmount = fareAmount
        self.taxTitle = taxTitle
        self.taxAmount = taxAmount
        self.isShowMoreHidden = isShowMoreHidden
    }
}
