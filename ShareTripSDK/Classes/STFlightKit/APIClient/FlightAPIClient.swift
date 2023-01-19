//
//  FlightAPIClient.swift
//  STFlightKit
//
//  Created by ST-iOS on 11/22/22.
//

import Alamofire


public class FlightAPIClient: APIClient {
    public init () { }
    
    public func airportSearch(name: String, completion:@escaping (AFResult<ResponseList<Airport>>)->Void) -> DataRequest {
        return performRequest(route: FlightAPIRouter.airportSearch(name: name), completion: completion)
    }
    
    public func flightSearch(params: Parameters, hasFilter: Bool = false, completion:@escaping (AFResult<Response<FlightSearchResponse>>)->Void) -> DataRequest {
        let router: FlightAPIRouter = hasFilter ? FlightAPIRouter.flightSearchFilter(params: params) : FlightAPIRouter.flightSearch(params: params)
        return performRequest(route: router, completion: completion)
    }
    
    public func flightRules(searchId: String, sequenceCode: String, completion:@escaping (AFResult<Response<FlightRuleResponse>>)->Void){
        performRequest(route: FlightAPIRouter.flightRules(searchId: searchId, sequenceCode: sequenceCode), completion: completion)
    }
    
    public func uploadFlightDoc(bodyData: Data, completion:@escaping (AFResult<BaseResponse>) -> Void) {
        performRequest(route: FlightAPIRouter.uploadFlightDoc(bodyData: bodyData), completion: completion)
    }

    public func loadFlightPriceIndicator(params: Parameters, completion: @escaping (AFResult<Response<FlightPriceIndicatorResponse>>) -> Void) {
        performRequest(route: FlightAPIRouter.loadFlightPriceIndicator(params: params), completion: completion)
    }

    public func fetchSSRCodes(completion: @escaping (AFResult<Response<[SSRType]>>) -> Void) {
        performRequest(route: FlightAPIRouter.fetchSSRCodes, completion: completion)
    }
    
    public func fetchFlightPromotions(completion: @escaping (AFResult<Response<FlightPromotions>>) -> Void) {
        performRequest(route: FlightAPIRouter.fetchFlightPromotions, completion: completion)
    }
    
    public func fetchCovid19TestInfo(completion: @escaping (AFResult<Response<[Covid19TestOptionResponse]>>) -> Void) {
        performRequest(route: FlightAPIRouter.covid19TestInfo, completion: completion)
    }
    
    public func fetchCovid19TestCenterDetails(withCode: String, completion: @escaping (AFResult<Response<CovidTestCenterDetailsResponse>>) -> Void) {
        performRequest(route: FlightAPIRouter.fetchCovid19CenterDetails(code: withCode), completion: completion)
    }
    
    public func fetchTravelInsurance(completion: @escaping (AFResult<Response<[TravelInsuranceAddonServiceResponse]>>) -> Void) {
        performRequest(route: FlightAPIRouter.travelInsurance, completion: completion)
    }
    
    public func fetchTravelInsuranceDetails(code: String, completion: @escaping(AFResult<Response<TravelInsuranceServiceDetailResponse>>) -> Void) {
        performRequest(route: FlightAPIRouter.travelInsuranceDetails(code: code), completion: completion)
    }
    
    public func fetchBaggage(request: FlightRevalidationRequest, completion: @escaping (AFResult<Response<BaggageResponse>>) -> Void) {
        let params: Parameters = ["searchId": request.searchId, "sequenceCode": request.sequenceCode, "sessionId": request.sessionId]
        performRequest(route: FlightAPIRouter.fetchBaggages(params: params), completion: completion)
    }
    
    public func bookFlight(bodyData: Data, completion:@escaping (AFResult<FlightBookingResponse>) -> Void) {
        performRequest(route: FlightAPIRouter.flightBooking(bodyData: bodyData), completion: completion)
    }
    
    public func retryBookingFlight(bookingCode: String, completion:@escaping (AFResult<FlightBookingResponse>) -> Void) {
        performRequest(route: FlightAPIRouter.flightRetryBooking(bookingCode: bookingCode), completion: completion)
    }
    
    public func revalidateFlightPrice(request: FlightRevalidationRequest, completion: @escaping (AFResult<Response<FlightRevalidationResponse>>) -> Void) {
        guard let data = try? JSONSerialization.data(withJSONObject: request.params, options: []) else {
            let error = AppError.validationError("Request Invalid, can't encode")
            completion(.failure(.parameterEncoderFailed(reason: .encoderFailed(error: error))))
            return
        }

        performRequest(route: FlightAPIRouter.revalidateFligt(bodyData: data), completion: completion)
    }
    
    //MARK:- Flight Booking History
    public func fetchFlightBookingHistory(
        status: String? = nil, params: [String: Any],
        completion:@escaping (AFResult<Response<FlightBookingHistoryResponse>>) -> Void) {
        performRequest(route: FlightAPIRouter.flightBookingHistory(status: status, params: params),completion: completion)
    }
    
    public func cancelFlightBooking(bookingCode: String, completion:@escaping (AFResult<BaseResponse>) -> Void) {
        performRequest(route: FlightAPIRouter.flightBookingCancel(bookingCode: bookingCode), completion: completion)
    }
    
    public func resendFlightBookingVoucher(bookingCode: String, completion:@escaping (AFResult<BaseResponse>) -> Void) {
        performRequest(route: FlightAPIRouter.flightBookingVoucher(bookingCode: bookingCode), completion: completion)
    }
    
    public func fetchFlightDetails(request: FlightDetailsRequest, completion: @escaping (AFResult<Response<FlightDetailsResponse>>) -> Void) {
        performRequest(route: FlightAPIRouter.flightDetails(request: request), completion: completion)
    }
    
    //MARK:- Others
    public func getShareLink(for serviceType: ServiceType, value: String = "url", completion:@escaping (AFResult<ShareResponse>) -> Void) {
        let params = [Constants.APIParameterKey.type: serviceType.title, Constants.APIParameterKey.value: value]
        performRequest(route: APIRouter.getShareLink(params: params), completion: completion)
    }
}
