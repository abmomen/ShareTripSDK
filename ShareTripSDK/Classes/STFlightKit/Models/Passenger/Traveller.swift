//
//  Traveller.swift
//  STFlightKit
//
//  Created by ST-iOS on 11/20/22.
//

import STCoreKit

class Traveller {
    var title: TitleType = .mr
    var givenName: String = ""
    var surName: String = ""
    var gender: GenderType = .male
    var dateOfBirth: String = ""
    var nationality: String = ""
    var emailAddress: String = ""
    var addressLine1: String = ""
    var addressLine2: String = ""
    var phoneNumber: String = ""
    var passportNumber: String = ""
    var passportExpireDate: String = ""
    var frequentFlyerNumber: String = ""
    var passportCopyPath: String = ""
    var visaCopyPath: String = ""
    var isValid = false
}
