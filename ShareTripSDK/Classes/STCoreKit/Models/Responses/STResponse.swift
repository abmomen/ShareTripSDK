//
//  STResponse.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/22/22.
//

import Foundation

class BaseResponse: Codable {
    let code: APIResponseCode
    let message: String
    let errors: [String]?
    
    private enum CodingKeys: String, CodingKey {
        case code
        case message
        case errors
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.message = try container.decodeIfPresent(String.self, forKey: .message) ?? "Successfull"
        let errors = try? container.decodeIfPresent([String].self, forKey: .errors)
        self.errors = errors
        let code = try container.decodeIfPresent(APIResponseCode.self, forKey: .code)
        
        if let code = code {
            self.code = code
        } else if errors != nil {
            self.code = .unknown
        } else {
            self.code = .success
        }
    }
}

class Response<T: Decodable>: BaseResponse {
    let response: T?
    
    private enum CodingKeys: String, CodingKey {
        case response
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.response = try? container.decodeIfPresent(T.self, forKey: .response)
        try super.init(from: decoder)
    }
}

class ResponseList<T: Codable>: BaseResponse {
    let response: [T]?
    
    private enum CodingKeys: String, CodingKey {
        case response
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.response = try container.decodeIfPresent([T].self, forKey: .response)
        try super.init(from: decoder)
    }
}

class PackageBookingResponse: Codable {
    let url: String
}

class FlightBookingResponse: BaseResponse {
    var response: String?
    var newResponse: BookingUrlResponse?
    
    private enum CodingKeys: String, CodingKey {
        case response
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let strResp = try? container.decodeIfPresent(String.self, forKey: .response) {
            self.response = strResp
        } else {
            let objResp = try? container.decodeIfPresent(BookingUrlResponse.self, forKey: .response)
            self.newResponse = objResp
        }
        try super.init(from: decoder)
    }
}

struct BookingUrlResponse: Decodable {
    let paymentUrl, successUrl, cancelUrl, declineUrl: String?
}

class UploadFileResponse: Codable {
    let path: String
}

class ShareResponse: BaseResponse {
    let response: String
    
    private enum CodingKeys: String, CodingKey {
        case response
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.response = try container.decodeIfPresent(String.self, forKey: .response) ?? "0"
        try super.init(from: decoder)
    }
    
    var earnedCoin: Int {
        return Int(response) ?? 0
    }
}
