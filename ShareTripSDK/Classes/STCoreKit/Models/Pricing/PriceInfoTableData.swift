//
//  PriceInfoTableData.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/22/22.
//

import Foundation

public struct PriceInfoTableData {
    public var originPrice: Double = .zero
    public var totalPrice: Double = .zero
    public var discount: Double = .zero
    public var rowDatas: [PriceInfoFareCellData] = []
    public var baggagePrice: Double = .zero
    public var covid19TestPrice: Double = .zero
    public var travelInsuraceCharge: Double = .zero
    public var visaCourierCharge: Double = .zero
    public var advanceIncomeTax: Double = .zero
    public var couponsDiscount: Double = .zero
    public var stCharge: Double = .zero
    public var withDiscount = true
    
    public var baseFare: Double {
        var baseFareAmount: Double = .zero
        for rowData in rowDatas {
            baseFareAmount += rowData.fareAmount
        }
        return baseFareAmount
    }
    
    public init() {}
    
    public init(
        originPrice: Double,
        totalPrice: Double,
        rowDatas: [PriceInfoFareCellData],
        visaCourierCharge: Double,
        stCharge: Double
    ) {
        self.originPrice = originPrice
        self.totalPrice = totalPrice
        self.rowDatas = rowDatas
        self.visaCourierCharge = visaCourierCharge
        self.stCharge = stCharge
    }

    public init(totalPrice: Double, discount: Double, rowDatas: [PriceInfoFareCellData]) {
        self.totalPrice = totalPrice
        self.discount = discount
        self.rowDatas = rowDatas
    }
    
    public init(totalPrice: Double, discount: Double, rowDatas: [PriceInfoFareCellData], stCharge: Double) {
        self.totalPrice = totalPrice
        self.discount = discount
        self.rowDatas = rowDatas
        self.stCharge = stCharge
    }

    public init(originPrice: Double, totalPrice: Double, discount: Double, rowDatas: [PriceInfoFareCellData], baggagePrice: Double, covid19TestPrice: Double, travelInsuraceCharge: Double, advanceIncomeTax: Double, couponsDiscount: Double, withDiscount: Bool = true) {
        self.originPrice = originPrice
        self.totalPrice = totalPrice
        self.discount = discount
        self.rowDatas = rowDatas
        self.baggagePrice = baggagePrice
        self.covid19TestPrice = covid19TestPrice
        self.travelInsuraceCharge = travelInsuraceCharge
        self.advanceIncomeTax = advanceIncomeTax
        self.couponsDiscount = couponsDiscount
        self.withDiscount = withDiscount
    }
    
}
