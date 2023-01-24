//
//  FlightAPIRouter.swift
//  STFlightKit
//
//  Created by ST-iOS on 11/22/22.
//

import Alamofire


enum FlightAPIRouter: APIEndpoint {
    case airportSearch(name: String)
    case flightSearch(params: Parameters)
    case flightDetails(request: FlightDetailsRequest)
    case flightSearchFilter(params: Parameters)
    case flightRules(searchId: String, sequenceCode: String)
    case uploadFlightDoc(bodyData: Data)
    case loadFlightPriceIndicator(params: Parameters)
    case fetchSSRCodes
    case fetchFlightPromotions
    case covid19TestInfo
    case fetchCovid19CenterDetails(code: String)
    case travelInsurance
    case travelInsuranceDetails(code: String)
    case fetchBaggages(params: Parameters)
    case revalidateFligt(bodyData: Data)
    case flightBooking(bodyData: Data)
    case flightRetryBooking(bookingCode: String)
    
    //Flight Booking History
    case flightBookingHistory(status: String?, params: Parameters?)
    case flightBookingCancel(bookingCode: String)
    case flightBookingVoucher(bookingCode: String)
    
    // MARK: - HTTPMethod
    var method: Alamofire.HTTPMethod {
        switch self {
        case .airportSearch, .flightSearch, .flightRules, .uploadFlightDoc, .loadFlightPriceIndicator, .flightRetryBooking:
            return .get
            
        case .flightDetails:
            return .get
            
        case .fetchSSRCodes, .fetchBaggages, .covid19TestInfo, .fetchCovid19CenterDetails, .travelInsurance, .travelInsuranceDetails,  .fetchFlightPromotions:
            return .get
            
        case .flightSearchFilter, .revalidateFligt, .flightBooking:
            return .post
            
        case .flightBookingHistory, .flightBookingCancel, .flightBookingVoucher:
            return .get
        }
    }
    
    // MARK:- Path
    var path: String {
        switch self {
        
        //Flight
        case .airportSearch:
            return "/flight/search/airport"
        case .flightSearch:
            return "/flight/search"
        case .flightDetails:
            return "/flight/details"
        case .flightSearchFilter:
            return "/flight/search/filter"
        case .flightRules(let searchId, let sequenceCode):
            return "/flight/search/fare-rules?searchId=\(searchId)&sequenceCode=\(sequenceCode)"
        case .uploadFlightDoc:
            return "/flight/booking/update"
        case .loadFlightPriceIndicator:
            return "/flight/advance-search"
        case .fetchSSRCodes:
            return "/flight/ssr-codes"
        case .fetchFlightPromotions:
            return "/flight/promotion"
        case .covid19TestInfo:
            return "/covid/addon-service"
        case .fetchCovid19CenterDetails(let code):
            return "/covid/service?code=\(code)"
        case .travelInsurance:
            return "/travel-insurance/addon-service"
        case .travelInsuranceDetails(let code):
            return "/travel-insurance/service?code=\(code)"
        case .fetchBaggages:
            return "/flight/luggage"
        case .revalidateFligt:
            return "/flight/revalidate"
        case .flightBooking:
            return "/flight/booking/booking"
        case .flightRetryBooking:
            return "/flight/booking/payment-link"
            
        //Flight Booking History
        case .flightBookingHistory(let status, _):
            if let status = status {
                return "/flight/booking/history?status=\(status)"
            } else {
                return "/flight/booking/history"
            }
        case .flightBookingCancel(let bookingCode):
            return "/flight/booking/booking-cancel?bookingCode=\(bookingCode)"
        case .flightBookingVoucher(let bookingCode):
            return "/flight/voucher-send?bookingCode=\(bookingCode)"
        }
    }
    
    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {
        
        //Flight
        case .airportSearch(let name):
            return [Constants.APIParameterKey.name: name]
        case .flightSearch(let params):
            return params
        case .flightDetails(let request):
            return request.params
        case .flightSearchFilter(let params):
            return params
        case .flightRules:
            return nil
        case .uploadFlightDoc:
            return nil
        case .loadFlightPriceIndicator(let params):
            return params
        case .fetchSSRCodes, .covid19TestInfo, .fetchCovid19CenterDetails, .travelInsurance, .travelInsuranceDetails, .fetchFlightPromotions:
            return nil
        case .fetchBaggages(let params):
            return params
        case .revalidateFligt:
            return nil
        case .flightBooking:
            return nil
        case .flightRetryBooking(let bookingCode):
            return [Constants.APIParameterKey.bookingCode: bookingCode]
            
        //Flight Booking History
        case .flightBookingHistory(_, let params):
            return params
        case .flightBookingCancel:
            return nil
        case .flightBookingVoucher:
            return nil
        }
    }
    
    // MARK: - Image Data Tuples
    var imageDataTuple: (String, Data)? {
        switch self {
        default:
            return nil
        }
    }
    
    // MARK: - bodyData
    var bodyData: Data? {
        switch self {
        case .revalidateFligt(let data), .flightBooking(let data):
            return data
        default:
            return nil
        }
    }
    
    //MARK: ContentType
    var contentType: ContentType? {
        switch self {
        default:
            return .json
        }
    }
}


