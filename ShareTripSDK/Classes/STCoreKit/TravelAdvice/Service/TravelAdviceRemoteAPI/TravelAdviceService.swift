//
//  TravelAdviceService.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 11/11/2020.
//  Copyright © 2020 ShareTrip. All rights reserved.
//

class TravelAdviceService {
    func getTravelAdvice(countryCode: String, onSuccess: @escaping (TravelAdviceSearch?) -> Void, onFailure: @escaping (String) -> Void) {
        APIClientTravelAdvice().getTravelAdvice(countryCode: countryCode){(result) in
            switch result {
                case .success(let response):
                    if response.trips?.count ?? 0 > 0 {
                        onSuccess(response)
                    } else {
                        onFailure("Data Not Found")
                    }
                case .failure(let error):
                    STLog.error(error.localizedDescription)
                    onFailure("Data Not Found")
            }
        }
    }
}
