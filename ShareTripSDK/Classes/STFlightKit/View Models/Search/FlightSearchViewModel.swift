//
//  FlightSearchViewModel.swift
//  STFlightKit
//
//  Created by ST-iOS on 11/23/22.
//

import Alamofire
import STCoreKit

public typealias FlightInfoTuple = (departure: Airport?, arrival: Airport?, dateRange: ClosedRange<Date>?)

public struct FlightSearchRequestParmas {
    public let adult: Int
    public let child: Int
    public let infanct: Int
    public let depurtureDate: Date
    public let arrivalDate: Date?
    public let firstAirportIata: String
    public let lastAirportIata: String
    
    public init(adult: Int, child: Int, infanct: Int, depurtureDate: Date, arrivalDate: Date?, firstAirportIata: String, lastAirportIata: String) {
        self.adult = adult
        self.child = child
        self.infanct = infanct
        self.depurtureDate = depurtureDate
        self.arrivalDate = arrivalDate
        self.firstAirportIata = firstAirportIata
        self.lastAirportIata = lastAirportIata
    }
}

public struct FlightSearchViewModel {
    public init() { }
    
    public let maxRoute = 5
    public private(set) var flightRouteType: FlightRouteType = .round
    public private(set) var cellOptions: [FlightSearchCellOption] = [.routeType, .airport, .date, .travellerClass, .searchButton, .explore]
    private var flightInfos: [FlightInfoTuple] = [ (nil, nil, nil), (nil, nil, nil)]
    
    public let travellerClassViewModel = TravellerClassViewModel()
    
    public var isPromotionAvailable = false
    
    public var searchButtonEnabled: Bool {
        get {
            
            guard let flightInfo = flightInfos.first, flightInfo.departure != nil,
                flightInfo.arrival != nil, flightInfo.dateRange != nil else {
                    return false
            }
            
            switch flightRouteType {
            case .oneWay, .round:
                break
            case .multiCity:
                
                for index in 1..<flightInfos.count {
                    let flightInfo = flightInfos[index]
                    guard flightInfo.departure != nil, flightInfo.arrival != nil, flightInfo.dateRange != nil else {
                        return false
                    }
                }
            }
            
            return true
        }
    }
    
    public var flightClass: FlightClass {
        return travellerClassViewModel.flightClass
    }
    
    public var travellersText: String {
        var travellersStr = "\(travellerClassViewModel.totalTravelersCount) Person"
        travellersStr = travellersStr.getPlural(count: travellerClassViewModel.totalTravelersCount)
        travellersStr += (" - " + travellerClassViewModel.flightClass.title)
        return travellersStr
    }
    
    public var flightSearchRequestParmas: FlightSearchRequestParmas {
        FlightSearchRequestParmas(
            adult: travellerClassViewModel.adultCount,
            child: travellerClassViewModel.childCount,
            infanct: travellerClassViewModel.infantCount,
            depurtureDate: firstDate ?? Date(),
            arrivalDate: lastDate,
            firstAirportIata: firstAirportIata,
            lastAirportIata: lastAirportIata
        )
    }
    
    /// map cellindex to flightInfos index. For example, map index 1, 3, 5, 7 to 0, 1, 2, 3 respectively
    private func getFlightInfoIndex(for index: Int) -> Int {
        return flightRouteType == .multiCity ? (index-1)/2 : 0
    }
    
    public func navigationTitleViewData(showArrow: Bool = true) -> FlightNavTitleViewData {
        return FlightNavTitleViewData(
            flightRouteType: flightRouteType,
            firstText: firstAirportIata,
            secondText: lastAirportIata,
            firstDate: firstDate,
            secondDate: lastDate,
            travellerText: travellersText,
            showArrow: showArrow
        )
    }

    public func validate() -> Result<Void, AppError> {
        if flightRouteType == .multiCity {
            var row = 2
            var prevDate = Date().adjust(.year, offset: -5)
            while let date = getDate(for: row) {
                if prevDate > date {
                    return .failure(.validationError("Previous flight date can't be ahead of next flight date"))
                }
                prevDate = date
                row += 2
            }
        }
        return .success(())
    }
    
    public mutating func updateCellOption(for type: FlightRouteType?) {

        if let type = type {
            self.flightRouteType = type
        }
        
        switch self.flightRouteType {
        case .round, .oneWay:
            cellOptions = [.routeType, .airport, .date, .travellerClass, .searchButton, .explore]
        case .multiCity:
            var options: [FlightSearchCellOption] = [.routeType, .airport, .date, .airport, .date, .travellerClass, .addCity, .searchButton, .explore]
            let remainingPair = flightInfos.count - 2
            for _ in 0..<remainingPair {
                options.insert(contentsOf: [.airport, .date], at: 1)
            }
            cellOptions = options
        }
        
        if isPromotionAvailable {
            cellOptions.append(.promotionalImage)
        }
    }
    
    //MARK:- Parameters
    
    public func getFlightSearchRequest() -> FlightSearchRequest? {
        
        switch flightRouteType {
        case .oneWay, .round:
            
            guard let firstFlightInfo = flightInfos.first,
                let origin = firstFlightInfo.departure?.iata,
                let destination = firstFlightInfo.arrival?.iata,
                let departDate = firstFlightInfo.dateRange?.lowerBound else {
                    return nil
            }
            
            var dates: [Date]!
            if flightRouteType == .oneWay {
                dates = [departDate]
            } else {
                guard let returnDate = firstFlightInfo.dateRange?.upperBound else { return nil }
                dates = [departDate, returnDate]
            }
            
            return FlightSearchRequest(
                routeType: flightRouteType,
                flightClass: travellerClassViewModel.flightClass,
                adult: travellerClassViewModel.adultCount,
                child: travellerClassViewModel.childCount,
                childDobs: travellerClassViewModel.getChidrenAgeStrings(),
                infant: travellerClassViewModel.infantCount,
                origins: [origin],
                destinations: [destination],
                departDates: dates
            )
        case .multiCity:
            
            let origins = flightInfos.compactMap { $0.departure?.iata }
            let destinations = flightInfos.compactMap { $0.arrival?.iata }
            let departDates = flightInfos.compactMap { $0.dateRange?.lowerBound }
            
            return FlightSearchRequest(
                routeType: flightRouteType,
                flightClass: travellerClassViewModel.flightClass,
                adult: travellerClassViewModel.adultCount,
                child: travellerClassViewModel.childCount,
                childDobs: travellerClassViewModel.getChidrenAgeStrings(),
                infant: travellerClassViewModel.infantCount,
                origins: origins,
                destinations: destinations,
                departDates: departDates
            )
        }
    }
    
    public func getFlightSearchParameters() -> Parameters {
        var queryParams: Parameters = [
            Constants.APIParameterKey.tripType: flightRouteType.rawValue,
            Constants.APIParameterKey.flightClass: travellerClassViewModel.flightClass.rawValue,
            Constants.APIParameterKey.adult: travellerClassViewModel.adultCount,
            Constants.APIParameterKey.child: travellerClassViewModel.childCount,
            Constants.APIParameterKey.infant: travellerClassViewModel.infantCount,
        ]
        
        queryParams["childAge[]"] = travellerClassViewModel.getChidrenAgeStrings()
        
        switch flightRouteType {
        case .oneWay:
            
            let origin = flightInfos.first!.departure!.iata
            let destination = flightInfos.first!.arrival!.iata
            let departDate = flightInfos.first!.dateRange!.lowerBound.toString(format: .isoDate)
            
            queryParams[Constants.APIParameterKey.origin] = origin
            queryParams[Constants.APIParameterKey.destination] = destination
            queryParams[Constants.APIParameterKey.depart] = departDate
            
        case .round:
            
            let origin = flightInfos.first!.departure!.iata
            let destination = flightInfos.first!.arrival!.iata
            let departDate = flightInfos.first!.dateRange!.lowerBound.toString(format: .isoDate)
            let returnDate = flightInfos.first!.dateRange!.upperBound.toString(format: .isoDate)
            
            queryParams[Constants.APIParameterKey.origin] = origin
            queryParams[Constants.APIParameterKey.destination] = destination
            queryParams[Constants.APIParameterKey.depart] = [departDate, returnDate]
            
        case .multiCity:

            let origins = flightInfos.compactMap { $0.departure?.iata }
            let destinations = flightInfos.compactMap { $0.arrival?.iata }
            let departDates = flightInfos.compactMap { $0.dateRange?.lowerBound.toString(format: .isoDate) }
            
            queryParams[Constants.APIParameterKey.origin] = origins
            queryParams[Constants.APIParameterKey.destination] = destinations
            queryParams[Constants.APIParameterKey.depart] = departDates
            
            queryParams[Constants.APIParameterKey.query] = true
        }
        
        return queryParams
    }
    
    //MARK:- City
    
    public mutating func addCity(){
        guard flightRouteType == .multiCity else { return }
        guard flightInfos.count < maxRoute else { return }
        let arrival = flightInfos.last?.arrival
        flightInfos.append((departure: arrival, arrival: nil, dateRange: nil))
        updateCellOption(for: .none)
    }
    
    public mutating func removeCity(){
        guard flightRouteType == .multiCity else { return }
        guard flightInfos.count > 2 else { return }
        flightInfos.removeLast()
        updateCellOption(for: .none)
    }
    
    //MARK:- Flight Leg Getter Setter
    
    public func getFlightInfoTuple(for cellIndex: Int) -> FlightInfoTuple? {
        let index: Int = getFlightInfoIndex(for: cellIndex)
        guard flightInfos.count > index else { return nil}
        return flightInfos[index]
    }
    
    public func getDeparture(for cellIndex: Int) -> Airport? {
        let index: Int = getFlightInfoIndex(for: cellIndex)
        guard flightInfos.count > index else { return nil}
        return flightInfos[index].departure
    }
    
    public mutating func setDeparture(for cellIndex: Int, value: Airport) {
        let index: Int = getFlightInfoIndex(for: cellIndex)
        guard flightInfos.count > index else { return }
        var flightInfo = flightInfos[index]
        flightInfo.departure = value
        
        if value == flightInfo.arrival {
            
            let nextIndex = index+1
            if flightInfos.count > nextIndex {
                var nextFlightInfo = flightInfos[nextIndex]
                if flightInfo.arrival == nextFlightInfo.departure {
                    nextFlightInfo.departure = nil
                    flightInfos[nextIndex] = nextFlightInfo
                }
            }
            flightInfo.arrival = nil
        }
        flightInfos[index] = flightInfo
    }
    
    public func getArrival(for cellIndex: Int) -> Airport? {
        let index: Int = getFlightInfoIndex(for: cellIndex)
        guard flightInfos.count > index else { return nil}
        return flightInfos[index].arrival
    }
    
    public mutating func setArrival(for cellIndex: Int, value: Airport) {
        let index: Int = getFlightInfoIndex(for: cellIndex)
        guard flightInfos.count > index else { return }
        var flightInfo = flightInfos[index]
        flightInfo.arrival = value
        
        if flightInfo.departure == value {
            flightInfo.departure = nil
        }
        flightInfos[index] = flightInfo
        
        let nextIndex = index+1
        if flightInfos.count > nextIndex {
            var nextFlightInfo = flightInfos[nextIndex]
            nextFlightInfo.departure = value
            flightInfos[nextIndex] = nextFlightInfo
        }
    }

    public mutating func swapAirports(for cellIndex: Int) {
        let index: Int = getFlightInfoIndex(for: cellIndex)
        guard flightInfos.count > index else { return }

        var flightInfo = flightInfos[index]
        let departure = flightInfo.departure
        flightInfo.departure = flightInfo.arrival
        flightInfo.arrival = departure

        flightInfos[index] = flightInfo
    }
    
    //MARK:- First Last Info
    
    public var firstAirportIata: String {
        return flightInfos.first?.departure?.iata ?? ""
    }
    
    public var lastAirportIata: String {
        
        if flightRouteType == .multiCity {
            return flightInfos.last?.arrival?.iata ?? ""
        } else {
            return flightInfos.first?.arrival?.iata ?? ""
        }
    }
    
    public var firstDate: Date? {
        return flightInfos.first?.dateRange?.lowerBound
    }
    
    public var lastDate: Date? {
        switch flightRouteType {
        case .round:
            return flightInfos.first?.dateRange?.upperBound
        case .oneWay:
            return nil
        case .multiCity:
            return flightInfos.last?.dateRange?.lowerBound
        }
    }
    
    //MARK:- Date
    
    public func getDate(for cellIndex: Int) -> Date? {
        let index: Int = getFlightInfoIndex(for: cellIndex)
        guard flightInfos.count > index else { return nil}
        return flightInfos[index].dateRange?.lowerBound
    }
    
    public mutating func setDate(for cellIndex: Int, value: Date) {
        let index: Int = getFlightInfoIndex(for: cellIndex)
        guard flightInfos.count > index else { return }
        var flightInfo = flightInfos[index]
        flightInfo.dateRange = value...value.adjust(.day, offset: 2)
        flightInfos[index] = flightInfo
        
        // Update travel date also
        travellerClassViewModel.travelDate = value
    }

    public func getSourceDestCode(for cellIndex: Int) -> (String, String)? {
        let index: Int = getFlightInfoIndex(for: cellIndex)
        guard flightInfos.count > index else { return nil }
        if let src = flightInfos[index].departure?.iata, let dest = flightInfos[index].arrival?.iata {
            return (src, dest)
        }
        return nil
    }
    
    public func getDateRange(for cellIndex: Int) -> ClosedRange<Date>? {
        let index: Int = getFlightInfoIndex(for: cellIndex)
        guard flightInfos.count > index else { return nil}
        return flightInfos[index].dateRange
    }
    
    public mutating func setDateRange(for cellIndex: Int, value: ClosedRange<Date>) {
        let index: Int = getFlightInfoIndex(for: cellIndex)
        guard flightInfos.count > index else { return }
        var flightInfo = flightInfos[index]
        flightInfo.dateRange = value
        flightInfos[index] = flightInfo
        
        // Update travel date also
        travellerClassViewModel.travelDate = value.lowerBound
    }
    
    public func getformatedDateString(for cellIndex: Int) -> String? {
        let index: Int = getFlightInfoIndex(for: cellIndex)
        guard flightInfos.count > index else { return nil }
        let flightInfo = flightInfos[index]
        if flightRouteType == .round {
            guard let departDate = flightInfo.dateRange?.lowerBound, let returnDate = flightInfo.dateRange?.upperBound else {
                return nil
            }
            let departDateStr = departDate.toString(format: .shortDate)
            let returnDateStr = returnDate.toString(format: .shortDate)
            let departDay = departDate.toString(format: .custom("EEE"))
            let returnDay = returnDate.toString(format: .custom("EEE"))
            
            return "\(departDateStr) - \(returnDateStr) (\(departDay) - \(returnDay))"
        } else {
            
            guard let departDate = flightInfo.dateRange?.lowerBound else { return nil }
            let departDateStr = departDate.toString(format: .shortDate)
            let departDay = departDate.toString(format: .custom("EEE"))
            return "\(departDateStr) (\(departDay))"
        }
    }

    //MARK: Extended Properties
    public var hasMoreRoutes: Bool {
        return flightInfos.count < maxRoute
    }
    
    public var addedNewRoute: Bool {
        let routeCount = flightInfos.count
        return routeCount > 2
    }
    
    public var flightLeg: Int {
        switch flightRouteType {
        case .oneWay:
            return 1
        case .round:
            return 2
        case .multiCity:
            return flightInfos.count
        }
    }
}
