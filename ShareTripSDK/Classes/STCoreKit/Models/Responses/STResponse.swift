//
//  STResponse.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/22/22.
//

import Foundation

public class BaseResponse: Codable {
    public let code: APIResponseCode
    public let message: String
    public let errors: [String]?
    
    private enum CodingKeys: String, CodingKey {
        case code
        case message
        case errors
    }
    
    public required init(from decoder: Decoder) throws {
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

public class Response<T: Decodable>: BaseResponse {
    public let response: T?
    
    private enum CodingKeys: String, CodingKey {
        case response
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.response = try? container.decodeIfPresent(T.self, forKey: .response)
        try super.init(from: decoder)
    }
}

public class ResponseList<T: Codable>: BaseResponse {
    public let response: [T]?
    
    private enum CodingKeys: String, CodingKey {
        case response
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.response = try container.decodeIfPresent([T].self, forKey: .response)
        try super.init(from: decoder)
    }
}

public class PackageBookingResponse: Codable {
    public let url: String
}

public class FlightBookingResponse: BaseResponse {
    public var response: String?
    public var newResponse: BookingUrlResponse?
    
    private enum CodingKeys: String, CodingKey {
        case response
    }
    
    public required init(from decoder: Decoder) throws {
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

public struct BookingUrlResponse: Decodable {
    public let paymentUrl, successUrl, cancelUrl, declineUrl: String?
}

public class UploadFileResponse: Codable {
    public let path: String
}

public class ShareResponse: BaseResponse {
    public let response: String
    
    private enum CodingKeys: String, CodingKey {
        case response
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.response = try container.decodeIfPresent(String.self, forKey: .response) ?? "0"
        try super.init(from: decoder)
    }
    
    public var earnedCoin: Int {
        return Int(response) ?? 0
    }
}
