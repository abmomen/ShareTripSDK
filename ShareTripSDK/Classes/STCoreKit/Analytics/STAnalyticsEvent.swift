//
//  STAnalyticsEvent.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/20/22.
//

import FirebaseAnalytics

public protocol STAnalyticsType {}

public protocol STAnalyticsEvent {
    typealias Payload = [String: STAnalyticsType]
    var name: String { get }
    var payload: Payload? { get }
}

public protocol STAnalyticsEngine {
    func log(_ event: STAnalyticsEvent)
}

public class FirebaseAnalyticsEngine: STAnalyticsEngine {
    public init() { }
    
    public func log(_ event: STAnalyticsEvent) {
        Analytics.logEvent(
            event.name,
            parameters: event.payload
        )
    }
}

open class AnalyticsManager {
    private var engines: [STAnalyticsEngine] = []
    public init(_ engines: [STAnalyticsEngine]) {
        self.engines = engines
    }
    
    public func log(_ event: STAnalyticsEvent) {
        engines.forEach { engine in
            engine.log(event)
        }
    }
}

extension String: STAnalyticsType {}
extension Int: STAnalyticsType {}
extension UInt: STAnalyticsType {}
extension Double: STAnalyticsType {}
extension Float: STAnalyticsType {}
extension Bool: STAnalyticsType {}
extension Date: STAnalyticsType {}
extension URL: STAnalyticsType {}
extension NSNull: STAnalyticsType {}
extension Array: STAnalyticsType {}
extension Dictionary: STAnalyticsType {}
