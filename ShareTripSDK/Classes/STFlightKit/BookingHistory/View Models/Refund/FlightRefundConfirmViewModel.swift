//
//  ConfirmRefundViewModel.swift
//  ShareTrip
//
//  Created by ST-iOS on 5/18/22.
//  Copyright © 2022 ShareTrip. All rights reserved.
//

import Foundation

extension FlightRefundConfirmViewModel {
    class Callback {
        var didSuccessRefund: () -> Void = { }
        var didFailed: (String) -> Void = { _ in }
    }
}

class FlightRefundConfirmViewModel {
    private let refundSearchId: String
    public let callback = Callback()
    private let apiClient = FlightRefundAPIClient()
    
    init(_ refundSearchId: String) {
        self.refundSearchId = refundSearchId
    }
    
    func confirmRefund() {
        let request = FlightRefundConfirmRequest(refundSearchId: refundSearchId)
        
        apiClient.confirmFlightRefund(request: request) {[weak self] result in
            switch result {
            case .success:
                self?.callback.didSuccessRefund()
                
            case .failure(let error):
                self?.callback.didFailed(error.localizedDescription)
            }
        }
    }
}
