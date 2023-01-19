//
//  APIClient.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/22/22.
//

import UIKit
import Alamofire

public protocol APIClient {
    func performRequest<T:Decodable>(
        route: APIEndpoint,
        decoder: JSONDecoder,
        completion:@escaping (AFResult<T>)->Void) -> DataRequest
    
    func uploadRequest<T:Decodable>(
        route: APIRouter,
        decoder: JSONDecoder,
        completion:@escaping (AFResult<T>)->Void) -> UploadRequest
}

public extension APIClient {
    private func logResponse<T: Decodable>(_ response: DataResponse<T, AFError>) {
#if (DEBUG || PRODUCTION)
        STLog.info("")
        print("\nRequest Details:")
        if let urlRequest = response.request {
            print("URL: \(String(describing: urlRequest.url))")
            if let method = urlRequest.method {
                print("Request Method: \(method.rawValue)")
            }
            print("Header:\n \(urlRequest.headers)")
            
            if let bodyData = urlRequest.httpBody?.prettyPrintedJSONString {
                print("Body Data:\n \(bodyData)")
            }
        }
        print("\nResponse Details:")
        print("Status Code: \(String(describing: response.response?.statusCode)) \nResult: \(response.result)")
        if let responseData = response.data?.prettyPrintedJSONString {
            print("Response Data:\n \(responseData)")
        }
#endif
    }
    
    @discardableResult
    func performRequest<T: Decodable>(route: APIEndpoint, decoder: JSONDecoder = JSONDecoder(), completion:@escaping (AFResult<T>)->Void) -> DataRequest {
        
        return AF.request(route).responseDecodable(decoder: decoder) { (response: DataResponse<T, AFError>) in
            logResponse(response)
            completion(response.result)
        }
    }
    
    @discardableResult
    func uploadRequest<T:Decodable>(route:APIRouter, decoder: JSONDecoder = JSONDecoder(), completion:@escaping (AFResult<T>)->Void) -> UploadRequest {
        
        var headers: Alamofire.HTTPHeaders = Alamofire.HTTPHeaders()
        if let accessToken = STUserSession.current.authToken?.accessToken, accessToken.count > 0 {
            headers.add(name: HTTPHeaderField.accessToken.rawValue, value: accessToken)
        }
        
        return AF.upload(multipartFormData: { multiPart in
            
            if let imageDataTuple = route.imageDataTuple {
                multiPart.append(imageDataTuple.1, withName: imageDataTuple.0, fileName: "file.png", mimeType: "image/png")
            }
            
            if let parameters = route.parameters {
                
                for (key, value) in parameters {
                    
                    if let image = value as? UIImage {
                        //Compress image here
                        if let data = image.jpegData(compressionQuality: 0.7) {
                            STLog.info("Image Data size: \(data.count/1024) KB")
                            multiPart.append(data, withName: key, fileName: "image.jpeg", mimeType: "image/jpeg")
                            
                        }
                    } else if let temp = value as? String {
                        multiPart.append(temp.data(using: .utf8)!, withName: key)
                    } else if let temp = value as? Int {
                        multiPart.append("\(temp)".data(using: .utf8)!, withName: key)
                    } else if let temp = value as? NSArray {
                        temp.forEach({ element in
                            let keyObj = key + "[]"
                            if let string = element as? String {
                                multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                            } else {
                                if let data = "\(value)".data(using: .utf8) {
                                    multiPart.append(data, withName: keyObj)
                                }
                            }
                        })
                    } else {
                        if let data = "\(value)".data(using: .utf8) {
                            multiPart.append(data, withName: key)
                        }
                    }
                }
            }
            
        }, to: route, headers: headers).responseDecodable (decoder: decoder){ (response: DataResponse<T, AFError>) in
            
            STLog.info("statusCode: \(response.response?.statusCode ?? 0)")
            if let responseData = response.data {
                STLog.info(responseData.toString() ?? "")
            }
            completion(response.result)
        }
    }
}
