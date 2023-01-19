//
//  FlightPriceIndicatorViewModel.swift
//  STFlightKit
//
//  Created by ST-iOS on 11/28/22.
//

import UIKit


public enum PriceRangeType {
    case cheap, moderate, expensive, unknown
    
    public var title: String {
        switch self {
        case .cheap:
            return "Cheap"
        case .moderate:
            return "Moderate"
        case .expensive:
            return "Expensive"
        case .unknown:
            return "Price not found"
        }
    }
}

public class FlightPriceIndicatorViewModel {
    public private(set) var isLoading = Observable<Bool>(false)

    private let srcCode: String
    private let destCode: String
    private var startDate: Date?
    private var endDate: Date?
    
    public init(srcCode: String, destCode: String, routeType: FlightRouteType) {
        self.srcCode = srcCode
        self.destCode = destCode

        // Hacky way of distinguishing flight route type in the API
        if routeType == .round {
            startDate = Date().adjust(.day, offset: searchingDateOffset)
            endDate = Date().adjust(.day, offset: searchingDateOffset + 2)
        } else {
            startDate = Date().adjust(.day, offset: searchingDateOffset)
        }
    }

    public var searchingDateOffset: Int {
        let now = Date()
        let hour = now.component(.hour) ?? 0
        let minute = now.component(.minute) ?? 0
        let currentTimeInMinute = hour*60 + minute

        let timeInMinute = UserDefaults.standard.integer(forKey: Constants.RemoteConfigKey.flight_search_threshold_time)
        let thresholdTimeInMinute = timeInMinute == 0 ? Constants.FlightConstants.thresholdTimeInMinute : timeInMinute
        if currentTimeInMinute < thresholdTimeInMinute {
            return Constants.FlightConstants.flightSearchingDateOffset
        } else {
            return Constants.FlightConstants.flightSearchingDateOffset + 1
        }
    }

    public typealias PriceRangeLoadCallBack = () -> Void
    private var response: FlightPriceIndicatorResponse?
    
    public func loadPriceIndicator(onCompletion: PriceRangeLoadCallBack?) {
        isLoading.value = true
        var params: [String: String] = [
            "origin": srcCode,
            "destination": destCode
        ]

        // This is a bullshit hacky way and it is the requriement
        if let startDate = startDate, let endDate = endDate {
            let startDateStr = startDate.toString(format: .isoDate)
            let endDateStr = endDate.toString(format: .isoDate)
            params["depart"] = "\(startDateStr)&depart=\(endDateStr)"
        } else if let startDate = startDate {
            params["depart"] = startDate.toString(format: .isoDate)
        }

        FlightAPIClient().loadFlightPriceIndicator(params: params, completion: { [weak self] result in
            switch result {
            case .success(let response):
                if let response = response.response {
                    self?.response = response
                    self?.updateDateWisePrice()
                    onCompletion?()
                } else {
                    STLog.error(response.message)
                }
            case .failure(let error):
                STLog.error(error)
            }
            self?.isLoading.value = false
        })
    }

    private var dateWisePriceMap = [String: DateFlightPriceIndicator]()
    private func updateDateWisePrice() {
        guard let response = response else { return }
        dateWisePriceMap.removeAll()
        response.fare.forEach { [weak self] dateWisePrice in
            if let date = Date(fromString: dateWisePrice.date, format: .isoDate) {
                self?.dateWisePriceMap[date.toString(format: .isoDate)] = dateWisePrice
            }
        }
    }

    public func priceRange(for rangeType: PriceRangeType) -> (Double, Double)? {
        guard let response = response else { return nil }
        guard let responseMin = response.min else { return nil }
        guard let responseMax = response.max else { return nil }
        let min = nonStopFlightOnly ? responseMin.direct : responseMin.nonDirect
        let max = nonStopFlightOnly ? responseMax.direct : responseMax.nonDirect
        let segmentSize = floor((max - min) / 3)
        let oneThird = min + segmentSize
        let twoThird = min + segmentSize * 2

        switch rangeType {
        case .cheap:
            return (min, oneThird)
        case .moderate:
            return (oneThird + 1, twoThird)
        case .expensive:
            return (twoThird + 1, max)
        case .unknown:
            return nil
        }
    }

    public func priceRangeType(for date: Date) -> PriceRangeType? {
        guard let response = response else { return nil }
        guard let responseMin = response.min else { return nil }
        guard let responseMax = response.max else { return nil }

        if let dateWisePrice = dateWisePriceMap[date.toString(format: .isoDate)] {
            let price = nonStopFlightOnly ? dateWisePrice.direct : dateWisePrice.nonDirect
            let min = nonStopFlightOnly ? responseMin.direct : responseMin.nonDirect
            let max = nonStopFlightOnly ? responseMax.direct : responseMax.nonDirect
            let segmentSize = floor((max - min) / 3)
            let oneThird = min + segmentSize
            let twoThird = min + segmentSize * 2

            if min <= price && price <= oneThird {
                return .cheap
            } else if oneThird + 1 <= price && price <= twoThird {
                return .moderate
            } else if twoThird + 1 <= price && price <= max {
                return .expensive
            } else {
                return .unknown
            }
        }

        return nil
    }

    private var nonStopFlightOnly: Bool = false
    
    public func filter(_ apply: Bool) {
        nonStopFlightOnly = apply
    }
}
