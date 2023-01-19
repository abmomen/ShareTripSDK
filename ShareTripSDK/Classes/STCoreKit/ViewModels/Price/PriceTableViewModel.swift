//
//  PriceTableViewModel.swift
//  ShareTrip
//
//  Created by ST-iOS on 3/10/22.
//  Copyright © 2022 ShareTrip. All rights reserved.
//

public class PriceTableViewModel {
    public let serviceType: ServiceType
    public let priceInfoTableData: PriceInfoTableData
    public let historyConvenienceFee: HistoryConvenienceFee?
    
    private var sections = [[FlightFareCellType]]()
    
    public init(
        priceInfoTableData: PriceInfoTableData,
        serviceType: ServiceType,
        historyConvenienceFee: HistoryConvenienceFee?
    ) {
        self.priceInfoTableData = priceInfoTableData
        self.serviceType = serviceType
        self.historyConvenienceFee = historyConvenienceFee
        
        generateRows()
    }
    
    private func generateRows() {
        sections.removeAll()
        
        var baseFareSection = [FlightFareCellType]()
        for _ in 0..<priceInfoTableData.rowDatas.count {
            baseFareSection.append(.rowData)
        }
        sections.append(baseFareSection)
        
        var additionalInfoSection = [FlightFareCellType]()
        additionalInfoSection.append(.dashLine)
        additionalInfoSection.append(.totalBeforeDiscount)
        
        if getBaggagePrice() > 0 {
            additionalInfoSection.append(.baggage)
        }
        
        if getCovid19TestPrice() > 0 {
            additionalInfoSection.append(.covid19Test)
        }
        
        if priceInfoTableData.visaCourierCharge != 0.0 {
            additionalInfoSection.append(.visaCourierFee)
        }
        
        if priceInfoTableData.couponsDiscount > 0 {
            additionalInfoSection.append(.couponDiscount)
        }
        
        if getConvenienceFee() > 0 {
            additionalInfoSection.append(.stCharge)
        }
        
        if priceInfoTableData.advanceIncomeTax != 0 {
            additionalInfoSection.append(.advanceIncomeTax)
        }
        
        additionalInfoSection.append(.dashLine)
        additionalInfoSection.append(.total)
        
        sections.append(additionalInfoSection)
    }
    
    public func getSections() -> [[FlightFareCellType]] {
        return sections
    }
    
    public func getTotalPrice() -> Double {
        switch serviceType {
        case .flight:
            return (priceInfoTableData.originPrice).rounded(toPlaces: 2)
        
        case .visa:
            return (priceInfoTableData.originPrice).rounded(toPlaces: 2)
            
        default:
            return priceInfoTableData.totalPrice.rounded(toPlaces: 2)
        }
    }
    
    public func getDiscount() -> Double {
        return priceInfoTableData.discount
    }
    
    public func getTotalPayble() -> Double {
        var totalPayble: Double = 0.0
        switch serviceType {
        case .flight:
            totalPayble = getTotalPrice() + getadvanceIncomeTax() + getAdditionalCharge() + getConvenienceFee()
            totalPayble -= (getDiscount() + priceInfoTableData.couponsDiscount)
            
        case .hotel:
            totalPayble = getTotalPrice() + getConvenienceFee()
            totalPayble -= (getDiscount() + priceInfoTableData.couponsDiscount)
        case .visa:
            totalPayble = priceInfoTableData.totalPrice
        default:
            totalPayble = priceInfoTableData.totalPrice - priceInfoTableData.discount
        }
        return totalPayble.rounded(toPlaces: 2)
    }
    
    private func getAdditionalCharge() -> Double {
        return getBaggagePrice() + getCovid19TestPrice()

    }
    
    public func getPriceRowData(_ index: Int) -> PriceInfoFareCellData? {
        guard index >= 0 && index < priceInfoTableData.rowDatas.count else { return nil }
        return priceInfoTableData.rowDatas[index]
    }
    
    public func getBaggagePrice() -> Double {
        return (priceInfoTableData.baggagePrice).rounded(toPlaces: 2)
    }
    
    public func getCovid19TestPrice() -> Double {
        return (priceInfoTableData.covid19TestPrice).rounded(toPlaces: 2)
    }
    
    public var travelInsuranceCharge: Double {
        return (priceInfoTableData.travelInsuraceCharge).rounded(toPlaces: 2)
    }
    
    public func getVisaCourierCharge() -> Double {
        return (priceInfoTableData.visaCourierCharge).rounded(toPlaces: 2)
    }
    
    public func getadvanceIncomeTax() -> Double {
        return (priceInfoTableData.advanceIncomeTax).rounded(toPlaces: 2)
    }
    
    public func getConvenienceFee() -> Double {
        return historyConvenienceFee?.convenienceFee ?? 0.0
    }
    
    public func getCouponDiscount() -> Double {
        return priceInfoTableData.couponsDiscount
    }
}
