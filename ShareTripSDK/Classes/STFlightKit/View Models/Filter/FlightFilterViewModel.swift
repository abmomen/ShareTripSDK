//
//  FlightFilterViewModel.swift
//  STFlightKit
//
//  Created by ST-iOS on 11/23/22.
//

import STCoreKit

public class FlightFilterViewModel {
    public let filter: FlightFilter
    public var filteredData: FlightFilterData
    public let flightClass: FlightClass
    public let flightRouteType: FlightRouteType
    public let flightCount: Int
    
    public init(
        filter: FlightFilter,
        filteredData: FlightFilterData,
        flightClass: FlightClass,
        flightRouteType: FlightRouteType,
        flightCount: Int
    ) {
        self.filter = filter
        self.filteredData = filteredData
        self.flightClass = flightClass
        self.flightRouteType = flightRouteType
        self.flightCount = flightCount
    }
    
    //MARK:- Helpers
    
    public func resetFilterData() {
        filteredData.reset()
    }
    
    //MARK:- Price Range
    public func setPriceRange(minValue: Int, maxValue: Int) {
        filteredData.price = FlightPriceRange(min: minValue, max: maxValue)
    }
    
    public var filterPriceRange: FilterPriceRange {
        return FilterPriceRange(low: filter.price.min, high: filter.price.max, currentLow: filteredData.price?.min, currentHigh: filteredData.price?.max)
    }
    
    //MARK:- Schedule
    
    public func scheduleHeaderTitle(for section: Int) -> String {
        if flightRouteType == .multiCity {
            return "Onward Depart Time"
        }
        return section == 0 ? "Onward Depart Time" : "Return Depart Time"
    }
    
    public func scheduleTitleImage(for timeSlot: TimeSlot) -> String {
        switch timeSlot.key {
        case "00 - 06":
            return "time-0-6"
        case "06 - 12":
            return "time-6-12"
        case "12 - 18":
            return "time-12-18"
        case "18 - 24":
            return "time-18-24"
        default:
            return "time-6-12"
        }
    }
    
    public func scheduleTitle(for timeSlot: TimeSlot) -> String {
        switch timeSlot.key {
        case "00 - 06":
            return "00:00 - 06:00"
        case "06 - 12":
            return "06:00 - 12:00"
        case "12 - 18":
            return "12:00 - 18:00"
        case "18 - 24":
            return "18:00 - 24:00"
        default:
            return timeSlot.key
        }
    }
    
    public func scheduleTimeSlot(for indexPath: IndexPath) -> TimeSlot {
        if indexPath.section == 1, let returnTimeSlot = filter.returnTimeSlot {
            return returnTimeSlot[indexPath.row]
        } else {
            return filter.departTimeSlot[indexPath.row]
        }
    }
    
    public func scheduleFilterCellData(for indexPath: IndexPath) -> ScheduleFilterCellData {
        let timeSlot = scheduleTimeSlot(for: indexPath)
        let title = scheduleTitle(for: timeSlot)
        let titleImage = scheduleTitleImage(for: timeSlot)
        let selected = isScheduleTimeSlotSelected(for: indexPath)
        return ScheduleFilterCellData(title: title, titleImage: titleImage, selected: selected)
    }
    
    public func departTimeSlotRowIndex() -> Int? {
        guard let departTimeSlot = filteredData.departTimeSlot else { return nil }
        for (index, timeSlot) in filter.departTimeSlot.enumerated() {
            if timeSlot.key == departTimeSlot {
                return index
            }
        }
        return nil
    }
    
    public func returnTimeSlotRowIndex() -> Int? {
        guard let returnTimeSlotKey = filteredData.returnTimeSlot else { return nil }
        let returnTimeSlots = filter.returnTimeSlot ?? filter.departTimeSlot
        for (index, timeSlot) in returnTimeSlots.enumerated() {
            if timeSlot.key == returnTimeSlotKey {
                return index
            }
        }
        return nil
    }
    
    public func isScheduleTimeSlotSelected(for indexPath: IndexPath) -> Bool {
        
        if indexPath.section == 1, let returnTimeSlot = filter.returnTimeSlot {
            let timeSlot = returnTimeSlot[indexPath.row]
            return timeSlot.key == filteredData.returnTimeSlot
        } else {
            let timeSlot = filter.departTimeSlot[indexPath.row]
            return timeSlot.key == filteredData.departTimeSlot
        }
    }
    
    public func handleScheduleOptionSelection(indexPath: IndexPath, selected: Bool) {
        
        if indexPath.section == 1, let returnTimeSlot = filter.returnTimeSlot {
            let timeSlot = returnTimeSlot[indexPath.row]
            filteredData.returnTimeSlot = selected ? timeSlot.key : nil
        } else {
            let timeSlot = filter.departTimeSlot[indexPath.row]
            filteredData.departTimeSlot =  selected ? timeSlot.key : nil
        }
    }
    
    //MARK:- Filter Option
    
    public func filterOptionTitle(for filterType: FlightFilterType, rowIndex: Int) -> String {
        
        switch filterType {
        case .stoppage:
            return filter.stoppages[rowIndex].name
        case .airline:
            return filter.airlines[rowIndex].short
        case .layover:
            return filter.layover[rowIndex].name
        case .weight:
            return filter.weight[rowIndex].note
        case .refundble:
            return getRefundPoliciesTitle()[rowIndex]
        default:
            return ""
        }
    }
    
    private func getRefundPoliciesTitle() -> [String] {
        guard let refundPolicies = filter.isRefundable else { return [] }
        
        var policyTitles = [String]()
        for index in 0..<refundPolicies.count {
            if refundPolicies[index].value == index {
                policyTitles.append(refundPolicies[index].key)
            }
        }
        return policyTitles
    }

    public func filterOptionChecked(for filterType: FlightFilterType, rowIndex: Int) -> Bool {
        
        switch filterType {
        case .stoppage:
            return isStoppageOptionChecked(for: rowIndex)
        case .airline:
            return isAirlineOptionChecked(for: rowIndex)
        case .layover:
            return isLayoverOptionChecked(for: rowIndex)
        case .weight:
            return weightCheckboxChecked(for: rowIndex)
        case .refundble:
            return filteredData.isRefundable?.contains(rowIndex) ?? false
        default:
            return false
        }
    }
    
    public func hasFilterData(for filterType: FlightFilterType) -> Bool {
        switch filterType {
        case .stoppage:
            return filteredData.stoppage != nil
        case .airline:
            return filteredData.airlines != nil
        case .layover:
            return filteredData.layover != nil
        case .weight:
            return filteredData.weight != nil
        case .refundble:
            return filteredData.isRefundable != nil
        default:
            return false
        }
    }
    
    public func handleSwitchStatusChange(for filterType: FlightFilterType, rowIndex: Int, checked: Bool) {
        
        switch filterType {
        case .stoppage:
            handleStoppageOptionChange(for: rowIndex, checked: checked)
        case .airline:
            handleAirlineOptionChange(for: rowIndex, checked: checked)
        case .layover:
            handleLayoverOptionChange(for: rowIndex, checked: checked)
        case .weight:
            handleWeightCheckboxSelection(for: rowIndex, checked: checked)
        case .refundble:
            handleRefundableStatusSelection(for: rowIndex, checked: checked)
        default:
            return
        }
    }
    
    //MARK:- Stoppage
    
    public func isStoppageOptionChecked(for row: Int) -> Bool {
        guard row < filter.stoppages.count, let stoppages = filteredData.stoppage else { return false }
        let checkingId = filter.stoppages[row].id
        
        for stoppageId in stoppages {
            if checkingId == stoppageId {
                return true
            }
        }
        return false
    }
    
    private func handleStoppageOptionChange(for row: Int, checked: Bool) {
        let stoppageId = filter.stoppages[row].id
        if checked {
            if filteredData.stoppage != nil {
                if !filteredData.stoppage!.contains(stoppageId) {
                    filteredData.stoppage!.append(stoppageId)
                }
            } else {
                filteredData.stoppage = [stoppageId]
            }
        } else {
            filteredData.stoppage?.removeAll(where: { $0 == stoppageId})
        }
    }
    
    //MARK:- Airline
    
    public func isAirlineOptionChecked(for row: Int) -> Bool {
        guard row < filter.airlines.count, let airlineCodes = filteredData.airlines else { return false }
        let checkingCode = filter.airlines[row].code
        
        for airlineCode in airlineCodes {
            if checkingCode == airlineCode {
                return true
            }
        }
        return false
    }
    
    private func handleAirlineOptionChange(for row: Int, checked: Bool) {
        let airlinecode = filter.airlines[row].code
        if checked {
            if filteredData.airlines != nil {
                if !filteredData.airlines!.contains(airlinecode) {
                    filteredData.airlines!.append(airlinecode)
                }
            } else {
                filteredData.airlines = [airlinecode]
            }
        } else {
            filteredData.airlines?.removeAll(where: { $0 == airlinecode})
        }
    }
    
    //MARK:- Layover
    public func isLayoverOptionChecked(for row: Int) -> Bool {
        guard row < filter.layover.count, let layoverIatas = filteredData.layover else { return false }
        let checkingIata = filter.layover[row].iata
    
        for layoverIata in layoverIatas {
            if checkingIata == layoverIata {
                return true
            }
        }
        return false
    }
    
    private func handleLayoverOptionChange(for row: Int, checked: Bool) {
        let iata = filter.layover[row].iata
        if checked {
            if filteredData.layover != nil {
                if !filteredData.layover!.contains(iata) {
                    filteredData.layover!.append(iata)
                }
            } else {
                filteredData.layover = [iata]
            }
        } else {
            filteredData.layover?.removeAll(where: { $0 == iata})
        }
    }
    
    //MARK:- Weights
    public func weightCheckboxChecked(for row: Int) -> Bool {
        guard row < filter.weight.count, let weightKeys = filteredData.weight else { return false }
        let checkingKey = filter.weight[row].key
        
        for weightKey in weightKeys {
            if checkingKey == weightKey {
                return true
            }
        }
        return false
    }
    
    private func handleWeightCheckboxSelection(for row: Int, checked: Bool) {
        let key = filter.weight[row].key
        if checked {
            if filteredData.weight != nil {
                if !filteredData.weight!.contains(key) {
                    filteredData.weight!.append(key)
                }
            } else {
                filteredData.weight = [key]
            }
        } else {
            filteredData.weight?.removeAll(where: { $0 == key})
        }
    }
    
    private var selectedRefundPolicies: Set<Int> = []
    private func handleRefundableStatusSelection(for row: Int, checked: Bool) {
        if checked {
            selectedRefundPolicies.insert(row)
        } else {
            selectedRefundPolicies.remove(row)
        }
        filteredData.isRefundable = Array(selectedRefundPolicies)
    }
    
    //MARK:- TableView DataSource
    public func numberOfSections(for filterType: FlightFilterType) -> Int {
        switch filterType {
        case .schedule:
            if flightRouteType == .round && filter.returnTimeSlot != nil {
                return 2
            } else {
                return 1
            }
        default:
            return 1
        }
    }
    
    public func numberOfRows(for filterType: FlightFilterType, in section: Int = 0) -> Int {
        switch filterType {
        case .reset, .priceRange:
            return filterType.rowCount
        case .schedule:
            switch section {
            case 0:
                return filter.departTimeSlot.count
            case 1:
                if let returnTimeSlot = filter.returnTimeSlot {
                    return returnTimeSlot.count
                } else {
                    return filter.departTimeSlot.count
                }
            default:
                return filter.departTimeSlot.count
            }
        case .stoppage:
            return filter.stoppages.count
        case .airline:
            return filter.airlines.count
        case .layover:
            return filter.layover.count
        case .weight:
            return filter.weight.count
        case .refundble:
            return getRefundPoliciesTitle().count
        }
    }
}

