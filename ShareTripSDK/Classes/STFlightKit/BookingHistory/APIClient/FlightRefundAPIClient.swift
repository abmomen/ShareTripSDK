//
//  FlightRefundAPIClient.swift
//  ShareTrip
//
//  Created by ST-iOS on 5/9/22.
//  Copyright © 2022 ShareTrip. All rights reserved.
//

import Alamofire


class FlightRefundAPIClient: APIClient {
    func fetchEligibleTravellers(
        request: FlightRefundEligibleTravellersRequest,
        completion: @escaping (AFResult<Response<RefundableTravellersResponse>>) -> Void) {
        performRequest(route: RefundVoidEndPoints.refundableCustomers(request), completion: completion)
    }
    
    func getRefundQuotations(
        request: FlightRefundQuotationRequest,
        completion: @escaping (AFResult<Response<RefundQuotationCheckResponse>>) -> Void) {
        performRequest(route: RefundVoidEndPoints.refundQuotation(request), completion: completion)
    }
    
    func confirmFlightRefund(
        request: FlightRefundConfirmRequest,
        completion: @escaping (AFResult<Response<Empty>>) -> Void) {
        performRequest(route: RefundVoidEndPoints.confirmRefund(request), completion: completion)
    }
    
    func getVoidQuotations(
        request: FlightVoidQuotationRequest,
        completion: @escaping (AFResult<Response<FlightVoidQuotationResponse>>) -> Void) {
        performRequest(route: RefundVoidEndPoints.voidQuotation(request), completion: completion)
    }
    
    func confirmVoid(
        request: FlightVoidConfirmRequest,
        completion: @escaping (AFResult<Response<Empty>>) -> Void) {
        performRequest(route: RefundVoidEndPoints.confirmVoid(request), completion: completion)
    }
}
