//
//  Covid19TestOptionsRowType.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 23/02/2021.
//  Copyright © 2021 ShareTrip. All rights reserved.
//

import Foundation
import UIKit

public enum Covid19TestOptionsRowType: CaseIterable {
    case testCharge
    case optionSelect
    case learnMore
    
    public var title: String {
        switch self {
        case .optionSelect, .testCharge, .learnMore:
            return ""
        }
    }
    
    public var placeholder: String {
        switch self {
        case .optionSelect, .testCharge, .learnMore:
            return ""
        }
    }
}

