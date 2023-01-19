//
//  UserRegistrationEvents.swift
//  ShareTrip
//
//  Created by ST-iOS on 10/25/21.
//  Copyright © 2021 ShareTrip. All rights reserved.
//

enum UserRegistrationEvents: STAnalyticsEvent {
    case registrationSuccessfull
    case registrationFailed
    
    var name: String  {
        switch self {
        case .registrationSuccessfull:
            return "registration_success_b2c"
        case .registrationFailed:
            return "registration_error_b2c"
        }
    }
    
    var payload: Payload? { return nil }
}
