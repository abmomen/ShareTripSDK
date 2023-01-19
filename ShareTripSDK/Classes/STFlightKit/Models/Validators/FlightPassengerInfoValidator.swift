//
//  FlightPassengerInfoValidator.swift
//  STFlightKit
//
//  Created by ST-iOS on 11/20/22.
//

import STCoreKit

public class FlightPassengerInfoValidator {
    public static func isOptional(rowType: UserInfoRowType, isPrimaryPassenger: Bool, isDomesticFlight: Bool, isAttachmentAvailable: Bool) -> Bool {
        let requiredProperties: [UserInfoRowType] = {
            var requiredProperties: [UserInfoRowType] = [.surName, .gender, .dob, .nationality]
            if isPrimaryPassenger {
                requiredProperties.append(contentsOf: [.mobile, .email])
            }
            if !isDomesticFlight {
                requiredProperties.append(contentsOf: [.passportNumber, .passportExpiryDate])
            }
            
            if isAttachmentAvailable {
                requiredProperties.append(contentsOf: [.upload])
            }
            return requiredProperties
        }()

        return !requiredProperties.contains(rowType)
    }

    public static func isValid(passengerInfo: PassengerInfo, isPrimaryPassenger: Bool, isDomesticFlight: Bool, isAttachmentAvailable: Bool) -> Bool {

        let propertyTypes: [UserInfoRowType] = [.givenName, .surName, .gender, .dob, .nationality, .mobile, .email, .passportNumber, .passportExpiryDate, .frequentFlyerNumber, .upload]

        for propertyType in propertyTypes {
            let optional = isOptional(rowType: propertyType, isPrimaryPassenger: isPrimaryPassenger, isDomesticFlight: isDomesticFlight, isAttachmentAvailable: isAttachmentAvailable)
            let result = passengerInfo.validateInfo(for: propertyType, isOptional: optional)
            switch result {
                case .success:
                    break
                case .failure:
                    return false
            }
        }
        return true
    }
}
