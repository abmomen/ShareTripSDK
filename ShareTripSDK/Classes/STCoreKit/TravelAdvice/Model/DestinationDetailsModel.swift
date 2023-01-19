//
//  DestinationDetailsModel.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 12/11/2020.
//  Copyright © 2020 ShareTrip. All rights reserved.
//

import Foundation

struct DestinationDetailsModel {
    let countryName: String
    let time: String
    let riskLevel: String
    let countryRestriction: String
    let requirements: Requirement
    let countryRecommandation: String
    let advice: String

    let newCases: Int
    let newDeath: Int
    let totalCases: Int
    let totalDeath: Int
}

struct Requirement {
    let quarentine: String
    let test: String
    let mask: String
}

