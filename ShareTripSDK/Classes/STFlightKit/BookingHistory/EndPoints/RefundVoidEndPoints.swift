//
//  RefundVoidEndPoints.swift
//  ShareTrip
//
//  Created by ST-iOS on 5/9/22.
//  Copyright © 2022 ShareTrip. All rights reserved.
//


import Alamofire

enum RefundVoidEndPoints: APIEndpoint {
    
    case refundableCustomers(FlightRefundEligibleTravellersRequest)
    case refundQuotation(FlightRefundQuotationRequest)
    case confirmRefund(FlightRefundConfirmRequest)
    case voidQuotation(FlightVoidQuotationRequest)
    case confirmVoid(FlightVoidConfirmRequest)
    
    var path: String {
        switch self {
        case .refundableCustomers:
            return "/flight/refund/eligible-travellers"
        case .refundQuotation:
            return "/flight/refund/quotation"
        case .confirmRefund:
            return "/flight/refund/confirm"
        case .voidQuotation:
            return "/flight/void/quotation"
        case .confirmVoid:
            return "/flight/void/confirm"
        }
    }
    
    var parameters: Parameters? {
        var parameters = [String: Any]()
        switch self {
        case .refundableCustomers(let request):
            parameters["bookingCode"] = request.bookingCode
            parameters["searchId"] = request.searchId
            return parameters
            
        case .refundQuotation(let request):
            parameters["bookingCode"] = request.bookingCode
            parameters["searchId"] = request.searchId
            parameters["eTickets"] = request.eTicketsParam
            return parameters
            
        case .voidQuotation(let request):
            parameters["bookingCode"] = request.bookingCode
            parameters["searchId"] = request.searchId
            return parameters
        
        default:
            return nil
        }
    }
    
    var bodyData: Data? {
        switch self {
        case .confirmRefund(let request):
            guard let bodyData = try? JSONEncoder().encode(request) else {
                return nil
            }
            return bodyData
            
        case .confirmVoid(let request):
            guard let bodyData = try? JSONEncoder().encode(request) else {
                return nil
            }
            return bodyData
            
        default:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .refundableCustomers, .refundQuotation, .voidQuotation:
            return .get
        case .confirmRefund, .confirmVoid:
            return .post
        }
    }
}
