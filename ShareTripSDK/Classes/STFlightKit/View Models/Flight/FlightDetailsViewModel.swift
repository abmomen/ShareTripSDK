//
//  FlightDetailsViewModel.swift
//  STFlightKit
//
//  Created by ST-iOS on 11/22/22.
//

import Foundation
import FirebaseRemoteConfig


public struct SelectedFlightInfo {
    public let adult: Int
    public let child: Int
    public let infant: Int
    public let searchId: String
    public let sessionId: String
    public let flight: Flight
    public let flightClass: FlightClass
    public let searchDepartDate: Date
    public let flightRouteType: FlightRouteType
    public let firstAirportIata: String
    public let lastAirportIata: String
    
    public init(adult: Int, child: Int, infant: Int, searchId: String, sessionId: String, flight: Flight, flightClass: FlightClass, searchDepartDate: Date, flightRouteType: FlightRouteType, firstAirportIata: String, lastAirportIata: String) {
        self.adult = adult
        self.child = child
        self.infant = infant
        self.searchId = searchId
        self.sessionId = sessionId
        self.flight = flight
        self.flightClass = flightClass
        self.searchDepartDate = searchDepartDate
        self.flightRouteType = flightRouteType
        self.firstAirportIata = firstAirportIata
        self.lastAirportIata = lastAirportIata
    }
}

public extension FlightDetailsViewModel {
    class Callback {
        public var didFetchFlightDetails: () -> Void = { }
        public var didFailed: (String) -> Void = { _ in }
    }
}

struct SelectedDiscountOption {
    var option: DiscountOptionType
    var dicount: Double
}

public class FlightDetailsViewModel {
    private var baggageResponse: BaggageResponse?
    private let flightInfo: SelectedFlightInfo
    private let apiClient = FlightAPIClient()
    public let callback = Callback()
    
    public typealias CompletionCallBack = (_ success: Bool) -> Void
    
    public var redeemDiscountAmount: Double = 0.0
    public var revalidateResponse: FlightRevalidationResponse? {
        didSet {
            guard let revalidateResponse = revalidateResponse else { return }
            flightInfo.flight.priceBreakdown = revalidateResponse.priceBreakdown
            flightInfo.flight.earnPoint = revalidateResponse.points.earning
        }
    }
    
    public init(flightInfo: SelectedFlightInfo) {
        self.flightInfo = flightInfo
    }
    
    public var flightDate: Date {
        return Date(
            fromString: flightInfo.flight.departStartDate.date,
            format: .isoDate) ?? flightInfo.searchDepartDate
    }
    
    public var numberOfSections: Int {
        return flightInfo.flight.flightLegs.count + 1 + 1
    }
    
    public var addBaggageCollupseIndicator = true
    public var selectedDiscountOption: DiscountOptionType = .earnTC
    
    public var firstAirportIata: String {
        return flightInfo.firstAirportIata
    }
    
    public var lastAirportIata: String {
        return flightInfo.lastAirportIata
    }
    
    public var flightRequiedData: FlightsRequiredData {
        return FlightsRequiredData(
            searchId: searchId,
            sessionId: sessionId,
            sequenceCode: sequenceCode,
            currencyType: gatewayCurrency,
            lastAirportIata: lastAirportIata,
            firstAirportIata: firstAirportIata,
            shareTripCoin: shareTC,
            earningTripCoin: earnTC
        )
    }
    
    private var priceTableData = PriceInfoTableData()
    
    public var flightPriceTableData: PriceInfoTableData {
        var rowDatas =  [PriceInfoFareCellData]()
        for detail in priceBreakdown.details {
            if detail.numberPaxes > 0 {
                let title = "Traveler: \(detail.type.rawValue.capitalized) * \(detail.numberPaxes)"
                let fareTitle = "Base Fare * \(detail.numberPaxes)"
                let taxTitle = "Taxes & Fees * \(detail.numberPaxes)"
                let baseFare =  detail.baseFare * Double(detail.numberPaxes)
                let tax = detail.tax * Double(detail.numberPaxes)
                let cellData = PriceInfoFareCellData(title: title, fareTitle: fareTitle, fareAmount: baseFare, taxTitle: taxTitle, taxAmount: tax)
                rowDatas.append(cellData)
            }
        }
        
        priceTableData.rowDatas = rowDatas
        priceTableData.totalPrice = priceBreakdown.originPrice
        priceTableData.advanceIncomeTax = priceBreakdown.advanceIncomeTax ?? 0.0
        
        updateDiscountAmount()
        
        return priceTableData
    }
    
    private func updateDiscountAmount() {
        switch selectedDiscountOption {
        case .earnTC:
            priceTableData.discount = earnTCDiscount
            priceTableData.withDiscount = true
            priceTableData.couponsDiscount = 0
            
        case .redeemTC:
            priceTableData.discount = redeemDiscountAmount
            priceTableData.withDiscount = true
            priceTableData.couponsDiscount = 0
            
        case .useCoupon:
            priceTableData.discount = earnTCDiscount
            priceTableData.withDiscount = isCouponWithDiscount
            priceTableData.couponsDiscount = couponDiscountAmount
        case .unknown:
            break
        }
    }
    
    public var isCouponWithDiscount = false
    public var couponDiscountAmount: Double = 0.0
    
    public func updateBaggagePrice(_ price: Double) {
        priceTableData.baggagePrice = price
    }
    
    public func updateSTCharge(_ charge: Double) {
        priceTableData.stCharge = charge
    }
    
    public func getPassengers() -> [TravellerType] {
        var passengers = [TravellerType]()
        
        for _ in 0..<flightInfo.adult {
            passengers.append(.adult)
        }
        for _ in 0..<flightInfo.child {
            passengers.append(.child)
        }
        for _ in 0..<flightInfo.infant {
            passengers.append(.infant)
        }
        
        return passengers
    }
    
    public var adultCount: Int {
        return flightInfo.adult
    }
    
    public var childCount: Int {
        return flightInfo.child
    }
    
    public var infantCount: Int {
        return flightInfo.infant
    }
    
    public var flightLegs: [FlightLeg] {
        return flightInfo.flight.flightLegs
    }
    
    public var isDomestic: Bool {
        return flightInfo.flight.domestic
    }
    
    public var isAttachmentAvalilable: Bool {
        return flightInfo.flight.attachment ?? false
    }
    
    public var priceBreakdown: FlightPriceBreakdown {
        return flightInfo.flight.priceBreakdown
    }
    
    public var earnTC: Int {
        return flightInfo.flight.earnPoint
    }
    
    public var redeemTC: Int {
        return flightInfo.flight.earnPoint
    }
    
    public var shareTC: Int {
        return flightInfo.flight.sharePoint
    }
    
    public var searchId: String {
        return flightInfo.searchId
    }
    
    public var sessionId: String {
        return flightInfo.sessionId
    }
    
    public var sequenceCode: String {
        return flightInfo.flight.sequence
    }
    
    public var routeType: FlightRouteType {
        return flightInfo.flightRouteType
    }
    
    public var currency: String {
        return flightInfo.flight.currency
    }
    
    public var gatewayCurrency: String {
        return flightInfo.flight.gatewayCurrency
    }
    
    public var seatsCount: Int {
        return flightInfo.flight.seatsLeft
    }
    
    public var waight: String {
        return flightInfo.flight.weight ?? ""
    }
    
    public var originalPrice: Double {
        return flightInfo.flight.originPrice
    }
    
    public var discountPrice: Double {
        return flightInfo.flight.price
    }
    
    public var discount: Double {
        return flightInfo.flight.discount
    }
    
    public var flightSegmentsCount: Int {
        return flightInfo.flight.segments.count
    }
    
    public var flightClasses: [FlightClass] {
        return [flightInfo.flightClass]
    }
    
    public var flightRouteTypes: [FlightRouteType] {
        return [flightInfo.flightRouteType]
    }
    
    public var isRefundable: Bool {
        return flightInfo.flight.refundable ?? false
    }
    
    public var refundpolicyText: String {
        return flightInfo.flight.isRefundable ?? (isRefundable ? "Refundable" : "Non Refundable")
    }
    
    public var departureDateAndTimes: [DateTime] {
        var departureDateAndTime = [DateTime]()
        for flightLeg in flightLegs {
            departureDateAndTime.append(flightLeg.departureDateTime)
        }
        return departureDateAndTime
    }
    
    public var departureDate: String {
        return departureDateAndTimes.first?.date ?? ""
    }
    
    public var baseFare: Double {
        return priceBreakdown.details.reduce(0) { $0 + $1.baseFare * Double($1.numberPaxes) }
    }
    
    public var earnTCDiscount: Double {
        return Double(priceBreakdown.originPrice - priceBreakdown.discountAmount)
    }
    
    public var dateComponents: [DateComponents] {
        var components = [DateComponents]()
        for date in departureDateAndTimes {
            if let departDate = date.date.toDate() {
                var comp = Calendar.current.dateComponents([.month, .year, .day], from: departDate)
                
                let timeComponets = date.time.components(separatedBy: ":")
                
                if let hourComponent = timeComponets.first, let hour = Int(hourComponent) { comp.hour = hour }
                
                if let minComponent = timeComponets.last, let minute = Int(minComponent) { comp.minute = minute }
                
                //Alert user before 6 hours of flight schedule.
                let hourBefore = -6
                
                let inDateFormat = Calendar.current.date(from: comp)!
                let inCompFormat = Calendar.current.date(byAdding: .hour, value: hourBefore, to: inDateFormat)!
                let resultDate = Calendar.current.dateComponents([.year , .month, .day, .hour, .minute], from: inCompFormat)
                components.append(resultDate)
            }
        }
        
        return components
    }
    
    public var covidWarningMsg: String {
        return "Due to Covid-19, Airline has the authority to cancel or reschedule flight any time. Please check travel restriction & health advisories before you travel to your destination."
    }
    
    public var baggageViewModel: BaggageViewModel {
        return BaggageViewModel(
            baggageResponse: baggageResponse,
            adult: adultCount,
            child: childCount,
            infant: infantCount
        )
    }
    
    public func setPriceBreakdown(breakdown: FlightPriceBreakdown) {
        flightInfo.flight.priceBreakdown = breakdown
    }

    public func numberOfRows(for section: Int) -> Int {
        let sectionType = flightDetailSectionType(for: section)
        switch sectionType {
        case .tripcoinSection:
            return 1
        case .flightSection:
            if section <= flightInfo.flight.flightLegs.count {
                let adjustedSection = section - 1
                guard flightInfo.flight.segments.count > adjustedSection else { return 0 }
                let flightSegment = flightInfo.flight.segments[adjustedSection]
                return flightSegment.segmentDetails.count
            }
        case .infoSection:
            return FlightDetailInfoType.allCases.count
        }
        return 0
    }
    
    public func flightDetailSectionType(for section: Int) -> FlightDetailSectionType {
        if section == 0 {
            return .tripcoinSection
        }else if section <= flightInfo.flight.flightLegs.count {
            return .flightSection
        } else {
            return .infoSection
        }
    }
    
    public func getFlightSegmentCellData(for indexPath: IndexPath) -> FlightSegmentCellData {
        let adjustedSection = indexPath.section - 1
        let flightSegment = flightInfo.flight.segments[adjustedSection]
        let flightSegmentDetail = flightSegment.segmentDetails[indexPath.row]
        
        let airline = flightSegmentDetail.airlines.short + " " + flightSegmentDetail.airlines.code + (flightSegmentDetail.flightNumber ?? "")
        let duration = flightSegmentDetail.duration
        let departTime = flightSegmentDetail.departureDateTime.time
        let departDate = Date(fromString: flightSegmentDetail.departureDateTime.date, format: .isoDate)?
            .toString(format: .shortDateFullYear) ?? flightSegmentDetail.departureDateTime.date
        let departCode = flightSegmentDetail.originName.code
        let arrivalTime = flightSegmentDetail.arrivalDateTime.time
        let arrivalDate = Date(fromString: flightSegmentDetail.arrivalDateTime.date, format: .isoDate)?
            .toString(format: .shortDateFullYear) ?? flightSegmentDetail.arrivalDateTime.date
        let arrivalCode = flightSegmentDetail.destinationName.code
        let classText = flightInfo.flightClass.rawValue
        let aircraft = flightSegmentDetail.aircraft
        let transitTime = flightSegmentDetail.transitTime
        let lastSegment = isLastSegment(for: indexPath)
        let airlineCode = flightSegmentDetail.airlines.code + (flightSegmentDetail.flightNumber ?? "")
        let departAirport = "\(flightSegmentDetail.originName.city), \(flightSegmentDetail.originName.airport)"
        let arrivalAirport = "\(flightSegmentDetail.destinationName.city), \(flightSegmentDetail.destinationName.airport)"
        
        return FlightSegmentCellData(airlinesImage: flightSegmentDetail.logo, airline: airline, airlineCode: airlineCode, duration: duration, departTime: departTime, departDate: departDate, departCode: departCode, departAirport: departAirport, arrivalTime: arrivalTime, arrivalDate: arrivalDate, arrivalCode: arrivalCode, arrivalAirport: arrivalAirport, classText: classText, aircraft: aircraft, transitTime: transitTime, isLastSegment: lastSegment, transitVisaRequired: false, transitVisaText: "", hasTechnicalStoppage: false, technicalStoppageText: "")
    }
    
    public func getFlightSegments(for legIndex: Int) -> [FlightSegmentCellData] {
        let leg = flightInfo.flight.segments[legIndex]
        let segmentCellDatas = leg.segmentDetails.enumerated().map { (index, segment) -> FlightSegmentCellData in
            var transitVisaRequired: Bool = false
            var transitVisaText = ""
            let transitTimeStr = segment.transitTime.replacingOccurrences(of: "h", with: ":").replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "m", with: "")
            let hourMinutes = transitTimeStr.split(separator: ":").map { Int($0)! }
            if hourMinutes.count > 1 {
                let totalMinutes = hourMinutes[0] * 60 + hourMinutes[1]
                let destCode = segment.destinationName.code
                
                if destCode == "BKK" || destCode == "DMK" {
                    // if transit time >= 12 hours
                    if totalMinutes >= 12 * 60 {
                        transitVisaRequired = true
                        transitVisaText = "*This flight contains more than 12 hours of transit, before booking this flight please check your visa requirements as per your nationality."
                    }
                } else if destCode == "HKG" {
                    // if next flight is not in the same calendar date, no matter how short transit time is, transit visa is required
                    let arrivalDateTimeStr = "\(segment.arrivalDateTime.date)T\(segment.arrivalDateTime.time)Z"
                    if let arrivalDateTime: Date = Date(fromString: arrivalDateTimeStr, format: .isoDateTime) {
                        let nextFlightTime = arrivalDateTime.adjust(.minute, offset: totalMinutes)
                        if let arrivalDay = arrivalDateTime.component(.day),
                           let nextFlightDay = nextFlightTime.component(.day),
                           nextFlightDay > arrivalDay {
                            transitVisaRequired = true
                            transitVisaText = "* This flight contains transit which extends till the next calendar date, before booking this flight please check your visa requirements as per your nationality."
                        }
                    }
                } else {
                    // if transit time >= 24 hours
                    if totalMinutes >= 24*60 {
                        transitVisaRequired = true
                        transitVisaText = "* This flight contains more than 24 hours of transit, before booking this flight please check your visa requirements as per your nationality."
                    }
                }
            }
            
            var hasTechnicalStoppage = false
            var techinalStoppageText = ""
            if let hiddenStop = segment.hiddenStop {
                hasTechnicalStoppage = true
                techinalStoppageText = "Note: This flight has technical stoppage at \(hiddenStop.city), \(hiddenStop.airport) (\(hiddenStop.code)), Before booking this flight, please check you visa requirement as per your Nationality by mailing at flight@sharetrip.net."
            }
            
            return FlightSegmentCellData(
                airlinesImage: segment.logo,
                airline: segment.airlines.short,
                airlineCode: segment.airlines.code + (segment.flightNumber ?? ""),
                duration: segment.duration,
                departTime: segment.departureDateTime.time,
                departDate: Date(fromString: segment.departureDateTime.date, format: .isoDate)?
                    .toString(format: .shortDateFullYear) ?? segment.departureDateTime.date,
                departCode: segment.originName.code,
                departAirport: "\(segment.originName.city), \(segment.originName.airport)",
                arrivalTime: segment.arrivalDateTime.time,
                arrivalDate: Date(fromString: segment.arrivalDateTime.date, format: .isoDate)?
                    .toString(format: .shortDateFullYear) ?? segment.arrivalDateTime.date,
                arrivalCode: segment.destinationName.code,
                arrivalAirport: "\(segment.destinationName.city), \(segment.destinationName.airport)",
                classText: flightInfo.flightClass.rawValue,
                aircraft: segment.aircraft,
                transitTime: segment.transitTime,
                isLastSegment: index == leg.segmentDetails.count - 1,
                transitVisaRequired: transitVisaRequired,
                transitVisaText: transitVisaText,
                hasTechnicalStoppage: hasTechnicalStoppage,
                technicalStoppageText: techinalStoppageText
            )
        }
        
        return segmentCellDatas
    }
    
    public func isLastSegment(for indexPath: IndexPath) -> Bool {
        
        let adjustedSection = indexPath.section - 1
        let flightSegment = flightInfo.flight.segments[adjustedSection]
        
        return indexPath.row == flightSegment.segmentDetails.count - 1
    }
    
    public func shouldHaveLayoverLabel(for indexPath: IndexPath) -> Bool {
        
        let adjustedSection = indexPath.section - 1
        let flightSegment = flightInfo.flight.segments[adjustedSection]
        return flightSegment.segmentDetails.count > 1 && !isLastSegment(for: indexPath)
    }
    
    public private(set) var isLoading = Observable<Bool>(false)
    public private(set) var discountOptions = [DiscountOption]()
    private let dispatchGroup = DispatchGroup()
    public func loadDiscountOptions(onCompletion: @escaping ()->Void) {
        isLoading.value = true
        dispatchGroup.enter()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.dispatchGroup.leave()
        }
        loadDiscountOptionsFromRemoteConfig()
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            onCompletion()
            self?.isLoading.value = false
        }
    }
    
    private func loadDiscountOptionsFromRemoteConfig() {
        dispatchGroup.enter()
        let remoteConfig = RemoteConfig.remoteConfig()
        //STAppManager.shared.setupRemoteConfigDefaults()
        remoteConfig.fetch { [weak self] (status, error) -> Void in
            if status == .success {
                remoteConfig.activate { (_, error) in
                    if let error = error {
                        STLog.error(error.localizedDescription)
                    }
                }
                if let discountOptionsJSONStr = remoteConfig[Constants.RemoteConfigKey.flight_discount_options].stringValue,
                   let jsonData = discountOptionsJSONStr.data(using: .utf8) {
                    let discountOptions = try! JSONDecoder().decode([DiscountOption].self, from: jsonData)
                    self?.discountOptions = discountOptions
                }
            } else {
                STLog.error("Remote config error: \(error?.localizedDescription ?? "No error available.")")
            }
            self?.dispatchGroup.leave()
        }
    }
    
    public func fetchBaggageOptions(onCompletion: @escaping CompletionCallBack) {
        let request = FlightRevalidationRequest(
            searchId: flightInfo.searchId,
            sequenceCode: flightInfo.flight.sequence,
            sessionId: flightInfo.sessionId
        )
        
        FlightAPIClient().fetchBaggage(request: request) { [weak self ] response in
            switch response {
            case .success(let response):
                self?.baggageResponse = response.response
                if self?.baggageResponse != nil {
                    self?.setOptinalRouteOptions()
                    onCompletion(true)
                } else {
                    onCompletion(false)
                }
            case .failure(let error):
                STLog.error(error)
                onCompletion(false)
            }
        }
    }
    
    private func setOptinalRouteOptions() {
        if baggageResponse?.isLuggageOptional == true {
            let optionalAdultRouteOption = BaggageWholeFlightOptions(travellerType: .adt, code: "", quantity: 0, details: "Add No Baggage", amount: 0.0, currency: .bdt)
            let optionalChildRouteOption = BaggageWholeFlightOptions(travellerType: .chd, code: "", quantity: 0, details: "Add No Baggage", amount: 0.0, currency: .bdt)
            
            let totlaWholeFlightOption = baggageResponse?.wholeFlightOptions?.count ?? 0
            if totlaWholeFlightOption > 0{
                self.baggageResponse?.wholeFlightOptions?.append(optionalAdultRouteOption)
                self.baggageResponse?.wholeFlightOptions?.append(optionalChildRouteOption)
            }
            
            let totalRoute = baggageResponse?.routeOptions?.count ?? 0
            for rIndex in 0..<totalRoute {
                self.baggageResponse?.routeOptions?[rIndex].options?.append(optionalAdultRouteOption)
                self.baggageResponse?.routeOptions?[rIndex].options?.append(optionalChildRouteOption)
            }
        }
    }
    
    // MARK: - Fetch Flight Details
    public var promotionalCoupons = [PromotionalCoupon]() {
        didSet {
            selectedDiscountOption = promotionalCoupons.count > 0 ? .useCoupon : .earnTC
        }
    }
    
    public func fetchFlightDetails() {
        let detailsRequest = FlightDetailsRequest(
            searchId: searchId,
            sessionId: sessionId,
            sequenceCode: sequenceCode
        )
        
        apiClient.fetchFlightDetails(request: detailsRequest) {[weak self] result in
            switch result {
            case .success(let response):
                self?.promotionalCoupons = response.response?.promotionalCoupon ?? []
                self?.callback.didFetchFlightDetails()
            case .failure(let error):
                self?.callback.didFailed(error.localizedDescription)
            }
        }
    }
}

extension FlightDetailsViewModel: PaymentGateWayFilterProvider {
    public func paymentGateWayfilter(gatewayIds: [String]) -> ((PaymentGateway) -> Bool) {
        return { gateway in return gatewayIds.contains(gateway.id ?? "") }
    }
    
    public func paymentGateWayfilter(gatewayCodes: [String]) -> ((PaymentGateway) -> Bool) {
        return { gateway in return gatewayCodes.contains(gateway.code ?? "") }
    }
    
    public func paymentGateWayfilter() -> ((PaymentGateway) -> Bool) {
        switch selectedDiscountOption {
        case .redeemTC:
            return { gateWay in return (gateWay.redeemTripcoinApplicable ?? false) }
        case .useCoupon:
            return { gateWay in return (gateWay.couponApplicable ?? false) }
        default:
            return { gateWay in return (gateWay.earnTripcoinApplicable ?? false) }
        }
    }
}

public enum FlightDetailSectionType: Int {
    case tripcoinSection
    case flightSection
    case infoSection
}

public enum FlightDetailInfoType: Int, CaseIterable {
    case bagageInfo
    case fareDetail
    case refundPolicy
    
    public var title: String {
        switch self {
        case .bagageInfo:
            return "Bagage Details"
        case .fareDetail:
            return "Fare Details"
        case .refundPolicy:
            return "Refund Policy"
        }
    }
}

public struct FlightSegmentCellData {
    public let airlinesImage: String?
    public let airline: String
    public let airlineCode: String
    public let duration: String
    public let departTime: String
    public let departDate: String
    public let departCode: String
    public let departAirport: String
    public let arrivalTime: String
    public let arrivalDate: String
    public let arrivalCode: String
    public let arrivalAirport: String
    public let classText: String
    public let aircraft: String
    public let transitTime: String
    public let isLastSegment: Bool
    public let transitVisaRequired: Bool
    public let transitVisaText: String
    public let hasTechnicalStoppage: Bool
    public let technicalStoppageText: String
    
    public init(airlinesImage: String?, airline: String, airlineCode: String, duration: String, departTime: String, departDate: String, departCode: String, departAirport: String, arrivalTime: String, arrivalDate: String, arrivalCode: String, arrivalAirport: String, classText: String, aircraft: String, transitTime: String, isLastSegment: Bool, transitVisaRequired: Bool, transitVisaText: String, hasTechnicalStoppage: Bool, technicalStoppageText: String) {
        self.airlinesImage = airlinesImage
        self.airline = airline
        self.airlineCode = airlineCode
        self.duration = duration
        self.departTime = departTime
        self.departDate = departDate
        self.departCode = departCode
        self.departAirport = departAirport
        self.arrivalTime = arrivalTime
        self.arrivalDate = arrivalDate
        self.arrivalCode = arrivalCode
        self.arrivalAirport = arrivalAirport
        self.classText = classText
        self.aircraft = aircraft
        self.transitTime = transitTime
        self.isLastSegment = isLastSegment
        self.transitVisaRequired = transitVisaRequired
        self.transitVisaText = transitVisaText
        self.hasTechnicalStoppage = hasTechnicalStoppage
        self.technicalStoppageText = technicalStoppageText
    }
}

