//
//  IndicatorType.swift
//  STCoreKit
//
//  Created by ST-iOS on 12/4/22.
//

import UIKit

public enum IndicatorType {
    case green, yellow, red, unknown
    
    public var color: UIColor {
        switch self {
        case .green:
            return .midGreen
        case .yellow:
            return .midYellowOrange
        case .red:
            return .appSecondary
        case .unknown:
            return .blueGray
        }
    }
}
