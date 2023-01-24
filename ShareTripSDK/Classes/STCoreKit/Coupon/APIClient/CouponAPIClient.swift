//
//  CouponAPIClient.swift
//  ShareTrip
//
//  Created by ST-iOS on 9/20/22.
//  Copyright © 2022 ShareTrip. All rights reserved.
//

import Alamofire

class CouponAPIClient: APIClient {
    init() {}
    
    func applyCoupon(params: [String: Any], completion: @escaping (AFResult<Response<CouponApplyResponse>>) -> Void) {
        performRequest(route: CouponEndPoints.validateCoupon(params: params), completion: completion)
    }
    
    func checkGPStar(request: GPStarRequest, completion: @escaping (AFResult<Response<GPStarPhoneCheckResponse>>) -> Void) {
        performRequest(route: CouponEndPoints.checkGPStar(request), completion: completion)
    }
    
    func verifyOTP(request: GPStarRequest, completion: @escaping (AFResult<Response<GPStarOTPCheckResponse>>) -> Void) {
        performRequest(route: CouponEndPoints.verifyOTP(request), completion: completion)
    }
}
