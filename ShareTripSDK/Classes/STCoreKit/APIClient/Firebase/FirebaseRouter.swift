//
//  FirebaseRouter.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 07/10/2019.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import Alamofire

public enum FirebaseRouter: APIEndpoint {
    case tnc
    case faq
    case dealsAndUpdateFromNotifier(params: Parameters?)
    case updateFirebaseToken(bodyData: Data)
    case fetchAvailabelCoupons(service: ServiceType)
    
    public var baseUrl: String { return "https://sharetrip-96054.firebaseio.com" }
    public var notifierBaseUrl: String { return "https://notifier.sharetrip.net/api/v1"}
    
    public var path: String {
        switch self {
        case .tnc:
            return baseUrl + "/flight_admin/toc.json"
        case .faq:
            return baseUrl + "/flight_admin/faq.json"
        case .dealsAndUpdateFromNotifier:
            return notifierBaseUrl + "/notifications"
        case .updateFirebaseToken:
            return notifierBaseUrl + "/token"
        case .fetchAvailabelCoupons:
            return notifierBaseUrl + "/coupon"
        }
    }
    
    public var parameters: Parameters? {
        switch self {
        case .fetchAvailabelCoupons(let service):
            var params = [String: Any]()
            params["service"] = service.rawValue.lowercased()
            return params
        case .dealsAndUpdateFromNotifier(let params):
            return params
        default:
            return nil
        }
    }
    
    public var method: Alamofire.HTTPMethod {
        switch self {
        case .updateFirebaseToken:
            return .post
        default:
            return .get
        }
    }
    
    public var bodyData: Data? {
        switch self {
        case .updateFirebaseToken(let data):
            return data
        default:
            return nil
        }
    }
    
    public var contentType: ContentType? {
        return .json
    }
    
    public func asURLRequest() throws -> URLRequest {
        var httpBody: Data?
        if let bodyData = bodyData {
            httpBody = bodyData
        }
        
        var urlComponents = URLComponents(string: path)!
        
        if let items = paramsToQueryItems(parameters) {
            urlComponents.queryItems = items
        }
        
        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = httpBody
        return urlRequest
    }

    /// Default  implementation, you can always provide your own
    public func asURL() throws -> URL {
        return URL(string: path)!
    }
}
