//
//  FlightInfoProvider.swift
//  STFlightKit
//
//  Created by ST-iOS on 11/23/22.
//



public class FlightInfoProvider: WebViewDataSource {
    private let searchId: String
    private let sequenceCode: String
    private var flightDetailInfoType: FlightDetailInfoType
    
    public var flightRuleResponse: FlightRuleResponse?
    
    public init(
        searchId: String,
        sequenceCode: String,
        flightDetailInfoType: FlightDetailInfoType
    ) {
        self.searchId = searchId
        self.sequenceCode = sequenceCode
        self.flightDetailInfoType = flightDetailInfoType
    }
    
    public func getSearchId() -> String {
        return searchId
    }
    
    public func getSequenceCode() -> String {
        return sequenceCode
    }
    
    public func getDetailInfoType() -> FlightDetailInfoType {
        return flightDetailInfoType
    }
    
    public func setDetailInfoType(_ infoType: FlightDetailInfoType) {
        self.flightDetailInfoType = infoType
    }
    
    public func fetchWebData(completionHandler: @escaping (Result<String, Error>) -> Void) {
        guard flightRuleResponse == nil else {
            completionHandler(.success(getHtmlString()))
            return
        }
        
        FlightAPIClient().flightRules(searchId: searchId, sequenceCode: sequenceCode) { [weak self] result in
            switch result {
            case .success(let response):
                if response.code == APIResponseCode.success, let flightRuleResponse = response.response {
                    self?.flightRuleResponse = flightRuleResponse
                    let htmlString = self?.getHtmlString() ?? ""
                    completionHandler(.success(htmlString))
                } else {
                    completionHandler(.failure(NSError(domain: "Not found", code: 0, userInfo: nil)))
                }
            case .failure(let error):
                completionHandler(.failure(NSError(domain: error.localizedDescription, code: 0, userInfo: nil)))
            }
        }
    }
    
    public func getHtmlString() -> String {
        guard flightRuleResponse != nil else { return "" }
        
        switch flightDetailInfoType {
        case .refundPolicy:
            return getRefundPolicyHtmlString()
        case .bagageInfo:
            return getBaggageHtmlString()
        case .fareDetail:
            return getFareDetailHtmlString()
        }
    }
    
    private func getRefundPolicyHtmlString() -> String {
        guard let refundPolicies = flightRuleResponse?.refundPolicies else {
            return Helpers.generateHtml(content: "<h3>Refund policy not found!</h3>")
        }
        
        var htmlString = ""
        for refundPolicy in refundPolicies {
            if refundPolicy == nil { continue}
            htmlString.append("<h2>" + refundPolicy!.type + "</h2>")
            
            for refundPolicyRule in refundPolicy!.rules {
                htmlString.append("<h3>" + refundPolicyRule.type + "</h3>")
                htmlString.append("<p>" + refundPolicyRule.text + "</p>")
            }
        }
        let modifiedHtml = htmlString.replacingOccurrences(of: "\n", with: "<br/>")
        let finalHtmlString = Helpers.generateHtml(content: modifiedHtml)
        return finalHtmlString
    }
    
    private func getBaggageHtmlString() -> String {
        guard let baggages = flightRuleResponse?.baggages else {
            return Helpers.generateHtml(content: "<h3>Baggage information not found!</h3>")
        }
        
        var htmlString = ""
        for baggageInfo in baggages {
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
    }
    
    private func getFareDetailHtmlString() -> String {
        guard let fareDetails = flightRuleResponse?.fareDetails else {
            return Helpers.generateHtml(content: "<h3>Fare detail not found!</h3>")
        }
        
        let finalHtmlString = Helpers.generateHtml(content: fareDetails)
        return finalHtmlString
    }
    
}

