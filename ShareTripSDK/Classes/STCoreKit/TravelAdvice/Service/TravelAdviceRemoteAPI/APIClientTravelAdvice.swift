//
//  APIClientTravelAdvice.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 11/11/2020.
//  Copyright © 2020 ShareTrip. All rights reserved.
//

import Alamofire

class APIClientTravelAdvice: APIClient {
    func getTravelAdvice(countryCode: String, completion: @escaping (AFResult<TravelAdviceSearch>) -> Void) {
        performRequest(route: TravelAdviceAPIRoute.getTravelAdvice(countryCode: countryCode), completion: completion)
    }
}
