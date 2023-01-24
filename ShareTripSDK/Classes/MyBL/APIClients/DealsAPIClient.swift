//
//  DealsAPIClient.swift
//  URLSessionNetworking
//
//  Created by ST-iOS on 6/28/22.
//

import Foundation

private struct FetchDealsEndPoint: EndPoint {
    var path: String = "/notifications"
}


enum DealsAPIClient: GenericAPIClient {
    static func fetchDeals(completion: @escaping (Result<Response<NotifierDeals?>, NetworkError>) -> Void) {
        let endPoint = FetchDealsEndPoint()
        startRequest(with: endPoint, completion: completion)
    }
    
}
