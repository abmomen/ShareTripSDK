//
//  CouponEndPoints.swift
//  ShareTrip
//
//  Created by ST-iOS on 9/20/22.
//  Copyright © 2022 ShareTrip. All rights reserved.
//

import Alamofire

enum CouponEndPoints: APIEndpoint {
    case validateCoupon(params: Parameters)
    case checkGPStar(GPStarRequest)
    case verifyOTP(GPStarRequest)
    
    var method: HTTPMethod {
        switch self {
        case .validateCoupon, .checkGPStar, .verifyOTP:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .validateCoupon:
            return "/coupon/validate"
            
        case .checkGPStar:
            return "/loyalty-check"
            
        case .verifyOTP:
            return "/otp-verify"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .validateCoupon(let params):
            return params
            
        default:
            return nil
        }
    }
    
    var bodyData: Data? {
        switch self {
        case .checkGPStar(let request):
            return try? JSONEncoder().encode(request)
            
        case .verifyOTP(let request):
            return try? JSONEncoder().encode(request)
            
        default:
            return nil
        }
    }
}
