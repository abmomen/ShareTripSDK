//
//  ServiceType.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/20/22.
//

import Foundation

public enum ServiceType: String, Codable {
    case hotel    = "Hotel"
    case flight   = "Flight"
    case tour     = "Tour"
    case transfer = "Transfer"
    case package  = "Package"
    case visa     = "Visa"
    case bus      = "Bus"
    
    public var title: String {
        switch self {
        case .package:
            return "Holiday"
        default:
            return self.rawValue
        }
    }
}
