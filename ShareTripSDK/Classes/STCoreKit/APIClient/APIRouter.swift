//
//  APIRouter.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/22/22.
//

import Alamofire

public enum APIRouter: APIEndpoint {
    case updateAvater(imageData: Data)
    case appVersion
    
    //travel-review
    case travelReviewCity
    case submitReviewCity(cityCode: String, wantToVisit: Bool)
    
    //Others
    case uploadFile(imageData: Data)
    case uploadVisaFile(imageData: Data)
    case getShareLink(params: Parameters)
    case paymentGateway(params: Parameters)
    
    // MARK: - HTTPMethod
    public var method: Alamofire.HTTPMethod {
        switch self {
        case .updateAvater:
            return .post
        case .appVersion:
            return .get
            
            //travel-review
        case .travelReviewCity:
            return .get
        case .submitReviewCity:
            return .post
            
            //Others
        case .uploadFile:
            return .post
        case .uploadVisaFile:
            return .post
        case .getShareLink:
            return .post
        case .paymentGateway:
            return .get
        }
    }
    
    // MARK:- Path
    public var path: String {
        switch self {
        case .updateAvater:
            return "/user/update-avatar"
        case .appVersion:
            return "/version"
            
            //travel-review
        case .travelReviewCity:
            return "/travel-review/cities"
        case .submitReviewCity:
            return "/travel-review/decision"
            
            //Others
        case .uploadFile:
            return "/upload-file"
        case .uploadVisaFile:
            return "/visa/booking/upload"
        case .getShareLink:
            return "/get-share-link"
        case .paymentGateway:
            return "/payment/gateway"
        }
    }
    
    // MARK: - Parameters
    public var parameters: Parameters? {
        switch self {
        case .updateAvater:
            return nil
        case .appVersion:
            return nil
            
            //travel-review
        case .travelReviewCity:
            return nil
        case .submitReviewCity(let cityCode, let wantToVisit):
            return [Constants.APIParameterKey.cityCode: cityCode, Constants.APIParameterKey.wantToVisit: (wantToVisit ? "Yes" : "No")]
            
            //Others
        case .uploadFile:
            return nil
        case .uploadVisaFile:
            return nil
        case .getShareLink(let params):
            return params
        case .paymentGateway(let params):
            return params
        }
    }
    
    public var imageDataTuple: (String, Data)? {
        switch self {
        case .updateAvater(let data):
            return (Constants.APIParameterKey.uploadFile, data)
        case .uploadFile(let data):
            return (Constants.APIParameterKey.uploadFile, data)
        case .uploadVisaFile(let data):
            return (Constants.APIParameterKey.uploadFile, data)
        default:
            return nil
        }
    }
    
    // MARK: - bodyData
    public var bodyData: Data? {
        switch self {
        default:
            return nil
        }
    }
    
    //MARK: ContentType
    public var contentType: ContentType? {
        switch self {
        case .updateAvater, .uploadFile, .uploadVisaFile:
            return nil
        default:
            return .json
        }
    }
}
