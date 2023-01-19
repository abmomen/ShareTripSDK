//
//  ObservableProtocol.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/22/22.
//

import Foundation

public protocol ObservableProtocol {
    associatedtype T
    typealias Observer = (T) -> Void
    var value: T { get set }
    
    func bind(observer: @escaping Observer)
    func bindAndFire(observer: @escaping Observer)
}
