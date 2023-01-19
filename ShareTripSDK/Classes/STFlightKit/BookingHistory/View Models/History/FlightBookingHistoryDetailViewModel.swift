//
//  FlightBookingHistoryDetailViewModel.swift
//  ShareTrip
//
//  Created by ST-iOS on 5/17/22.
//  Copyright © 2022 ShareTrip. All rights reserved.
//



struct PaymentUrls {
    var paymentURL: String = ""
    var successUrl: String? = nil
    var failureUrl: String? = nil
}

extension FlightBookingHistoryDetailViewModel {
    class Callback {
        var didRetryBooking: (PaymentUrls) -> Void = { _ in }
        var didResendVoucher: () -> Void = { }
        var didCancelFlight: () -> Void = { }
        var didFailed: (String) -> Void = { _ in }
    }
}

class FlightBookingHistoryDetailViewModel {
    let history: FlightBookingHistory
    var sections = [[FlightBookingHistoryCellTypes]]()
    
    var callback = Callback()
    
    var bookingCode: String {
        return history.bookingCode ?? ""
    }
    
    var searchId: String {
        return history.searchId ?? ""
    }
    
    var paymentStatus: PaymentStatus {
        return history.paymentStatus
    }
    
    var bookingStatus: FlightBookingStatus {
        return history.bookingStatus
    }
    
    var luggageAmount: Double {
        return history.luggageAmount ?? 0.0
    }
    
    var covidAmount: Double {
        return history.covidAmount ?? 0.0
    }
    
    var travelInsuranceAmount: Double {
        return history.travelInsuranceAmount ?? .zero
    }
    
    var baggage: Baggage? {
        return history.baggage
    }
    
    var pnrCode: String {
        return history.pnrCode ?? ""
    }
    
    var isRefundable: Bool {
        return history.isRefundable ?? false
    }
    
    var isVoidable: Bool {
        return history.isVoidable ?? false
    }
    
    init(of history: FlightBookingHistory) {
        self.history = history
        setupSections()
    }
    
    private func setupSections() {
        var firstSection: [FlightBookingHistoryCellTypes] = [.detail, .weight]
        
        // Inactive for now.
        
        /*
        if isRefundable {
            firstSection.append(.refund)
        }

        if isRefundable {
            firstSection.append(.void)
        }
        */
        
        if history.bookingStatus == .booked
            && history.paymentStatus == .unpaid {
            firstSection.append(contentsOf: [.retryInfo, .retryBooking])
        }
        
        if (history.bookingStatus == .booked || history.bookingStatus == .issued)
            && history.paymentStatus == .paid {
            firstSection.append(.resendVoucher)
        }
        
        if history.bookingStatus == .booked {
            firstSection.append(.cancelBooking)
        }
        
        var secondSection: [FlightBookingHistoryCellTypes] = [.info, .traveler, .price]
        
        if history.bookingStatus == .pending
            || history.bookingStatus == .booked
            || history.bookingStatus == .issued {
            secondSection.append(contentsOf: [.baggage, .fareDetail, .cancelationPolicy])
        }
        
        secondSection.append(.supportCenter)
        
        sections.append(firstSection)
        sections.append(secondSection)
    }
    
    func getTravellerInfo() -> [TravellerInfo] {
        return history.travellers
    }
    
    func getPriceInfoViewModel() -> PriceTableViewModel {
        var rowDatas =  [PriceInfoFareCellData]()
        for detail in history.priceBreakdown.details {
            if detail.numberPaxes > 0 {
                let title = "Traveller: \(detail.type.rawValue) x \(detail.numberPaxes)"
                let fareTitle = "Base Fare x \(detail.numberPaxes)"
                let taxTitle = "Taxes & Fees x \(detail.numberPaxes)"
                let cellData = PriceInfoFareCellData(title: title, fareTitle: fareTitle, fareAmount: detail.baseFare * Double(detail.numberPaxes), taxTitle: taxTitle, taxAmount: detail.tax * Double(detail.numberPaxes))
                rowDatas.append(cellData)
            }
        }
        
        let priceInfoTableData = PriceInfoTableData(
            originPrice: history.priceBreakdown.originPrice,
            totalPrice: history.priceBreakdown.total,
            discount: history.priceBreakdown.discountAmount,
            rowDatas: rowDatas,
            baggagePrice: luggageAmount,
            covid19TestPrice: covidAmount,
            travelInsuraceCharge: travelInsuranceAmount,
            advanceIncomeTax: history.advanceIncomeTax ?? 0,
            couponsDiscount: history.priceBreakdown.couponAmount
        )
        
        let convenienceFee = HistoryConvenienceFee(convenienceFee: history.convenienceFee ?? 0.0)
        
        return PriceTableViewModel(priceInfoTableData: priceInfoTableData, serviceType: .flight, historyConvenienceFee: convenienceFee)
    }
    
    func getTripcoinInfo() -> PaymentWebVC.TripCoinInfo {
        return PaymentWebVC.TripCoinInfo(
            earn: history.points.earning,
            redeem: history.points.earning,
            share: history.points.shared
        )
    }
    
    func getBaggageHtmlString() -> String {
        if let baggageInfos = history.baggageInfo {
            var htmlString = ""
            
            for baggageInfo in baggageInfos {
                htmlString.append("<h2>" + baggageInfo.type + "</h2>")
                
                if let adult  = baggageInfo.adult {
                    htmlString.append("<h3>Adult: " + adult + "</h3>")
                }
                
                if let child  = baggageInfo.child {
                    htmlString.append("<h3>Child: " + child + "</h3>")
                }
                
                if let infant  = baggageInfo.infant {
                    htmlString.append("<h3>Infant: " + infant + "</h3>")
                }
            }
            
            let modifiedHtml = htmlString.replacingOccurrences(of: "\n", with: "<br/>")
            let finalHtmlString = Helpers.generateHtml(content: modifiedHtml)
            return finalHtmlString
            
        } else {
            return Helpers.generateHtml(content: "<h3> No specific baggage information is found!</h3>")
        }
    }
    
    func getAirFareRulesHtmlString() -> String {
        var htmlString = ""
        for airFareRule in history.airFareRules {
            htmlString.append("<h2>" + airFareRule.originCode + " - " + airFareRule.destinationCode + "</h2>")
            
            for rulePolicyNote in airFareRule.policy.rules {
                htmlString.append("<h3>" + rulePolicyNote.type + "</h3>")
                htmlString.append("<p>" + rulePolicyNote.text + "</p>")
            }
        }
        let modifiedHtml = htmlString.replacingOccurrences(of: "\n", with: "<br/>")
        let finalHtmlString = Helpers.generateHtml(content: modifiedHtml)
        return finalHtmlString
    }
    
    // MARK: - Network calls
    func retryFlightBooking() {
        FlightAPIClient().retryBookingFlight(bookingCode: bookingCode) { [weak self] (result) in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let response):
                if let responseURL = response.response {
                    var urls = PaymentUrls()
                    urls.paymentURL = responseURL
                    strongSelf.callback.didRetryBooking(urls)
                    
                } else {
                    if let newResp = response.newResponse {
                        var urls = PaymentUrls ()
                        urls.paymentURL = newResp.paymentUrl ?? ""
                        urls.successUrl = newResp.successUrl
                        urls.failureUrl = newResp.cancelUrl
                        strongSelf.callback.didRetryBooking(urls)
                    } else {
                        strongSelf.callback.didFailed(response.message)
                    }
                }
            case .failure(let error):
                strongSelf.callback.didFailed("Flight booking failed with error: \(error.localizedDescription)")
            }
        }
    }
    
    func resendFlightVoucherButtonDidTap() {
        FlightAPIClient().resendFlightBookingVoucher(bookingCode: bookingCode) { [weak self] (result) in
            switch result {
            case .success(let response):
                if response.code == APIResponseCode.success {
                    self?.callback.didResendVoucher()
                } else {
                    self?.callback.didFailed(response.message)
                }
                
            case .failure(let error):
                self?.callback.didFailed(error.localizedDescription)
            }
        }
    }
    
    func callFlightCancelBookingAPI() {
        FlightAPIClient().cancelFlightBooking(bookingCode: bookingCode) { [weak self] (result) in
            switch result {
            case .success(let response):
                if response.code == APIResponseCode.success {
                    self?.callback.didCancelFlight()
                } else {
                    self?.callback.didFailed(response.message)
                }
            case .failure(let error):
                self?.callback.didFailed(error.localizedDescription)
            }
        }
    }
}
