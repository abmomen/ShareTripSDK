//
//  SharedMessage.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 04/11/2021.
//  Copyright © 2021 ShareTrip. All rights reserved.
//

public struct EmptyBookingMessage {
    public static func getMessage(for serviceType: ServiceType) -> String {
        return "\(serviceType.title) booking history not found"
    }
}
