//
//  FlightAnalaytics.swift
//  STFlightKit
//
//  Created by ST-iOS on 11/20/22.
//


import FirebaseAnalytics

public struct FlightEvent: STAnalyticsEvent {
    public var name: String
    public var payload: Payload?

    private static func getSearchEventName(by routeType: FlightRouteType) -> String {
        switch routeType {
        case .oneWay:
            return "Search_OneWay_Flight"
        case .round:
            return "Search_Return_Flight"
        case .multiCity:
            return "Search_MultiCity_Flight"
        }
    }

    public static func search(request: FlightSearchRequest) -> FlightEvent {
        let name = getSearchEventName(by: request.flightRouteType)
        let payload: Payload = [
            "origins": request.origins,
            "destinations": request.destinations,
            "noOfAdult": request.adult,
            "noOfChild": request.child,
            "noOfInfant": request.infant,
            "flightClass": request.flightClass.rawValue
        ]

        return FlightEvent(name: name, payload: payload)
    }

    public static func searchBusinessClass() -> FlightEvent {
        FlightEvent(name: "Select_Business_Class")
    }

    public static func clickOnPreferredAirline() -> FlightEvent {
        FlightEvent(name: "Click_On_Preferred_Airline")
    }

    public static func clickOnBestDeal() -> FlightEvent {
        FlightEvent(name: "Click_On_Flight_Best_Deals")
    }

    public static func clickOnFilter() -> FlightEvent {
        FlightEvent(name: "Click_On_Flight_Filter")
    }

    public static func aplliedFilter(filterData: FlightFilterData) -> FlightEvent {
        FlightEvent(
            name: "Apply_Flight_Filter",
            payload: filterData.dictionary as? Payload
        )
    }

    public static func clickOnSort(sortingCriteria: String) -> FlightEvent {
        FlightEvent(
            name: "Click_On_Flight_Sort",
            payload: [
                "sortingCriteria": sortingCriteria
            ]
        )
    }

    public static func viewFlightDetails() -> FlightEvent {
        FlightEvent(name: "Click_On_Flight_Details")
    }

    public static func clickOnRefundPolicy() -> FlightEvent {
        FlightEvent(name: "Click_On_Flight_Ticket_Refund_Policy")
    }

    public static func clickOnAirFareRules() -> FlightEvent {
        FlightEvent(name: "Click_On_Air_Fare_Rules")
    }

    public static func clickOnBaggageInfo() -> FlightEvent {
        FlightEvent(name: "Click_On_Flight_Baggage")
    }

    public static func clickOnRedeemTripcoin() -> FlightEvent {
        FlightEvent(name: "Click_On_Redeem_TC_In_Flight")
    }

    public static func bookingButtonTapped() -> FlightEvent {
        FlightEvent(name: "Click_On_Flight_BookNow")
    }

    public static func selectPassengerFromQuickPick() -> FlightEvent {
        FlightEvent(name: "Select_Passenger_from_QuickPick_In_Flight")
    }

    public static func uploadPassport() -> FlightEvent {
        FlightEvent(name: "Upload_Passport_Copy_In_Flight")
    }
    
    public static func initalCheckoutFlight() -> FlightEvent {
        FlightEvent(name: "Initial_Checkout_Flight")
    }
}
