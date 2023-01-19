//
//  FlightVoidQuotationViewModel.swift
//  ShareTrip
//
//  Created by ST-iOS on 5/18/22.
//  Copyright © 2022 ShareTrip. All rights reserved.
//

import Foundation

extension FlightVoidQuotationViewModel {
    class Callback {
        var didFetchVoidQuotations: () -> Void = { }
        var didFailed: (String) -> Void = { _ in }
    }
}

enum VoidQuotationRows: CaseIterable {
    case airfareAmount
    case airlineCharge
    case stCharge
    case totalCharge
    case dividerLine
    case totalVoidAmount
    
    var title: String {
        switch self {
        case .airfareAmount:
            return "Airfare Amount"
        case .airlineCharge:
            return "Airline Charge"
        case .stCharge:
            return "ST Convenience Fee"
        case .totalCharge:
            return "Total Void Charge"
        case .totalVoidAmount:
            return "Amount To Be Void"
        case .dividerLine:
            return ""
        }
    }
}

class FlightVoidQuotationViewModel {
    var searchId = ""
    var bookingCode = ""
    var voidSearchId = ""
    
    public let callback = Callback()
    private let apiClient = FlightRefundAPIClient()
    
    var sections = VoidQuotationRows.allCases
    
    public var voidQuotationResponse: FlightVoidQuotationResponse? {
        didSet {
            voidSearchId = voidQuotationResponse?.voidSearchID ?? ""
        }
    }
    
    private var totalAmount: Int {
        return voidQuotationResponse?.purchasePrice ?? 0
    }
    
    private var airlineCharge: Int {
        return -1 * (voidQuotationResponse?.airlineVoidCharge ?? 0)
    }
    
    private var stCharge: Int {
        return -1 * (voidQuotationResponse?.stVoidCharge ?? 0)
    }
    
    private var totalCharge: Int {
        return -1 * (voidQuotationResponse?.totalFee ?? 0)
    }
    
    private var totalRefundableAmount: Int {
        return voidQuotationResponse?.totalReturnAmount ?? 0
    }
    
    func getAmount(for rowType: VoidQuotationRows) -> Double {
        switch rowType {
        case .airfareAmount:
            return Double(totalAmount)
        case .airlineCharge:
            return Double(airlineCharge)
        case .stCharge:
            return Double(stCharge)
        case .totalCharge:
            return Double(totalCharge)
        case .totalVoidAmount:
            return Double(totalRefundableAmount)
        default:
            return 0.0
        }
    }
    
    
    func fetchVoidQuotations() {
        let request = FlightVoidQuotationRequest(searchId: searchId, bookingCode: bookingCode)
        
        apiClient.getVoidQuotations(request: request) {[weak self] result in
            switch result {
            case .success(let response):
                guard let quotation = response.response else {
                    self?.callback.didFailed("Failed to load quotations")
                    return
                }
                self?.voidQuotationResponse = quotation
                self?.callback.didFetchVoidQuotations()
                
            case .failure(let error):
                self?.callback.didFailed(error.localizedDescription)
            }
        }
    }
}
