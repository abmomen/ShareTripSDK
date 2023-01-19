//
//  FlightFilterViewModelOld.swift
//  STFlightKit
//
//  Created by ST-iOS on 11/23/22.
//



public class FlightFilterViewModelOld {
    public let filter: FlightFilter
    public var filteredData: FlightFilterData
    public let flightClass: FlightClass
    public let flightRouteType: FlightRouteType
    
    public init(filter: FlightFilter, filteredData: FlightFilterData, flightClass: FlightClass, flightRouteType: FlightRouteType) {
        self.filter = filter
        self.filteredData = filteredData
        self.flightClass = flightClass
        self.flightRouteType = flightRouteType
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
    
    public lazy var scheduleCellTypes: [ScheduleCellType] = {
        var rowTypes = [ScheduleCellType]()
        rowTypes.append(.title(text: "Onward Depart Time"))
        filter.departTimeSlot.forEach { timeSlot in
            rowTypes.append(.departTimeSlot(key: timeSlot.key, value: timeSlot.value))
        }
        if flightRouteType == .round, let returnTimeSlot = filter.returnTimeSlot {
            rowTypes.append(.title(text: "Return Depart Time"))
            returnTimeSlot.forEach { timeSlot in
                rowTypes.append(.returnTimeSlot(key: timeSlot.key, value: timeSlot.value))
            }
        }
        return rowTypes
    }()
    
    public func scheduleCellType(for row: Int) -> ScheduleCellType {
        return scheduleCellTypes[row]
    }
    
    public func scheduleTimeSlotIsChecked(for row: Int) -> Bool {
        let rowType = scheduleCellTypes[row]
        
        switch rowType {
        case .title:
            return false
        case .departTimeSlot(let key, _):
            return key == filteredData.departTimeSlot
        case .returnTimeSlot(let key, _):
            return key == filteredData.returnTimeSlot
        }
    }
    
    /*private var scheduleRows: Int {
     var rowCount = 1 + filter.departTimeSlot.count
     if flightRouteType == .round, let returncount = filter.returnTimeSlot?.count {
     rowCount += (1 + returncount)
     }
     return rowCount
     }*/
    
    //MARK:- Checkbox
    
    public func checkboxTitle(for indexPath: IndexPath) -> String {
        let sectionType = filterSectionType(for: indexPath.section)
        
        switch sectionType {
        case .stoppage:
            return filter.stoppages[indexPath.row].name
        case .airline:
            return filter.airlines[indexPath.row].short
        case .layover:
            return filter.layover[indexPath.row].name
        case .weight:
            return filter.weight[indexPath.row].note
        default:
            return ""
        }
    }
    
    public func checkboxChecked(for indexpath: IndexPath) -> Bool {
        let sectionType = filterSectionType(for: indexpath.section)
        
        switch sectionType {
        case .stoppage:
            return stoppageCheckboxChecked(for: indexpath.row)
        case .airline:
            return airlineCheckboxChecked(for: indexpath.row)
        case .layover:
            return layoverCheckboxChecked(for: indexpath.row)
        case .weight:
            return weightCheckboxChecked(for: indexpath.row)
        default:
            return false
        }
    }
    
    public func handleCheckboxSelection(indexPath: IndexPath, checked: Bool) {
        let sectionType = filterSectionType(for: indexPath.section)
        
        switch sectionType {
        case .stoppage:
            handleStoppageCheckboxSelection(for: indexPath.row, checked: checked)
        case .airline:
            handleAirlineCheckboxSelection(for: indexPath.row, checked: checked)
        case .layover:
            handleLayoverCheckboxSelection(for: indexPath.row, checked: checked)
        case .weight:
            handleWeightCheckboxSelection(for: indexPath.row, checked: checked)
        default:
            return
        }
    }
    
    //MARK:- Stoppage
    public func stoppageCheckboxChecked(for row: Int) -> Bool {
        guard row < filter.stoppages.count, let stoppages = filteredData.stoppage else { return false }
        let checkingId = filter.stoppages[row].id
        
        for stoppageId in stoppages {
            if checkingId == stoppageId {
                return true
            }
        }
        return false
    }
    
    public func handleStoppageCheckboxSelection(for row: Int, checked: Bool) {
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
    public func airlineCheckboxChecked(for row: Int) -> Bool {
        guard row < filter.airlines.count, let airlineCodes = filteredData.airlines else { return false }
        let checkingCode = filter.airlines[row].code
        
        for airlineCode in airlineCodes {
            if checkingCode == airlineCode {
                return true
            }
        }
        return false
    }
    
    public func handleAirlineCheckboxSelection(for row: Int, checked: Bool) {
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
    public func layoverCheckboxChecked(for row: Int) -> Bool {
        guard row < filter.layover.count, let layoverIatas = filteredData.layover else { return false }
        let checkingIata = filter.layover[row].iata
        
        for layoverIata in layoverIatas {
            if checkingIata == layoverIata {
                return true
            }
        }
        return false
    }
    
    public func handleLayoverCheckboxSelection(for row: Int, checked: Bool) {
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
    
    public func handleWeightCheckboxSelection(for row: Int, checked: Bool) {
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
    
    //MARK:- TableView DataSource
    
    public func filterSectionType(for section: Int) -> FlightFilterType {
        return FlightFilterType.allCases[section]
    }
    
    public var numberOfSections: Int {
        return FlightFilterType.allCases.count
    }
    
    public func numberOfRows(for section: Int) -> Int {
        
        let rowType = FlightFilterType.allCases[section]
        
        switch rowType {
        case .reset, .priceRange:
            return rowType.rowCount
        case .schedule:
            return scheduleCellTypes.count
            //return scheduleRows
        case .stoppage:
            return filter.stoppages.count
        case .airline:
            return filter.airlines.count
        case .layover:
            return filter.layover.count
        case .weight:
            return filter.weight.count
        case .refundble:
            return 2
        }
    }
    
    public func titleForHeader(in section: Int) -> String {
        return FlightFilterType.allCases[section].title
    }
}
