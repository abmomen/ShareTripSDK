//
//  TravelInsuranceServiceDetailResponse.swift
//  ShareTrip
//
//  Created by Mac mini M1 on 13/9/22.
//  Copyright © 2022 ShareTrip. All rights reserved.
//

import Foundation

// MARK: - Response
public struct TravelInsuranceServiceDetailResponse: Codable {
    public let code, name: String
    public let logo: String
    public let description: String
}
