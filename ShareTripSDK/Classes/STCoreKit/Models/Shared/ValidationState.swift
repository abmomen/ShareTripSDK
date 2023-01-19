//
//  ValidationState.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/20/22.
//

import UIKit

public enum ValidationState {
    case normal
    case active
    case warning(String)
    
    public var color: UIColor {
        switch self {
        case .normal:
            return .lightGray
        case .active:
            return .appPrimary
        case .warning:
            return .orangeyRed
        }
    }
}
