//
//  FlightBookingHistoryViewModel.swift
//  ShareTrip
//
//  Created by ST-iOS on 5/17/22.
//  Copyright © 2022 ShareTrip. All rights reserved.
//



extension FlightBookingHistoryViewModel {
    class Callback {
        var didFetchHistories: () -> Void = { }
        var didFailed: (String) -> Void = { _ in }
    }
}

class FlightBookingHistoryViewModel {
    private var apiClient = FlightAPIClient()
    public var histories = [FlightBookingHistory]()
    
    public var callback = Callback()
    
    private var offset = 0
    
    public var limit = 10
    public var hasMore = true
    public var isLoading = false
    
    // MARK: - API Helpers
    func fetchFlightBookingHistory() {
        if isLoading { return }
        isLoading = true
        
        let params = ["offset": offset, "limit": limit]
        
        apiClient.fetchFlightBookingHistory(status: nil, params: params) { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let response):
                guard let flightHistories = response.response?.data else {
                    strongSelf.callback.didFailed("History not found")
                    return
                }
                strongSelf.histories.append(contentsOf: flightHistories)
                strongSelf.hasMore = flightHistories.count >= strongSelf.limit
                if flightHistories.count >= strongSelf.limit {
                    strongSelf.offset += (flightHistories.count)
                }
                strongSelf.isLoading = false
                strongSelf.callback.didFetchHistories()
            case .failure(let error):
                strongSelf.isLoading = false
                strongSelf.histories.removeAll()
                strongSelf.callback.didFailed(error.localizedDescription)
            }
        }
    }
}
