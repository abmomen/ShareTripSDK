//
//  SSRCodes.swift
//  STFlightKit
//
//  Created by ST-iOS on 11/20/22.
//

import Foundation

// MARK: - Response
public struct SSRType: Codable {
    public let type: String
    public let ssr: [SSR]
}

// MARK: - SSR
public struct SSR: Codable {
    public let code, name: String
}
