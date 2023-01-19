//
//  PaymentGatewaysViewModel.swift
//  ShareTrip
//
//  Created by Md Khaled Hasan Manna on 16/6/22.
//  Copyright © 2022 ShareTrip. All rights reserved.
//

public extension PaymentGatewaysViewModel {
    class Callback {
        public var didFetchPaymentGateways: (([PaymentGateway]) -> Void) = { _ in }
        public var onPaymentGatewayFetchingFailed: ((String) -> Void) = { _ in }
    }
}

public class PaymentGatewaysViewModel {
    
    public let callBack = Callback()
    private var filter: ((PaymentGateway) -> Bool)?
    private var allPaymentGateways = [PaymentGateway]()
    private let serviceType: PaymentGatewayType
    private let currency: String
    
    public init(_ serviceType: PaymentGatewayType, _ currency: String) {
        self.serviceType = serviceType
        self.currency = currency
    }
    
    private var paymentGateways: [PaymentGateway] {
        guard let filter = filter else { return [] }
        return allPaymentGateways.filter(filter)
    }
    
    public func filterPaymentGateways(filter: @escaping (PaymentGateway) -> Bool) {
        self.filter = filter
    }
    
    public func fetchPaymentGateways() {
        var params = [String: Any]()
        params["service"] = self.serviceType.rawValue
        params["currency"] = self.currency
        
        DefaultAPIClient().fetchPaymentGateways(params: params) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.code == APIResponseCode.success,
                   let paymentGateways = response.response,
                   paymentGateways.count > 0 {
                    self.allPaymentGateways = paymentGateways
                    self.callBack.didFetchPaymentGateways(paymentGateways)
                } else {
                    self.callBack.onPaymentGatewayFetchingFailed(response.message)
                    STLog.error(response.message)
                }
            case .failure(let error):
                self.callBack.onPaymentGatewayFetchingFailed(error.localizedDescription)
                STLog.error(error.localizedDescription)
            }
        }
    }
}
