//
//  PaymentGateWayFilterProvider.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/22/22.
//

import Foundation


public protocol PaymentGateWayFilterProvider {
    func paymentGateWayfilter() -> ((PaymentGateway) -> Bool)
    func paymentGateWayfilter(gatewayIds: [String]) -> ((PaymentGateway) -> Bool)
    func paymentGateWayfilter(gatewayCodes: [String]) -> ((PaymentGateway) -> Bool)
}

public extension PaymentGateWayFilterProvider {
    func paymentGateWayfilter(gatewayIds: [String]) -> ((PaymentGateway) -> Bool) {
        return { gateway in return gatewayIds.contains(gateway.id ?? "") }
    }
    
    func paymentGateWayfilter(gatewayCodes: [String]) -> ((PaymentGateway) -> Bool) {
        return { gateway in return gatewayCodes.contains(gateway.code ?? "") }
    }
}
