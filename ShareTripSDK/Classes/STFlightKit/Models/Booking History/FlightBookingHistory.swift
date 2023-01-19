//
//  FlightBookingHistory.swift
//  STFlightKit
//
//  Created by ST-iOS on 11/20/22.
//



public enum FlightBookingStatus: String, Codable {
    case pending = "Pending"
    case booked = "Booked"
    case issued = "Issued"
    case declined = "Declined"
    case canceled = "Cancelled"
    case completed = "Completed"
    
    public init(from decoder: Decoder) throws {
        let stringValue = try decoder.singleValueContainer().decode(String.self)
        let capitalizedValue = stringValue.capitalized
        self = FlightBookingStatus(rawValue: capitalizedValue) ?? .pending
    }
}

public enum PaymentStatus: String, Codable {
    case unpaid = "Unpaid"
    case paid = "Paid"
    
    public init(from decoder: Decoder) throws {
        let stringValue = try decoder.singleValueContainer().decode(String.self)
        let capitalizedValue = stringValue.capitalized
        //self = PaymentStatus(rawValue: capitalizedValue) ?? .unknown
        self = PaymentStatus(rawValue: capitalizedValue) ?? .unpaid
    }
}

public struct FlightBookingHistoryResponse: Codable {
    public let data: [FlightBookingHistory]?
    public let offset, count, limit: Int
}

public class FlightBookingHistory: Codable {
    public let actualAmount: Double?
    public let airFareRules: [AirFareRule]
    public let airlineResCode: String?
    public let baggageInfo: [BaggageInfo]?
    public let bookingCode: String?
    public let searchId: String?
    public let bookingCurrency: String
    public let bookingStatus: FlightBookingStatus

    public let eTicket: String?
    public let flight: [FlightRouteInfo]
    public let gatewayAmount: Double?
    
    public let gatewayCurrency: String?
    public let paymentStatus: PaymentStatus
    public let pnrCode: String?

    public var priceBreakdown: FlightPriceBreakdown
    public let covidAmount: Double?
    public let travelInsuranceAmount: Double?
    
    public let searchParams: FlightSearchParams
    public let searchParamDetails: [FlightSearchParamDetail]
    
    public let segments: [FlightSegment]
    public let points: Point
    public let travellers: [TravellerInfo]
    
    public let luggageAmount: Double?
    public let advanceIncomeTax: Double?
    public let baggage: Baggage?
    public let convenienceFee: Double?
    
    public let isModified: Bool?
    public let isVoidable: Bool?
    public let isRefundable: Bool?
    public let isReissueable: Bool?
    public let modifyHistory: [ModifyHistory]?
}

public struct ModifyHistory: Codable {
    public let modificationType, refundSearchID, bookingCode, automationType: String?
    public let eTickets: String?
    public let airlineRefundCharge, stFee, totalFee, purchasePrice: Int?
    public let totalRefundAmount: Int?
    
    enum CodingKeys: String, CodingKey {
        case modificationType
        case refundSearchID = "refundSearchId"
        case bookingCode, automationType, eTickets, airlineRefundCharge, stFee, totalFee, purchasePrice, totalRefundAmount
    }
}

//MARK:- Baggage
public struct Baggage: Codable {
    public let basic: [AirportDetail]?
    public let extra: [ExtraBaggageDetail]?
}

public struct AirportDetail: Codable {
    public let origin: AirportDetailInfo?
    public let destination: AirportDetailInfo?
    public let baggage: [BaggageDetail]?
}

public struct AirportDetailInfo: Codable {
    public let code: String?
    public let country: String?
    public let city: String?
    public let airport: String?
}

public struct BaggageDetail: Codable {
    public let weight: Double?
    public let name: String?
    public let unit: String?
    public let type: String?
}

public struct ExtraBaggageDetail: Codable {
    public let route: String?
    public let details: [ExtraBaggageDetailInfo]?
}

public struct ExtraBaggageDetailInfo: Codable {
    public let currency: String?
    public let weight: String?
    public let name: String?
    public let price: Double?
}

public class BaggageInfo: Codable {
    public let type: String
    public let adult: String?
    public let child: String?
    public let infant: String?
}

//MARK:- airFareRules
public class AirFareRule: Codable {
    public let destination: String
    public let destinationCode: String
    public let origin: String
    public let originCode: String
    public let policy: AirFarePolicy
}

public class AirFarePolicy: Codable {
    public let header: [PolicyNote]
    public let rules: [PolicyNote]
}

public class PolicyNote: Codable {
    public let code: Int?
    public let text: String
    public let type: String
}

//MARK:- flight
public class FlightRouteInfo: Codable {
    public let departureDateTime: DateTime
    public let destinationName: AirportInfo?
    public let originName: AirportInfo?
}

public class FlightSearchParamDetail: Codable {
    public let departureDateTime: String
    public let destination: String
    public let origin: String
    public let sequence: Int
}

public class FlightSearchParams: Codable {
    public let tripType: TripType
    public let adult: Int?
    public let airlines: String?
    public let child: Int?
    public let classType: String?
    public let currency: String?
    public let deviceType: String?
    public let flightType: String?
    public let infant: Int?
    public let nextLink: String?
    public let preferredAirlines: String?
    public let stop: String?
    
    enum CodingKeys: String, CodingKey {
        case adult
        case airlines
        case child
        case classType = "class"
        case currency
        case deviceType
        case flightType
        case infant
        case nextLink
        case preferredAirlines
        case stop
        case tripType
    }
}


public class FlightSegment: Codable {
    public let segmentDetails: [FlightSegmentDetail]
    public let type: String
    
    enum CodingKeys: String, CodingKey {
        case segmentDetails = "segment"
        case type
    }
}

public class FlightSegmentDetail: Codable {
    public let searchCode: String
    public let sequenceCode: String
    
    public let aircraft: String
    public let aircraftCode: String
    public let airlines: AirlineInfo
    public let airlinesCode: String
    public let baggageUnit: String
    public let baggageWeight: Int
    public let cabin: String
    public let dayCount: Int
    public let logo: String?
    
    public let destinationCode: String
    public let destinationName: AirportInfo
    public let arrivalDateTime: DateTime
    
    public let originCode: String
    public let originName: AirportInfo
    public let departureDateTime: DateTime
    
    public let duration: String
    public let transitTime: String
    
    //Optioanal
    public let flightNumber: String?
    public let seatsRemaining: Int?

    public let hiddenStop: FlightHiddenStop?
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        searchCode = try container.decode(String.self, forKey: .searchCode)
        sequenceCode = try container.decode(String.self, forKey: .sequenceCode)
        aircraft = try container.decode(String.self, forKey: .aircraft)
        aircraftCode = try container.decode(String.self, forKey: .aircraftCode)
        airlines =  try container.decode(AirlineInfo.self, forKey: .airlines)
        airlinesCode = try container.decode(String.self, forKey: .airlinesCode)
        baggageUnit = try container.decode(String.self, forKey: .baggageUnit)
        baggageWeight = try container.decode(Int.self, forKey: .baggageWeight)
        cabin = try container.decode(String.self, forKey: .cabin)
        dayCount = try container.decode(Int.self, forKey: .dayCount)
        
        logo = try? container.decode(String.self, forKey: .logo)
        
        destinationCode = try container.decode(String.self, forKey: .destinationCode)
        destinationName = try container.decode(AirportInfo.self, forKey: .destinationName)
        arrivalDateTime = try container.decode(DateTime.self, forKey: .arrivalDateTime)
        
        originCode = try container.decode(String.self, forKey: .originCode)
        originName = try container.decode(AirportInfo.self, forKey: .originName)
        departureDateTime = try container.decode(DateTime.self, forKey: .departureDateTime)
        
        duration = try container.decode(String.self, forKey: .duration)
        transitTime = try container.decode(String.self, forKey: .transitTime)
        
        flightNumber = try? container.decodeIfPresent(String.self, forKey: .flightNumber)
        seatsRemaining = try? container.decodeIfPresent(Int.self, forKey: .seatsRemaining)

        hiddenStop = try? container.decodeIfPresent(FlightHiddenStop.self, forKey: .hiddenStop)
    }
}

public struct FlightHiddenStop: Codable {
    public let city: String
    public let airport: String
    public let code: String
}

public struct Covid19TestInfo: Codable {
    public let address: String?
    public let isHomeCollection: Bool?
    public let option: String?
    public let customerAddress: String?
    public let discountPrice: Double?
    public let center: String?
}

public class TravellerInfo: Codable {
    public let code: String
    public let title: String
    public let givenName: String
    public let surName: String
    public let travellerType: TravellerType?
    public let gender: String
    public let dateOfBirth: String
    public let email: String
    public let passportNumber: String
    public let passportExpireDate: String
    public let mobileNumber: String
    public let nationality: String
    
    public let frequentFlyerNumber: String?
    public var passportCopy: String?
    public var visaCopy: String?

    public let address1: String
    public let primaryContact: String
    public let covid: Covid19TestInfo?
    

    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        code = try container.decodeIfPresent(String.self, forKey: .code) ?? ""
        title = try container.decode(String.self, forKey: .title)
        givenName = try container.decode(String.self, forKey: .givenName)
        surName = try container.decode(String.self, forKey: .surName)
        travellerType = try? container.decode(TravellerType.self, forKey: .travellerType)
        gender = try container.decode(String.self, forKey: .gender)
        dateOfBirth = try container.decode(String.self, forKey: .dateOfBirth)

        email = try container.decode(String.self, forKey: .email)
        passportNumber = try container.decode(String.self, forKey: .passportNumber)
        passportExpireDate = try container.decode(String.self, forKey: .passportExpireDate)
        mobileNumber = try container.decode(String.self, forKey: .mobileNumber)
        nationality = try container.decode(String.self, forKey: .nationality)
        
        frequentFlyerNumber = try? container.decodeIfPresent(String.self, forKey: .frequentFlyerNumber)
        passportCopy = try? container.decodeIfPresent(String.self, forKey: .passportCopy)
        visaCopy = try? container.decodeIfPresent(String.self, forKey: .visaCopy)
        
        address1 = try container.decodeIfPresent(String.self, forKey: .address1) ?? ""
        primaryContact = try container.decodeIfPresent(String.self, forKey: .primaryContact) ?? ""
        covid = try container.decodeIfPresent(Covid19TestInfo.self, forKey: .covid)
    }
}
