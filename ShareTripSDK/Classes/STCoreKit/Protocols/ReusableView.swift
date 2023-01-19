//
//  ReusableView.swift
//  STCoreKit
//
//  Created by ST-iOS on 12/4/22.
//

import UIKit

public protocol ReusableView {
    static var reuseID: String { get }
}

public extension ReusableView {
    static var reuseID: String {
        return String(describing: Self.self)
    }
}

