//
//  BaggageHistoryDetailsViewModel.swift
//  STFlightKit
//
//  Created by ST-iOS on 11/24/22.
//

public class BaggageHistoryDetailsViewModel {
    private var baggageInfo: Baggage?
    private var luggageAmount: Double?
    private var baggageInfoTableData = [[BaggageHistoryInfoType]]()
    
    public init(baggageInfo: Baggage?, luggageAmount: Double?) {
        self.baggageInfo = baggageInfo
        self.luggageAmount = luggageAmount
        generateBaggageHistoryTableData()
    }
    
    private func generateBaggageHistoryTableData() {
        if let basicBaggage = baggageInfo?.basic {
            baggageInfoTableData.append([BaggageHistoryInfoType]())
            
            for _ in 0..<basicBaggage.count {
                baggageInfoTableData[0].append(.baggageInfo)
            }
        }
        
        if let extraBaggage = baggageInfo?.extra{
            if extraBaggage.count > 0 {
                baggageInfoTableData.append([BaggageHistoryInfoType]())
                for _ in 0..<extraBaggage.count {
                    baggageInfoTableData[1].append(.baggageInfo)
                }
                baggageInfoTableData[1].append(.singleDashLine)
                baggageInfoTableData[1].append(.totalPrice)
            }
        }
    }
    
    public func getBaggageTVSectionCount() -> Int {
        return self.baggageInfoTableData.count
    }
    
    public func getBaggageInfoTableData() -> [[BaggageHistoryInfoType]] {
        return self.baggageInfoTableData
    }
    
    public func getBasicBaggageData(with row: Int) -> (route: String, baggages: [BaggageDetail]) {
        let route = "\(self.baggageInfo?.basic?[row].origin?.code ?? "") - \(self.baggageInfo?.basic?[row].destination?.code ?? "")"
        let baggages = self.baggageInfo?.basic?[row].baggage ?? [BaggageDetail]()
        return (route: route, baggages: baggages)
    }
    
    public func getExtraBaggageData(with row: Int) -> (route: String, details: [ExtraBaggageDetailInfo]) {
        let route = self.baggageInfo?.extra?[row].route ?? ""
        let details = self.baggageInfo?.extra?[row].details ?? [ExtraBaggageDetailInfo]()
        return (route: route, details: details)
    }
}


public enum BaggageHistoryInfoType {
    case baggageInfo
    case singleDashLine
    case totalPrice
}
