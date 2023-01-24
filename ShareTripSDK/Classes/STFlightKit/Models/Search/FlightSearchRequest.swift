//
//  FlightSearchRequest.swift
//  STFlightKit
//
//  Created by ST-iOS on 11/20/22.
//

import UIKit
import Alamofire


struct FlightSearchRequest {
    let flightRouteType: FlightRouteType
    let flightClass: FlightClass
    let adult: Int
    let child: Int
    let childDobs: [String]
    let infant: Int
    let origins: [String]
    let destinations: [String]
    let departDates: [Date]
    
    init?(
        routeType: FlightRouteType,
        flightClass: FlightClass,
        adult: Int,
        child: Int,
        childDobs: [String],
        infant: Int,
        origins: [String],
        destinations: [String],
        departDates: [Date]
    ) {
        
        guard origins.count > 0, destinations.count > 0, departDates.count > 0 else { return nil }
        
        if routeType == .oneWay && (origins.count != 1 || destinations.count != 1 || departDates.count != 1) { return nil }
        
        if routeType == .round && (origins.count != 1 || destinations.count != 1 || departDates.count != 2) { return nil }
        
        if routeType == .multiCity && (origins.count != destinations.count || origins.count != departDates.count) { return nil }
        
        self.flightRouteType = routeType
        self.flightClass = flightClass
        self.adult = adult
        self.child = child
        self.childDobs = childDobs
        self.infant = infant
        self.origins = origins
        self.destinations = destinations
        self.departDates = departDates
    }

    //MARK:- Parameters
    func getParameters() -> Parameters {
        var queryParams: Parameters = [
            Constants.APIParameterKey.tripType: flightRouteType.rawValue,
            Constants.APIParameterKey.flightClass: flightClass.rawValue,
            Constants.APIParameterKey.adult: adult,
            Constants.APIParameterKey.child: child,
            Constants.APIParameterKey.infant: infant,
            Constants.APIParameterKey.origin: origins,
            Constants.APIParameterKey.destination: destinations,
        ]
        queryParams["childAge[]"] = childDobs
        
        switch flightRouteType {
        case .oneWay:

            let departDate = departDates.first!.toString(format: .isoDate)
            queryParams[Constants.APIParameterKey.depart] = departDate

        case .round:

            let departDate = departDates[0].toString(format: .isoDate)
            let returnDate = departDates[1].toString(format: .isoDate)
            queryParams[Constants.APIParameterKey.depart] = [departDate, returnDate]

        case .multiCity:
            
            let dates = departDates.map { $0.toString(format: .isoDate) }
            queryParams[Constants.APIParameterKey.depart] = dates
            queryParams[Constants.APIParameterKey.query] = true
        }

        return queryParams
    }
}
