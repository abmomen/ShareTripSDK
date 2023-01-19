//
//  FlightPriceBreakdownViewModel.swift
//  STFlightKit
//
//  Created by ST-iOS on 11/28/22.
//

import UIKit
import STCoreKit

public class FlightPriceBreakdownViewModel {
    
    private var priceInfoTableData: PriceInfoTableData {
        didSet {
            generatePriceTableViewRowData()
        }
    }
    
    public var selectedDiscountOption: DiscountOptionType = .earnTC
    
    private var isUSDPaymentAvailable: Bool = false
    private var conversionRate: Double = 1.0
    private var sections = [[FlightFareCellType]]()
    
    public init(priceInfoTableData: PriceInfoTableData) {
        self.priceInfoTableData = priceInfoTableData
    }
    
    // Setters
    public func updatePriceTable(with priceTableData: PriceInfoTableData) {
        priceInfoTableData = priceTableData
    }
    
    public func setConversionRate(_ rate: Double) {
        self.conversionRate = rate
    }
    
    public func setIsUsdPaymentAvilable(_ isAvailable: Bool) {
        self.isUSDPaymentAvailable = isAvailable
    }
    
    private func generatePriceTableViewRowData() {
        var flightBaseFareRowType: [FlightFareCellType] = [FlightFareCellType]()
        var flightFareRowType: [FlightFareCellType] = [FlightFareCellType]()
        
        sections.removeAll()
        
        for _ in 0..<priceInfoTableData.rowDatas.count {
            flightBaseFareRowType.append(.rowData)
        }
        
        flightFareRowType.append(.dashLine)
        flightFareRowType.append(.totalBeforeDiscount)
        
        if priceInfoTableData.baggagePrice > 0 {
            flightFareRowType.append(.baggage)
        }
        
        if priceInfoTableData.covid19TestPrice > 0 {
            flightFareRowType.append(.covid19Test)
        }
        
        if priceInfoTableData.travelInsuraceCharge > 0 {
            flightFareRowType.append(.travelInsurance)
        }
        
        if priceInfoTableData.couponsDiscount > 0 {
            flightFareRowType.append(.couponDiscount)
        }
        
        if priceInfoTableData.advanceIncomeTax > 0 {
            flightFareRowType.append(.advanceIncomeTax)
        }
        
        if convenienceFee > 0 {
            flightFareRowType.append(.stCharge)
        }
        
        flightFareRowType.append(.dashLine)
        flightFareRowType.append(.total)
        
        sections.append(contentsOf: [flightBaseFareRowType, flightFareRowType])
    }
    
    public func getRowData(index: Int) -> PriceInfoFareCellData? {
        guard index >= 0 && index < priceInfoTableData.rowDatas.count else { return nil }
        return priceInfoTableData.rowDatas[index]
    }
    
    public var flightFareSctions: [[FlightFareCellType]] {
        return sections
    }
    
    public var moneyConversionRate: Double {
        return conversionRate
    }
    
    public var totalPrice: Double {
        return (priceInfoTableData.totalPrice / conversionRate).rounded(toPlaces: 2)
    }
    
    public var totalPayable: Double {
        return (totalPrice + advanceIncomeTax + additionalCharge + convenienceFee) - totalDiscount
    }
    
    public var additionalCharge: Double {
        return baggagePrice + covidTestPrice + travelInsuranceCharge
    }
    
    public var totalDiscount: Double {
        switch selectedDiscountOption {
        case .useCoupon:
            return priceInfoTableData.withDiscount ? (discount + couponDiscount) : couponDiscount
        default:
            return discount
        }
    }
    
    public var discount: Double {
        switch selectedDiscountOption {
        case .useCoupon:
            return priceInfoTableData.withDiscount ? (priceInfoTableData.discount / conversionRate).rounded(toPlaces: 2) : 0
        default:
            return (priceInfoTableData.discount / conversionRate).rounded(toPlaces: 2)
        }
    }
    
    public var couponDiscount: Double {
        return (priceInfoTableData.couponsDiscount / conversionRate).rounded(toPlaces: 2)
    }
    
    public var baggagePrice: Double {
        return (priceInfoTableData.baggagePrice / conversionRate).rounded(toPlaces: 2)
    }
    
    public var covidTestPrice: Double {
        return (priceInfoTableData.covid19TestPrice / conversionRate).rounded(toPlaces: 2)
    }
    
    public var travelInsuranceCharge: Double {
        return (priceInfoTableData.travelInsuraceCharge / conversionRate).rounded(toPlaces: 2)
    }
    
    public var advanceIncomeTax: Double {
        return (priceInfoTableData.advanceIncomeTax / conversionRate).rounded(toPlaces: 2)
    }
    
    public var convenienceFee: Double {
        let totalPriceAfterDiscount = (totalPrice + advanceIncomeTax + additionalCharge) - totalDiscount
        return ceil(totalPriceAfterDiscount * (priceInfoTableData.stCharge/100))
    }
    
    public var currencyImage: UIImage? {
        let currencyImage = isUSDPaymentAvailable ? "usd-mono" : "bdt-mono"
        return UIImage(named: currencyImage)
    }
    
    public var currency: Currency {
        return isUSDPaymentAvailable ? .usd : .bdt
    }
}
