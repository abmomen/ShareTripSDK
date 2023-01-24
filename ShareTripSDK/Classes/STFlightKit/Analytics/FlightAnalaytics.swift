//
//  FlightAnalaytics.swift
//  STFlightKit
//
//  Created by ST-iOS on 11/20/22.
//


import FirebaseAnalytics

struct FlightEvent: STAnalyticsEvent {
    var name: String
    var payload: Payload?

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

    static func search(request: FlightSearchRequest) -> FlightEvent {
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

    static func searchBusinessClass() -> FlightEvent {
        FlightEvent(name: "Select_Business_Class")
    }

    static func clickOnPreferredAirline() -> FlightEvent {
        FlightEvent(name: "Click_On_Preferred_Airline")
    }

    static func clickOnBestDeal() -> FlightEvent {
        FlightEvent(name: "Click_On_Flight_Best_Deals")
    }

    static func clickOnFilter() -> FlightEvent {
        FlightEvent(name: "Click_On_Flight_Filter")
    }

    static func aplliedFilter(filterData: FlightFilterData) -> FlightEvent {
        FlightEvent(
            name: "Apply_Flight_Filter",
            payload: filterData.dictionary as? Payload
        )
    }

    static func clickOnSort(sortingCriteria: String) -> FlightEvent {
        FlightEvent(
            name: "Click_On_Flight_Sort",
            payload: [
                "sortingCriteria": sortingCriteria
            ]
        )
    }

    static func viewFlightDetails() -> FlightEvent {
        FlightEvent(name: "Click_On_Flight_Details")
    }

    static func clickOnRefundPolicy() -> FlightEvent {
        FlightEvent(name: "Click_On_Flight_Ticket_Refund_Policy")
    }

    static func clickOnAirFareRules() -> FlightEvent {
        FlightEvent(name: "Click_On_Air_Fare_Rules")
    }

    static func clickOnBaggageInfo() -> FlightEvent {
        FlightEvent(name: "Click_On_Flight_Baggage")
    }

    static func clickOnRedeemTripcoin() -> FlightEvent {
        FlightEvent(name: "Click_On_Redeem_TC_In_Flight")
    }

    static func bookingButtonTapped() -> FlightEvent {
        FlightEvent(name: "Click_On_Flight_BookNow")
    }

    static func selectPassengerFromQuickPick() -> FlightEvent {
        FlightEvent(name: "Select_Passenger_from_QuickPick_In_Flight")
    }

    static func uploadPassport() -> FlightEvent {
        FlightEvent(name: "Upload_Passport_Copy_In_Flight")
    }
    
    static func initalCheckoutFlight() -> FlightEvent {
        FlightEvent(name: "Initial_Checkout_Flight")
    }
}
