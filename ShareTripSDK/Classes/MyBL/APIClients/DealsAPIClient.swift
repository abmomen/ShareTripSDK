//
//  DealsAPIClient.swift
//  URLSessionNetworking
//
//  Created by ST-iOS on 6/28/22.
//

import Foundation

private struct FetchDealsEndPoint: EndPoint {
    var path: String = "/notifications"
    
    private let offset: Int
    private let limit: Int
    
    init(offset: Int, limit: Int) {
        self.offset = offset
        self.limit = limit
    }
    
    var parameters: [String : Any]? {
        return ["offset": offset, "limit": limit]
    }
}


enum DealsAPIClient: GenericAPIClient {
    static func fetchDeals(offset: Int, limit: Int,
                           completion: @escaping (Result<Response<DealResponse?>, NetworkError>) -> Void) {
        let endPoint = FetchDealsEndPoint(offset: offset, limit: limit)
        startRequest(with: endPoint, completion: completion)
    }
    
}
