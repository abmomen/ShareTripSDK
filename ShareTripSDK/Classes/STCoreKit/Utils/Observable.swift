//
//  Observable.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/22/22.
//

import Foundation

public final class Observable<T>: ObservableProtocol {
    public typealias Observer = (T) -> Void
    
    public var observer: Observer?
    
    public var value: T {
        didSet {
            observer?(value)
        }
    }
    
    public init(_ value: T) {
        self.value = value
    }
    
    public func bind(observer: @escaping Observer) {
        self.observer = observer
    }
    
    public func bindAndFire(observer: @escaping Observer) {
        self.observer = observer
        observer(value)
    }
}

public final class Observables {
    public static func combineLatest<U, V>(_ a: Observable<U>, _ b: Observable<V>, _ callBack: @escaping (U, V) -> Void) {
        a.bind(observer: { _ in
            callBack(a.value, b.value)
        })
        
        b.bind(observer: { _ in
            callBack(a.value, b.value)
        })
    }
    
    public static func combineLatest<U, V, W>(_ a: Observable<U>, _ b: Observable<V>, _ c: Observable<W>, _ callBack: @escaping (U, V, W) -> Void) {
        a.bind(observer: { _ in
            callBack(a.value, b.value, c.value)
        })
        
        b.bind(observer: { _ in
            callBack(a.value, b.value, c.value)
        })
        
        c.bind(observer: { _ in
            callBack(a.value, b.value, c.value)
        })
    }
}
