//
//  PassengerInfo.swift
//  STFlightKit
//
//  Created by ST-iOS on 11/20/22.
//

import STCoreKit

public class PassengerInfo {
    public let flightDate: Date
    public let travellerType: TravellerType
    public var code: String = ""
    public var givenName: String = ""
    public var surName: String = ""
    public var gender: GenderType? = nil
    public var dob: Date? = nil
    public var nationality: Country?
    public var mobile: String = ""
    public var email: String = ""
    public var passportNumber: String = ""
    public var passportExpiryDate: Date? = nil
    public var frequentFlyerNumber: String = ""
    public var passportURLStr: String = ""
    public var visaURLStr: String = ""
    public var mealPreferenceSSR: String?
    public var wheelChairRequestSSR: String?
    public var luggageCode: [String] = []
    public var covid: CovidTestInfo = CovidTestInfo()
    public var travelInsurance: TravelInsuranceInfo = TravelInsuranceInfo()
    
    public var titleName: TitleType {
        if let  dob = dob , let gender = gender {
            let ageComponents = Calendar(identifier: .gregorian).dateComponents([.year], from: dob, to: Date())
            if let age = ageComponents.year {
                if age > 11 {
                    if gender == .male {
                        return .mr
                    } else if gender == .female {
                        return .ms
                    }
                } else {
                    if gender == .male {
                        return .master
                    } else if gender == .female {
                        return .miss
                    }
                }
            }
        }
        return .mr
    }
    
    public init(flightDate: Date, travellerType: TravellerType, luggageCode: [String]) {
        self.luggageCode = luggageCode
        self.flightDate = flightDate
        self.travellerType = travellerType
    }
    
    public var passengerDictionary: [String : Any] {
        let defaultPassportExpireDate = Calendar(identifier: .gregorian).date(byAdding: .month, value: 6, to: flightDate) ?? Calendar(identifier: .gregorian).date(byAdding: .year, value: 2, to: Date())!
        
        var dictionary: [String : Any] = [:]
        dictionary["titleName"] = titleName.rawValue
        dictionary[Constants.APIParameterKey.givenName] = givenName
        dictionary[Constants.APIParameterKey.surName] = surName
        dictionary[Constants.APIParameterKey.nationality] = nationality?.code ?? "BD"
        dictionary[Constants.APIParameterKey.dateOfBirth] = dob?.toString(format: .isoDate) ?? ""
        dictionary[Constants.APIParameterKey.gender] = gender?.rawValue ?? GenderType.male.rawValue
        dictionary[Constants.APIParameterKey.passportNumber] = passportNumber
        dictionary[Constants.APIParameterKey.frequentFlyerNumber] = frequentFlyerNumber
        dictionary[Constants.APIParameterKey.passportExpireDate] = passportExpiryDate?.toString(format: .isoDate) ?? defaultPassportExpireDate.toString(format: .isoDate)
        dictionary[Constants.APIParameterKey.postCode] = ""
        dictionary[Constants.APIParameterKey.email] = email
        dictionary[Constants.APIParameterKey.mobileNumber] = mobile
        dictionary[Constants.APIParameterKey.passportCopy] = passportURLStr
        dictionary[Constants.APIParameterKey.visaCopy] = visaURLStr
        
        if let ssr = mealPreferenceSSR {
            dictionary[Constants.APIParameterKey.mealPreference] = ssr
        } else {
            dictionary[Constants.APIParameterKey.mealPreference] = ""
        }
        
        if let ssr = wheelChairRequestSSR {
            dictionary[Constants.APIParameterKey.wheelChair] = ssr
        } else {
            dictionary[Constants.APIParameterKey.wheelChair] = ""
        }
        dictionary["luggageCode"] = luggageCode
        dictionary["covid"] = covidInfoDictionary()
        
        if travelInsurance.code == "" && travelInsurance.optionsCode == "" {
            dictionary["travelInsurance"] = ""
        } else {
            dictionary["travelInsurance"] = travelInsuranceDictionary
        }
        return dictionary
    }
    
    private func covidInfoDictionary() -> [String: Any] {
        return [
            "code": covid.code ,
            "optionsCode": covid.optionsCode,
            "address": covid.address,
            "self": covid.selfTest
        ]
    }
    
    private var travelInsuranceDictionary: [String : Any] {
        return [
            "code": travelInsurance.code ?? "",
            "optionsCode": travelInsurance.optionsCode ?? ""
        ]
    }
}

public extension PassengerInfo {
    func validationState(for rowType: UserInfoRowType, isOptional: Bool) -> ValidationState {
        let result = validateInfo(for: rowType, isOptional: isOptional)
        switch result {
        case .success:
            return .normal
        case .failure(.validationError(let message)):
            return .warning(message)
        }
    }
    
    func validateInfo(for rowType: UserInfoRowType, isOptional: Bool) -> Result<Void, AppError> {
        switch rowType {
        case .givenName:
            if isOptional && givenName.count == 0  {
                return .success(())
            }
            guard givenName.count > 1 else {
                return .failure(.validationError("Please type meaningful given name"))
            }
            
            for chr in givenName {
                if !(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") && chr != " " {
                    return .failure(.validationError("Given name can't contain any special charachter"))
                }
            }
        case .surName:
            if isOptional && surName.count == 0 {
                return .success(())
            }
            guard surName.count > 1 else {
                return .failure(.validationError("Please type meaningful surname"))
            }
            
            for chr in surName {
                if !(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") && chr != " " {
                    return .failure(.validationError("Surname can't contain any special charachter"))
                }
            }
        case .gender:
            if isOptional {
                return .success(())
            }
            guard gender != nil else {
                return .failure(.validationError("Please select gender"))
            }
        case .dob:
            if isOptional {
                return .success(())
            }
            guard let dob = dob else {
                return .failure(.validationError("Please select date of birth"))
            }
            return Date.validateDateOfBirth(dob, tillDate: flightDate, of: travellerType)
        case .mobile:
            if isOptional {
                return .success(())
                
            } else {
                if mobile.isValidPhoneNumber() {
                    return .success(())
                }
                else {
                    return .failure(.validationError("Please provide a valid phone number"))
                }
            }
        case .email:
            if isOptional {
                return .success(())
            }
            
            if email.isEmpty || !email.validateEmailStandard() {
                return .failure(.validationError("Please provide a valid email address"))
            }
        case .nationality:
            if isOptional {
                return .success(())
            }
            if nationality == nil {
                return .failure(.validationError("Please select nationality"))
            }
        case .passportNumber:
            if isOptional {
                if passportNumber.isEmpty {
                    return .success(())
                }
                
                if passportNumber.count == 0 || (((passportNumber.count >= 7 && passportNumber.count <= 9) && passportNumber.isValidAlphaNumeric() && !passportNumber.isValidAlpha()) || ((passportNumber.count >= 7 && passportNumber.count <= 9) && passportNumber.isValidNumeric())) {
                    return .success(())
                }
                
                return .failure(.validationError("Please type a correct passport number"))
                
            } else {
                if ((passportNumber.count >= 7 && passportNumber.count <= 9) && passportNumber.isValidAlphaNumeric() && !passportNumber.isValidAlpha()) || ((passportNumber.count >= 7 && passportNumber.count <= 9) && passportNumber.isValidNumeric()) {
                    return .success(())
                }
                
                return .failure(.validationError("Please type a correct passport number"))
            }
        case .passportExpiryDate:
            if isOptional {
                return .success(())
            }
            guard let expDate = passportExpiryDate else {
                return .failure(.validationError("Please select passport expire date"))
            }
            
            if let minValidDate = Calendar.current.date(byAdding: .month, value: 6, to: flightDate), expDate < minValidDate {
                return .failure(.validationError("Your passport must have validity of at least 6 month for visa processing"))
            }

        case .upload:
            if isOptional {
                return .success(())
            }
            
            if passportURLStr == "" {
                return .failure(.validationError("Users must upload copy of valid passport, visa & other necessary documents while issuing the ticket to avoid cancellation"))
            }
            
            if visaURLStr == "" {
                return .failure(.validationError("Users must upload copy of valid passport, visa & other necessary documents while issuing the ticket to avoid cancellation"))
            }
        default:
            return .success(())
        }
        return .success(())
    }
}

public struct PassengersAdditionalReq {
    public var selectedWheelChairOption = ""
    public var selectedMealPreferenceOption = ""
    public var selectedCovid19Testcode = ""
    public var selectedCovid19TestOption: CovidTestOptions? = nil
    public var covid19TestSubtitle = ""
    public var covid19TestAddress = ""
    public var travelInsuranceSubtitle = ""
    public var selectedTravelInsuranceCode = ""
    public var selectedTravelInsuranceCodeOption: TravelInsuranceOption? = nil
    
    public init() { }

    public init(selectedWheelChairOption: String?, selectedMealPreferenceOption: String) {
        self.selectedWheelChairOption = selectedWheelChairOption ?? ""
        self.selectedMealPreferenceOption = selectedMealPreferenceOption
    }
}
