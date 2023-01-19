//
//  FlightVoidConfirmViewModel.swift
//  ShareTrip
//
//  Created by ST-iOS on 5/18/22.
//  Copyright © 2022 ShareTrip. All rights reserved.
//

import Foundation

extension FlightVoidConfirmViewModel {
    class Callback {
        var didSuccessVoid: () -> Void = { }
        var didFailed: (String) -> Void = { _ in }
    }
}

class FlightVoidConfirmViewModel {
    private let voidSearchId: String
    
    init(_ voidSearchId: String) {
        self.voidSearchId = voidSearchId
    }
    
    public let callback = Callback()
    private let apiClient = FlightRefundAPIClient()
    
    func confirmVoid() {
        let request = FlightVoidConfirmRequest(voidSearchId: voidSearchId)
        
        apiClient.confirmVoid(request: request) {[weak self] result in
            switch result {
            case .success:
                self?.callback.didSuccessVoid()
                
            case .failure(let error):
                self?.callback.didFailed(error.localizedDescription)
            }
        }
    }
}
