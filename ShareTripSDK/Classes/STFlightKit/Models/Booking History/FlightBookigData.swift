//
//  FlightBookigData.swift
//  STFlightKit
//
//  Created by ST-iOS on 11/20/22.
//

import Foundation

public class FlightBookigData {
    public var passengersInfos: [PassengerInfo]
    public var passengersAdditionalRequirementInfos: [PassengersAdditionalReq]
    public private(set) var isDomestic: Bool
    public private(set) var isAttachmentAvailable: Bool

    public init(isDomestic: Bool, passengersInfos: [PassengerInfo], passengersAdditionalRequirementInfos: [PassengersAdditionalReq], isAttachmentAvailable: Bool) {
        self.isDomestic = isDomestic
        self.passengersInfos = passengersInfos
        self.isAttachmentAvailable = isAttachmentAvailable
        self.passengersAdditionalRequirementInfos = passengersAdditionalRequirementInfos
    }

    public var isSubmittable: Bool {
        for index in 0..<passengersInfos.count {
            if !isValidPassengerInfo(at: index) {
                return false
            }
        }
        return true
    }

    public func isValidPassengerInfo(at index: Int) -> Bool {
        return FlightPassengerInfoValidator.isValid(passengerInfo: passengersInfos[index], isPrimaryPassenger: index == 0, isDomesticFlight: isDomestic, isAttachmentAvailable: self.isAttachmentAvailable)
    }
}
