//
//  BaggageViewModel.swift
//  STFlightKit
//
//  Created by ST-iOS on 11/22/22.
//



public struct SelectedBaggageInfo {
    var optionIndex: Int
    var option: BaggageWholeFlightOptions
    var travellerType: BaggageTravellerType
}

public struct BaggageCollapseStatus {
    var routeCollapsed: Bool
    var travellerCollapsed: [Bool]
}

public enum BaggageType {
    case wholeFlight
    case onlyrouteWise
    case onlyPassengerWise
    case routeAndPassengerWise
    case none
}

public class BaggageViewModel {
    private let baggageResponse: BaggageResponse?
    private let adult: Int
    private let child: Int
    private let infant: Int
    
    private var isCollapsed = [BaggageCollapseStatus]()
    private var baggages = [[SelectedBaggageInfo]]()
    private var travelerType = [BaggageTravellerType]()
    private var baggageType: BaggageType = .none
    
    public init(baggageResponse: BaggageResponse?, adult: Int, child: Int, infant: Int) {
        self.baggageResponse = baggageResponse
        self.adult = adult
        self.child = child
        self.infant = infant
        generateTravelerArray()
        setupCollapseStatus()
        setBaggagDefaulteValues()
        setBaggageType()
    }
    
    //MARK:- Initial Setup
    
    private func generateTravelerArray() {
        if adult > 0 {
            for _ in 0..<adult{
                travelerType.append(.adt)
            }
        }
        if child > 0 {
            for _ in 0..<child {
                travelerType.append(.chd)
            }
        }
        
        if infant > 0 {
            for _ in 0..<infant {
                travelerType.append(.inf)
            }
        }
    }
    
    public func travellerCount() -> Int {
        return adult + child + infant
    }
    
    public func totalRoutesCount() -> Int {
        guard let baggageResponse = baggageResponse else { return 0 }
        guard let routes = baggageResponse.routeOptions else { return 0 }
        return routes.count
    }
    
    public func isBaggageOptional() -> Bool {
        guard let baggageResponse = baggageResponse else { return true }
        return baggageResponse.isLuggageOptional ?? false
    }
    
    public func isPerPerson() -> Bool {
        guard let baggageResponse = baggageResponse else { return false }
        return baggageResponse.isPerPerson ?? false
    }
    
    public func isBaggageForWholeFlight() -> Bool {
        guard let baggageResponse = baggageResponse else { return true }
        return baggageResponse.wholeFlight ?? false
    }
    
    private func setupCollapseStatus() {
        if self.isBaggageForWholeFlight() {
            if self.isPerPerson() {
                var status = [Bool]()
                for _ in 0..<self.travellerCount() {
                    status.append(true)
                }
                isCollapsed.append(BaggageCollapseStatus(routeCollapsed: false, travellerCollapsed: status))
                return
            }
            isCollapsed.append(BaggageCollapseStatus(routeCollapsed: false, travellerCollapsed: [true]))
            return
        }
        
        for _ in 0..<self.totalRoutesCount() {
            if self.isPerPerson() {
                var status = [Bool]()
                for _ in 0..<self.travellerCount() {
                    status.append(true)
                }
                isCollapsed.append(BaggageCollapseStatus(routeCollapsed: false, travellerCollapsed: status))
            } else {
                isCollapsed.append(BaggageCollapseStatus(routeCollapsed: false, travellerCollapsed: [true]))
            }
        }
    }
    
    private func setBaggagDefaulteValues() {
        let totalRoute = baggageResponse?.routeOptions?.count ?? 0
        if totalRoute > 0 && !isBaggageForWholeFlight(){
            for rIndex in 0..<totalRoute{
                for tIndex in 0..<travelerType.count{
                    
                    let codeAndAmountValues = getDefaultBaggageCodeAndAmount(using: travelerType[tIndex], and: tIndex)
                    let options = BaggageWholeFlightOptions(
                        travellerType: .adt,
                        code: codeAndAmountValues.code,
                        quantity: 0,
                        details: "",
                        amount: 0.0,
                        currency: .bdt
                    )
                    
                    let bInfo = SelectedBaggageInfo(optionIndex: (codeAndAmountValues.amount == -1 ? -1 : 0), option: options, travellerType: BaggageTravellerType(rawValue: travelerType[tIndex].rawValue) ?? .adt)
                    
                    if !baggages.indices.contains(rIndex) {
                        baggages.append([bInfo])
                    } else {
                        baggages[rIndex].append(bInfo)
                    }
                }
            }
        } else {
            for tIndex in 0..<travelerType.count {
                let codeAndAmountValues = getDefaultBaggageCodeAndAmount(using: travelerType[tIndex])
                let options = BaggageWholeFlightOptions(travellerType: .adt, code: codeAndAmountValues.0, quantity: 0, details: "", amount: 0.0, currency: .bdt)
                
                let bInfo = SelectedBaggageInfo(optionIndex: (codeAndAmountValues.amount == -1 ? -1 : 0), option: options, travellerType: BaggageTravellerType(rawValue: travelerType[tIndex].rawValue) ?? .adt)
                
                if !baggages.indices.contains(0) {
                    baggages.append([bInfo])
                } else {
                    baggages[0].append(bInfo)
                }
            }
        }
    }
    
    public func getDefaultBaggageCodeAndAmount(using travelerType: BaggageTravellerType, and index: Int = 0) -> (code: String, amount: Double) {
        let defaultReturnValue = ("", -1.0)
        if isBaggageForWholeFlight() {
            guard let totalOptions = baggageResponse?.wholeFlightOptions?.count else {return defaultReturnValue}
            for item in 0..<totalOptions {
                if baggageResponse?.wholeFlightOptions?[item].travellerType == travelerType && baggageResponse?.wholeFlightOptions?[item].amount == 0 {
                    return (baggageResponse?.wholeFlightOptions?[item].code ?? "", baggageResponse?.wholeFlightOptions?[item].amount ?? -1.0)
                }
            }
        } else {
            guard let routeOptions = baggageResponse?.routeOptions else { return defaultReturnValue }
            guard index >= 0 && index < routeOptions.count else { return defaultReturnValue }
            guard let totalRouteOptions = routeOptions[index].options?.count else { return defaultReturnValue }
            
            for item in 0..<totalRouteOptions {
                if baggageResponse?.routeOptions?[index].options?[item].travellerType == travelerType && baggageResponse?.routeOptions?[index].options?[item].amount == 0 {
                    return (baggageResponse?.routeOptions?[index].options?[item].code ?? "", baggageResponse?.routeOptions?[index].options?[item].amount ?? -1.0)
                }
            }
        }
        return defaultReturnValue
    }
    
    
    
    private func setBaggageType(){
        if isBaggageForWholeFlight() && !isPerPerson() {
            baggageType = BaggageType.wholeFlight
        } else if !isBaggageForWholeFlight() && !isPerPerson() {
            baggageType = BaggageType.onlyrouteWise
        } else if isBaggageForWholeFlight() && isPerPerson() {
            baggageType = BaggageType.onlyPassengerWise
        } else if !isBaggageForWholeFlight() && isPerPerson() {
            baggageType = BaggageType.routeAndPassengerWise
        }
    }
    
    //MARK:- Utils
    
    public func haveBaggageResponseData() -> Bool {
        if let _ = self.baggageResponse {
            return true
        } else {
            return false
        }
    }
    
    public func getBaggageType() -> BaggageType {
        return baggageType
    }
    
    public func getBaggageSelectionStatus() -> Bool {
        if isBaggageOptional() { return true }
        return isBaggageOptionSelected()
    }
    
    private func isBaggageOptionSelected() -> Bool {
        for rIndex in 0..<baggages.count {
            for tIndex in 0..<baggages[rIndex].count {
                if ((baggages[rIndex][tIndex].option.code == "") && (baggages[rIndex][tIndex].travellerType != BaggageTravellerType.inf))
                {
                    return false
                }
            }
        }
        return true
    }
    
    public func prepareBaggageData() {
        let baggageType = getBaggageType()
        switch baggageType {
        case .wholeFlight:
            setSelectedBaggageCodeForWholeFlight(with: selectedBaggageCodeForWholeFlight())
            return
        case .onlyrouteWise:
            setSelectedBaggageCodeForOnlyRouteWiseData(with: selectedBaggageCodeForOnlyRouteWiseFlight())
            return
        case .onlyPassengerWise:
            return
        case .routeAndPassengerWise:
            return
        case .none:
            return
        }
    }
    
    private func setTravelarsIndexAndType(){
        for rIndex in 0..<baggages.count {
            for tIndex in 0..<baggages[rIndex].count {
                if baggages[rIndex][tIndex].optionIndex == -1 {
                    baggages[rIndex][tIndex].optionIndex = tIndex
                    baggages[rIndex][tIndex].travellerType = travelerType[tIndex]
                    baggages[rIndex][tIndex].option.travellerType = travelerType[tIndex]
                }
            }
        }
    }
    
    private func selectedBaggageCodeForWholeFlight() -> String {
        for rIndex in 0..<baggages.count {
            if baggages[rIndex].first?.option.code != "" {
                return baggages[rIndex].first?.option.code ?? ""
            }
        }
        return ""
    }
    
    private func setSelectedBaggageCodeForWholeFlight(with baggageCode: String) {
        for rIndex in 0..<baggages.count {
            for tIndex in 0..<baggages[rIndex].count {
                baggages[rIndex][tIndex].option.code = baggageCode
            }
        }
    }
    
    private func selectedBaggageCodeForOnlyRouteWiseFlight() -> [String] {
        var selectedBaggageCodes = ["", ""]
        for rIndex in 0..<baggages.count {
            if baggages[rIndex].first?.option.code != "" {
                selectedBaggageCodes[rIndex] = baggages[rIndex].first?.option.code ?? ""
            }
        }
        return selectedBaggageCodes
    }
    
    private func setSelectedBaggageCodeForOnlyRouteWiseData(with baggageCodes: [String]) {
        for rIndex in 0..<baggages.count {
            for tIndex in 0..<baggages[rIndex].count {
                baggages[rIndex][tIndex].option.code = baggageCodes[rIndex]
            }
        }
    }
    
    public func getTravelerWiseSelectedBaggageCodes(using index: Int) -> [String] {
        guard index >= 0 && index < baggages.count else { return [] }
        
        let baggageType = getBaggageType()
        var baggageCode: [String] = [String]()
        for rIndex in 0..<baggages.count {
            for tIndex in 0..<baggages[rIndex].count {
                if tIndex == index {
                    switch baggageType {
                    case .wholeFlight, .onlyrouteWise:
                        index == 0 ? (baggageCode.append(baggages[rIndex][tIndex].option.code ?? "")) : (baggageCode.append(""))
                    case .onlyPassengerWise, .routeAndPassengerWise:
                        baggageCode.append(baggages[rIndex][tIndex].option.code ?? "")
                    case .none:
                        STLog.info("")
                    }
                }
            }
        }
        return baggageCode
    }

    public func setIsCollapsed(routeIndex: Int, travellerIndex: Int?) {
        guard 0 <= routeIndex && routeIndex < isCollapsed.count else { return }
        
        if let tIndex = travellerIndex {
            guard 0 <= tIndex && tIndex < isCollapsed[routeIndex].travellerCollapsed.count else { return }
            isCollapsed[routeIndex].travellerCollapsed[tIndex].toggle()
        } else {
            isCollapsed[routeIndex].routeCollapsed.toggle()
            if isBaggageForWholeFlight() {
                for index in 0..<isCollapsed[routeIndex].travellerCollapsed.count {
                    isCollapsed[routeIndex].travellerCollapsed[index].toggle()
                }
            } else {
                if isPerPerson() {
                    for index in 0..<isCollapsed[routeIndex].travellerCollapsed.count {
                        isCollapsed[routeIndex].travellerCollapsed[index] = false
                    }
                } else {
                    for index in 0..<isCollapsed[routeIndex].travellerCollapsed.count {
                        isCollapsed[routeIndex].travellerCollapsed[index].toggle()
                    }
                }
            }
            
        }
    }
    
    public func setBagggeSelected(routeIndex: Int, travellerIndex: Int, travellerType: BaggageTravellerType, optionIndex: Int, option: BaggageWholeFlightOptions) {
        
        let baggageInfo = SelectedBaggageInfo(
            optionIndex: optionIndex,
            option: option,
            travellerType: travellerType
        )
        
        let totalRoute = baggageResponse?.routeOptions?.count ?? 0
        let totalTraveler = travelerType.count
        
        if totalRoute > 0 && routeIndex < totalRoute && !isBaggageForWholeFlight(){
            if travellerIndex < totalTraveler {
                baggages[routeIndex][travellerIndex] = baggageInfo
            }
        } else {
            baggages[routeIndex][travellerIndex] = baggageInfo
        }
    }
    
    public func getCollapseStatus(by route: Int) ->Bool {
        guard 0 <= route && route < isCollapsed.count else { return false }
        
        return isCollapsed[route].routeCollapsed
    }
    
    public func getCollapseStatus(by route: Int, and travellerIndex: Int) ->Bool {
        guard 0 <= route && route < isCollapsed.count else { return false }
        
        guard 0 <= travellerIndex && travellerIndex < isCollapsed[route].travellerCollapsed.count else { return false }
        
        return isCollapsed[route].travellerCollapsed[travellerIndex]
    }
    
    
    public func getOptionsPerRoute(for travellerType: BaggageTravellerType, routeIndex: Int) -> [BaggageWholeFlightOptions] {
        guard let baggageResponse = baggageResponse else { return [] }
        let routeOptions = baggageResponse.routeOptions ?? []
        let wholeFlighOptions = baggageResponse.wholeFlightOptions ?? []
        
        if isBaggageForWholeFlight() {
            return wholeFlighOptions.filter({ (option) -> Bool in
                option.travellerType == travellerType
            })
        }
        
        return routeOptions[routeIndex].options?.filter({ (option) -> Bool in
            option.travellerType == travellerType
        }) ?? []
    }
    
    public func getSelectedBaggageIndex(routeIndex: Int, travellerIndex: Int, optionIndex: Int) -> Bool {
        guard 0 <= routeIndex && routeIndex < baggages.count else { return false }
        guard 0 <= travellerIndex && travellerIndex < baggages[routeIndex].count else { return false }
        
        return baggages[routeIndex][travellerIndex].optionIndex == optionIndex
    }
    
    public func getTotalPrice() -> Double {
        var totalPrice: Double = 0.0
        for routeIndex in 0..<baggages.count {
            let baggagePerRoute = baggages[routeIndex]
            for travellerIndex in 0..<baggagePerRoute.count {
                let baggage = baggagePerRoute[travellerIndex]
                totalPrice += baggage.option.amount ?? 0
            }
        }
        return totalPrice
    }
    
    public func getbaggegesCode(using travelerIndex: Int) -> [String]{
        var baggageCodes = [String]()
        let totalRoute = baggageResponse?.routeOptions?.count ?? 0
        
        if totalRoute > 0 && !isBaggageForWholeFlight(){
            for routeIndex in 0..<totalRoute{
                baggageCodes.append(baggages[routeIndex][travelerIndex].option.code ?? "")
            }
        } else {
            baggageCodes.append(baggages[0][travelerIndex].option.code ?? "")
        }
        return baggageCodes
    }
    
    public func getTitle(for routeIndex: Int) -> String {
        guard let baggageResponse = baggageResponse else { return "" }
        if baggageResponse.wholeFlight ?? false { return "" }
        
        return (baggageResponse.routeOptions?[routeIndex].origin ?? "") + "-" + (baggageResponse.routeOptions?[routeIndex].destination ?? "")
    }
    
    public func getTravelerType(using travelerIndex: Int) -> BaggageTravellerType {
        return travelerType[travelerIndex]
    }
}
