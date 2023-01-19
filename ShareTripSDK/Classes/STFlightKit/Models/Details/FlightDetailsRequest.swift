//
//  FlightDetailsRequest.swift
//  ShareTrip
//
//  Created by ST-iOS on 6/1/22.
//  Copyright © 2022 ShareTrip. All rights reserved.
//

import Foundation

public struct FlightDetailsRequest: Encodable {
    public let searchId: String
    public let sessionId: String
    public let sequenceCode: String
    
    public init(
        searchId: String,
        sessionId: String,
        sequenceCode: String
    ) {
        self.searchId = searchId
        self.sessionId = sessionId
        self.sequenceCode = sequenceCode
    }
    
    public var params: [String: Any] {
        var params = [String: Any]()
        params["searchId"] = searchId
        params["sessionId"] = sessionId
        params["sequenceCode"] = sequenceCode
        return params
    }
}
