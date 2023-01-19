//
//  RefundQuotationViewModel.swift
//  ShareTrip
//
//  Created by ST-iOS on 5/18/22.
//  Copyright © 2022 ShareTrip. All rights reserved.
//

import Foundation

extension RefundQuotationViewModel {
    class Callback {
        var didFetchRefundQuotations: () -> Void = { }
        var didFailed: (String) -> Void = { _ in }
    }
}

enum RefundQuotationRows: CaseIterable {
    case totalAmount
    case airlineCharge
    case stCharge
    case totalCharge
    case dividerLine
    case totalRefundable
    case travellerDetails
    
    var title: String {
        switch self {
        case .totalAmount:
            return "Refund Applicable Amount"
        case .airlineCharge:
            return "Airline Penalty Amount"
        case .stCharge:
            return "ST Convenience Fee"
        case .totalCharge:
            return "Total Refund Charge"
        case .dividerLine:
            return ""
        case .totalRefundable:
            return "Amount to be refunded"
        case .travellerDetails:
            return "Traveller(s) Details"
        }
    }
}

struct RefundFlightInfo {
    let searchId: String
    let bookingCode: String
    let selectedTravellers: [RefundableTraveller]
}

class RefundQuotationViewModel {
    let callback = Callback()
    private let bookingInfo: RefundFlightInfo
    private let apiClient = FlightRefundAPIClient()
    
    init(_ bookingInfo: RefundFlightInfo) {
        self.bookingInfo = bookingInfo
    }
    
    var refundSearchId = ""
    var sections = RefundQuotationRows.allCases
    
    public var refundQuotationResponse: RefundQuotationCheckResponse? {
        didSet {
            refundSearchId = refundQuotationResponse?.refundSearchID ?? ""
        }
    }
    
    var selectedTravellers: [RefundableTraveller] {
        return bookingInfo.selectedTravellers
    }
    
    private var totalAmount: Double {
        return refundQuotationResponse?.purchasePrice ?? 0.0
    }
    
    private var airlineCharge: Double {
        return -1 * (refundQuotationResponse?.airlineRefundCharge ?? 0.0)
    }
    
    private var stCharge: Double {
        return -1 * (refundQuotationResponse?.stFee ?? 0.0)
    }
    
    private var totalCharge: Double {
        return -1 * (refundQuotationResponse?.totalFee ?? 0.0)
    }
    
    private var totalRefundableAmount: Double {
        return refundQuotationResponse?.totalRefundAmount ?? 0.0
    }
    
    private func getSelectedTravellersEtickets() -> [String] {
        var eTickets = [String]()
        bookingInfo.selectedTravellers.forEach { traveller in
            eTickets.append(traveller.eTicket)
        }
        return eTickets
    }
    
    func getAmount(for rowType: RefundQuotationRows) -> Double {
        switch rowType {
        case .airlineCharge:
            return airlineCharge
        case .stCharge:
            return stCharge
        case .totalCharge:
            return totalCharge
        case .totalAmount:
            return totalAmount
        case .totalRefundable:
            return totalRefundableAmount
        default:
            return 0.0
        }
    }
    
    func fetchRefundQuotation() {
        let request = FlightRefundQuotationRequest(
            bookingCode: bookingInfo.bookingCode,
            searchId: bookingInfo.searchId,
            eTickets: getSelectedTravellersEtickets()
        )
        
        apiClient.getRefundQuotations(request: request) {[weak self] result in
            switch result {
            case .success(let response):
                guard let quotation = response.response else {
                    self?.callback.didFailed("Failed to load quotations")
                    return
                }
                self?.refundQuotationResponse = quotation
                self?.callback.didFetchRefundQuotations()
            
            case .failure(let error):
                self?.callback.didFailed(error.localizedDescription)
            }
        }
    }
    
    
}
