//
//  MyBLHomeViewModel.swift
//  ShareTripSDK
//
//  Created by ST-iOS on 1/24/23.
//

import Foundation

extension MyBLHomeViewModel {
    enum Sections {
        case features
        case adds
        case deals
    }
}

extension MyBLHomeViewModel {
    class Callbacks {
        var didSuccess: () -> Void = { }
        var didFailed: (String) -> Void = { _ in }
    }
}

class MyBLHomeViewModel {
    
    let secions: [Sections] = [.features, .deals]
    
    private(set) var deals: [NotifierDeal] = []
    
    var callbacks = Callbacks()
    private var offset = 0
    private let limit = 10
    
    func fetchDeals() {
        if offset != 0 && offset == deals.count { return }
        self.offset = deals.count
        
        DealsAPIClient.fetchDeals(offset: offset, limit: limit) {[weak self] result in
            switch result {
            case .success(let success):
                guard let response = success.response else {
                    self?.callbacks.didFailed("Response is not available")
                    return
                }
                self?.deals.append(contentsOf: response?.data ?? [])
                self?.callbacks.didSuccess()
                
            case .failure(let failure):
                self?.callbacks.didFailed(failure.description)
            }
        }
    }
    
}
