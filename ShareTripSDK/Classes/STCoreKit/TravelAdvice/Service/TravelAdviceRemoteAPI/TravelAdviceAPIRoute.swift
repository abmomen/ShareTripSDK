//
//  TravelAdviceAPIRoute.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 11/11/2020.
//  Copyright © 2020 ShareTrip. All rights reserved.
//

import Alamofire

enum TravelAdviceAPIRoute: APIEndpoint {
    case getTravelAdvice(countryCode: String)

    var baseUrl: String { return "https://api.traveladviceapi.com/" }

    var path: String {
        switch self {
            case .getTravelAdvice(let countryCode):
                return "search/\(countryCode)"
        }
    }

    var method: Alamofire.HTTPMethod {
        switch self {
            case .getTravelAdvice:
                return .get
        }
    }

    var parameters: Parameters? {
        switch self {
            case .getTravelAdvice:
                return nil
        }
    }

    // Encode complex key/value objects in URLQueryItem pairs
    private func queryItems(_ key: String, _ value: Any?) -> [URLQueryItem] {
        var result = [] as [URLQueryItem]

        if let dictionary = value as? [String: AnyObject] {
            for (nestedKey, value) in dictionary {
                result += queryItems("\(key)[\(nestedKey)]", value)
            }
        } else if let array = value as? [AnyObject] {
            let arrKey = key
            for value in array {
                result += queryItems(arrKey, value)
            }
        } else if let value = value {
            result.append(URLQueryItem(name: key, value: "\(value)"))
        } else {
            result.append(URLQueryItem(name: key, value: nil))
        }
        return result
    }

    private func paramsToQueryItems(_ params: [String: Any]?) -> [URLQueryItem]? {
        guard let params = params else { return nil }

        var result = [] as [URLQueryItem]

        for (key, value) in params {
            result += queryItems(key, value)
        }
        return result
    }


    /// Default  implementation, you can always provide your own
    func asURLRequest() throws -> URLRequest {
        var urlComponents = URLComponents(string: baseUrl + path)!

        // Parameters
        var httpBody: Data?
        if let parameters = parameters {
            do {
                if method == .get {
                    if let items = paramsToQueryItems(parameters) {
                        urlComponents.queryItems = items
                    }

                } else {
                    //POST
                    httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                }
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        } else if let bodyData = bodyData {
            httpBody = bodyData
        }

        var urlRequest = URLRequest(url: urlComponents.url!)

        // HTTP Method
        urlRequest.httpMethod = method.rawValue

        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        if let contentType = contentType?.rawValue {
            urlRequest.setValue(contentType, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        }

        // Access Token Headers
        urlRequest.setValue("99a8e32b-1938-4b9d-84af-685aae98b0d6", forHTTPHeaderField: HTTPHeaderField.travelAdviceAPIAccessToken.rawValue)

        //httpbody
        urlRequest.httpBody = httpBody

        return urlRequest
    }

    /// Default  implementation, you can always provide your own
    func asURL() throws -> URL {
        let url = URL(string: baseUrl + path)!
        return url
    }
}
