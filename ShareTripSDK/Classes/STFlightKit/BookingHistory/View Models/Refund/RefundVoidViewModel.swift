//
//  RefundVoidViewModel.swift
//  ShareTrip
//
//  Created by ST-iOS on 5/10/22.
//  Copyright © 2022 ShareTrip. All rights reserved.
//

import Foundation

extension RefundVoidViewModel {
    class Callback {
        var didFetchEligibleTravellers: () -> Void = { }
        var didFetchRefundQuotations: () -> Void = { }
        var didSuccessRefund: () -> Void = { }
        
        var didFetchVoidQuotations: () -> Void = { }
        var didSuccessVoid: () -> Void = { }
        var didChangeSelection: () -> Void = { }
        
        var didFailed: (String) -> Void = { _ in }
    }
}

class RefundVoidViewModel {
    public let callback = Callback()
    private let apiClient = FlightRefundAPIClient()
    
    let searchId: String
    let bookingCode: String
    var refundSearchId = ""
  
    
    public var refundableTravellers = [RefundableTraveller]()
    private var selectedTravellers: Set<RefundableTraveller> = []
    
    init(searchId: String, bookingCode: String) {
        self.searchId = searchId
        self.bookingCode = bookingCode
    }

    func selectTraveller(traveller: RefundableTraveller) {
        selectedTravellers.insert(traveller)
        
        for passenger in refundableTravellers {
            if let travellerAssociatedPax = traveller.paxAssociated {
                if passenger.paxNumber.lowercased().elementsEqual(travellerAssociatedPax.lowercased()) {
                    selectedTravellers.insert(passenger)
                }
            }
            
            if let associatedPax = passenger.paxAssociated {
                if traveller.paxNumber.lowercased().elementsEqual(associatedPax.lowercased()) {
                    selectedTravellers.insert(passenger)
                }
            }
        }
        callback.didChangeSelection()
    }
    
    func deSelectTraveller(traveller: RefundableTraveller) {
        selectedTravellers.remove(traveller)
        
        for passenger in refundableTravellers {
            if let travellerPaxAssociated = traveller.paxAssociated {
                if passenger.paxNumber.lowercased().elementsEqual(travellerPaxAssociated.lowercased()) {
                    selectedTravellers.remove(passenger)
                }
            }
            
            if let associatedPax = passenger.paxAssociated {
                if traveller.paxNumber.lowercased().elementsEqual(associatedPax.lowercased()) {
                    selectedTravellers.remove(passenger)
                }
            }
        }
        callback.didChangeSelection()
    }
    
    func selectAllTravellers() {
        deSelectAllTravellers()
        for traveller in refundableTravellers {
            selectedTravellers.insert(traveller)
        }
        callback.didChangeSelection()
    }
    
    func deSelectAllTravellers() {
        selectedTravellers.removeAll()
        callback.didChangeSelection()
    }
    
    func isSelectedTraveller(traveller: RefundableTraveller) -> Bool {
        return selectedTravellers.contains(traveller)
    }
    
    func getSelectedTravellers() -> [RefundableTraveller] {
        return Array(selectedTravellers)
    }
    
    func getQuotationViewModel() -> RefundQuotationViewModel {
        let bookingInfo = RefundFlightInfo(
            searchId: searchId,
            bookingCode: bookingCode,
            selectedTravellers: getSelectedTravellers()
        )
        return RefundQuotationViewModel(bookingInfo)
    }
    
    // MARK: - Refund APIs
    func fetchRefundEligibleTravellers() {
        let request = FlightRefundEligibleTravellersRequest(
            bookingCode: bookingCode,
            searchId: searchId
        )
        apiClient.fetchEligibleTravellers(request: request) {[weak self] result in
            switch result {
            case .success(let response):
                let travellers = response.response?.travellers ?? []
                self?.refundableTravellers = travellers
                self?.callback.didFetchEligibleTravellers()
                
            case .failure(let error):
                self?.callback.didFailed(error.localizedDescription)
            }
        }
    }
}

