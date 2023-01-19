//
//  DateExtension.swift
//  STFlightKit
//
//  Created by ST-iOS on 11/20/22.
//

import STCoreKit

public extension Date {
    static func validateDateOfBirth(_ dob: Date, tillDate: Date, of travellerType: TravellerType) -> Result<Void, AppError> {
        guard let age = Calendar(identifier: .gregorian).dateComponents([.year], from: dob, to: tillDate).year else {
            return .success(())
        }
        switch travellerType {
        case .infant:
            guard age < 2 else {
                return .failure(.validationError("Infant's age must be \(travellerType.requiredInfo)"))
            }
        case .child:
            guard 2 <= age && age < 12 else {
                return .failure(.validationError("Child's age must be \(travellerType.requiredInfo)"))
            }
        case .adult:
            guard age >= 12 else {
                return .failure(.validationError("Adult must be at least \(travellerType.requiredInfo)"))
            }
        }
        return .success(())
    }
}
