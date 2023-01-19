//
//  RevalidatePrice.swift
//  STFlightKit
//
//  Created by ST-iOS on 11/20/22.
//



public struct FlightRevalidationRequest: Codable {
    public var searchId: String
    public var sequenceCode: String
    public var sessionId: String
    
    public var params: [String: Any] {
        var params = [String: Any]()
        params["searchId"] = searchId
        params["sessionId"] = sessionId
        params["sequenceCode"] = sequenceCode
        return params
    }
    
    public init(searchId: String, sequenceCode: String, sessionId: String) {
        self.searchId = searchId
        self.sequenceCode = sequenceCode
        self.sessionId = sessionId
    }
}

// MARK: - Response
public struct FlightRevalidationResponse: Codable {
    public let points: Points
    public let priceBreakdown: FlightPriceBreakdown
}
