//
//  FlightPassengerInfoViewModel.swift
//  STFlightKit
//
//  Created by ST-iOS on 12/1/22.
//

import UIKit
import STCoreKit

public protocol FlightPassengerInfoViewModelViewDelegate: AnyObject {
    func validationError(for indexPath: IndexPath, message: String, completion: (()->Void)?)
    func onDataChanged(viewModel: FlightPassengerInfoViewModel)
    func onAddUpdateStatusChanged(viewModel: FlightPassengerInfoViewModel)
    func failedToUpload(with error: String)
    func uploading(progress: Float)
    func uploadFinished()
    func uploadFile(type: FileType, with urlStr: String)
    func passengerInfoFilled(passengerInfo: PassengerInfo, for index: Int)
    func passengerInfoInputDidFinish()
}

public class FlightPassengerInfoViewModel {
    public var addressCellIndex = 0
    public var passengerInfo: PassengerInfo
    public weak var viewDelegate: FlightPassengerInfoViewModelViewDelegate?

    private var accountService: AccountService
    private var isPrimaryPassenger: Bool
    private var isDomesticFlight: Bool
    private var passengerIndex: Int
    private var isAttachmentAvailable: Bool
    private var departureDate: String
    private var covid19TestAddressDetailsText: String = ""
    private let dispatchGroup = DispatchGroup()

    // MARK: - Private Properties
    
    private let analytics: AnalyticsManager = {
        //let me = MixpanelAnalyticsEngine()
        let fae = FirebaseAnalyticsEngine()
        let manager = AnalyticsManager([fae])
        return manager
    }()
    
    private let PRIMARY_USER_CODE = "PRIMARY_USER_CODE"
    private let user = STAppManager.shared.userAccount
    private var shouldValidateRowData: Bool = false
    
    private var quickPickPassengers: [STPassenger] {
        return user?.otherPassengers ?? []
    }
    
    private var selectedPassenger: STPassenger?
    
    private var countries: [Country] {
        return STAppManager.getCountryList()
    }
    
    private var mealSSRList = [SSR]()
    private var wheelChairSSRList = [SSR]()
    private let isSoudiAirline: Bool
    private var selectedWheelChairOption = "None"
    private var selectedMealOption = "None"
    
    private var covid19TestDataResponse: [Covid19TestOptionResponse]?
    private var covid19TestOptionsRowTypeData = [Covid19TestOptionsRowType]()
    private var covidTestCenterResponse: CovidTestCenterDetailsResponse?
    
    private var covid19TestData: [Covid19TestData] = [Covid19TestData]()
    private var covid19TestOriginalData: [Covid19TestData] = [Covid19TestData]()
    private var covid19TestCenterDetails: [Covid19TestCenterDetails] = [Covid19TestCenterDetails]()
    
    // MARK: - Travel Insurance
    private var travelInsuranceDataResponse: [TravelInsuranceAddonServiceResponse]?
    private var travelInsuranceOptionsRowTypeData = [TravelInsuranceOptionsRowType]()
    private var travelInsuranceDetailResponse: TravelInsuranceServiceDetailResponse?
    
    private var travelInsuranceData: [TravelInsuranceData] = [TravelInsuranceData]()
    private var travelInsuranceOrignalData: [TravelInsuranceData] = [TravelInsuranceData]()
    private var travelInsuranceDetails: [TravelInsuranceDetails] = [TravelInsuranceDetails]()
    
    public var shouldAddUpdatePassenger: Bool = true
    
    public var sections: [[UserInfoRowType]] {
        var rows: [UserInfoRowType] = [.quickPick, .givenName, .surName]
        if isSoudiAirline {
            rows.append(.nameInputGuideline)
        }
        
        rows.append(contentsOf: [.gender, .dob, .nationality])
        
        if isPrimaryPassenger {
            rows.append(contentsOf: [.mobile, .email])
        }
        
        if !isDomesticFlight {
            rows.append(contentsOf: [.passportNumber, .passportExpiryDate])
        }
        
        rows.append(contentsOf: [.frequentFlyerNumber])
        
        if !isDomesticFlight {
            rows.append(contentsOf: [.upload])
        }
        
        rows.append(.warning)
        
        rows.append(contentsOf: [
            .mealPreference,
            .wheelChairRequest
        ])
        
        if !isDomesticFlight {
            rows.append(contentsOf: [.covid19TestInfo])
        }
        
        if isDomesticFlight {
            rows.append(contentsOf: [.travelInsuranceService])
        }
        
        rows.append(contentsOf: [
            .addUpdateUserToQuickPick
        ])
        return [rows]
    }
    
    // MARK: - Initialzers
    
    public init(
        passengerInfo: PassengerInfo,
        accountService: AccountService,
        isDomesticFlight: Bool,
        passengerIndex: Int,
        attachment: Bool,
        isSoudiAirline: Bool,
        departureDate: String) {
            self.passengerInfo = passengerInfo
            self.accountService = accountService
            self.isPrimaryPassenger = passengerIndex == 0
            self.isDomesticFlight = isDomesticFlight
            self.passengerIndex = passengerIndex
            self.isAttachmentAvailable = attachment
            self.isSoudiAirline = isSoudiAirline
            self.departureDate = departureDate
            if passengerInfo.code.count > 0 && passengerInfo.code != PRIMARY_USER_CODE {
                for passenger in quickPickPassengers {
                    if self.passengerInfo.code == passenger.code {
                        selectedPassenger = passenger
                        break
                    }
                }
            }
        }
    
    // MARK: Protocol conformation
    
    public var isLoading: Observable<Bool> = Observable(false)
    public var uploadingFile: Observable<FileType?> = Observable(nil)
    
    public var numberOfSection: Int {
        return sections.count
    }
    
    public func numberOfRows(in section: Int) -> Int {
        return sections[section].count
    }
    
    public var selectedIndex: Int {
        if isDomesticFlight {
            return selectedTravelInsuranceOptionIndex
        } else {
            return getSelectedCovid19TestOptionIndex()
        }
    }
    
    public func dataForRow(at indexPath: IndexPath) -> ConfigurableTableViewCellData? {
        let rowType = sections[indexPath.section][indexPath.row]
        let isOptional = FlightPassengerInfoValidator.isOptional(rowType: rowType, isPrimaryPassenger: isPrimaryPassenger, isDomesticFlight: isDomesticFlight, isAttachmentAvailable: self.isAttachmentAvailable)
        switch rowType {
        case .quickPick, .nationality:
            var pickerData = [String]()
            var text: String = ""
            
            if rowType == .quickPick {
                if let user = user {
                    pickerData.append(user.givenName + " " + user.surName)
                }
                pickerData.append(contentsOf: quickPickPassengers.map { $0.givenName + " " + $0.surName })
                
                if passengerInfo.code.count == 0 {
                    text = "Select"
                } else {
                    if passengerInfo.code == PRIMARY_USER_CODE, let user = user {
                        text = user.givenName + " " + user.surName
                    } else if let selectedPassenger = selectedPassenger {
                        text = selectedPassenger.givenName + " " + selectedPassenger.surName
                    }
                }
            } else {
                pickerData = countries.map { $0.name }
                text = passengerInfo.nationality?.name ?? ""
            }
            
            let title = isOptional ? rowType.title : rowType.title + "*"
            let validationState = shouldValidateRowData ? passengerInfo.validationState(for: rowType, isOptional: isOptional) : .normal
            
            let rowViewModel = InputTextSelectionCellData(title: title, text: text, placeholder: rowType.placeholder, imageString: rowType.imageString, pickerData: pickerData, selectedRow: nil, state: validationState)
            return rowViewModel
            
        case .givenName, .surName, .mobile, .email, .passportNumber, .frequentFlyerNumber:
            var text: String = ""
            
            if rowType == .givenName {
                text = passengerInfo.givenName
            } else if rowType == .surName {
                text = passengerInfo.surName
            } else if rowType == .mobile {
                text = passengerInfo.mobile
            } else if rowType == .email {
                text = passengerInfo.email
            } else if rowType == .passportNumber {
                text = passengerInfo.passportNumber
            } else if rowType == .frequentFlyerNumber {
                text = passengerInfo.frequentFlyerNumber
            }
            
            let title = isOptional ? rowType.title : rowType.title + "*"
            let validationState = shouldValidateRowData ? passengerInfo.validationState(for: rowType, isOptional: isOptional) : .normal
            
            let rowViewModel = InputTextFieldCellData(title: title, text: text, placeholder: rowType.placeholder, imageString: rowType.imageString, keyboardType: rowType.keyboardType, textContenType: rowType.textContentType, state: validationState)
            return rowViewModel
            
        case .nameInputGuideline:
            return NameInputGuideCellData.flightInstruction
            
        case .gender:
            let validationState = shouldValidateRowData ? passengerInfo.validationState(for: rowType, isOptional: isOptional) : .normal
            let title = isOptional ? rowType.title : rowType.title + "*"
            
            let rowViewModel = GenderSelectionCellData(title: title, selectedGender: passengerInfo.gender ?? .male, state: validationState)
            return rowViewModel
            
        case .dob, .passportExpiryDate:
            var minDate: Date?
            var maxDate: Date?
            var text: String = ""
            var selectedDate: Date? = nil
            
            if rowType == .dob {
                if passengerInfo.travellerType == .child {
                    minDate = Calendar.current.date(byAdding: .year, value: -12 , to: departureDate.toDate() ?? Date())
                    maxDate = Calendar.current.date(byAdding: .year, value: -2 , to: departureDate.toDate() ?? Date())
                    selectedDate = passengerInfo.dob
                } else if passengerInfo.travellerType == .infant {
                    minDate = Calendar.current.date(byAdding: .year, value: -2, to: departureDate.toDate() ?? Date())
                    maxDate = departureDate.toDate()
                    selectedDate = passengerInfo.dob
                } else {
                    minDate = nil
                    maxDate = Date()
                    selectedDate = passengerInfo.dob
                }
            } else {
                minDate = Calendar.current.date(byAdding: .month, value: 6, to: departureDate.toDate() ?? Date())
                maxDate = nil
                selectedDate = passengerInfo.passportExpiryDate
            }
            
            if let selectedDate = selectedDate {
                text = selectedDate.toString(format: .shortDateFullYear)
            }
            
            let title = isOptional ? rowType.title : rowType.title + "*"
            let validationState = shouldValidateRowData ? passengerInfo.validationState(for: rowType, isOptional: isOptional) : .normal
            
            return SDDateSelectionCellViewModel(title: title, text:text, placeholder: rowType.placeholder, imageString: rowType.imageString, selectedDate: selectedDate, minDate: minDate, maxDate: maxDate, state: validationState)
            
        case .upload:
            let hasPassportCopy = passengerInfo.passportURLStr.count > 0
            let hasVisaCopy = passengerInfo.visaURLStr.count > 0
            let rowViewModel = InfoUploadCellData(hasPassportCopy: hasPassportCopy, hasVisaCopy: hasVisaCopy)
            return rowViewModel
            
        case .addUpdateUserToQuickPick:
            var title: String = ""
            var enabled: Bool = true
            var checked: Bool = shouldAddUpdatePassenger
            
            if passengerInfo.code.count == 0 {
                title = "Add this person to quick pick"
            } else {
                if hasUpdate() {
                    title = "Update this person in quick pick"
                } else {
                    title = "Update this person in quick pick"
                    enabled = false
                    checked = false
                }
            }
            
            let rowViewModel = CheckboxCellData(title: title, checkboxChecked: checked, enabled: enabled)
            
            return rowViewModel
        default:
            return nil
        }
    }
    
    //MARK:- Meal Preference and WheelChair Functionalities
    public func getSelectedMealPreferenceIndex() -> Int {
        if let pref = passengerInfo.mealPreferenceSSR {
            for (idx, ssr) in mealSSRList.enumerated() {
                if ssr.code == pref {
                    return idx + 1
                }
            }
        }
        return 0
    }
    
    public func onSelectMealPreference(index: Int) {
        if index == 0 {
            passengerInfo.mealPreferenceSSR = nil
            return
        }
        selectedMealOption = mealSSRList[index - 1].name
        passengerInfo.mealPreferenceSSR = mealSSRList[index-1].code
        
    }
    
    public func getWheelChairOptions() -> [String] {
        var options = ["None"]
        wheelChairSSRList.forEach { ssr in
            options.append(ssr.name)
        }
        return options
    }
    
    public func getSelectedWheelChairOptionIndex() -> Int {
        if let pref = passengerInfo.wheelChairRequestSSR {
            for (idx, ssr) in wheelChairSSRList.enumerated() {
                if ssr.code == pref {
                    return idx + 1
                }
            }
        }
        return 0
    }
    
    public func onSelectWheelChairPreference(index: Int) {
        if index == 0 {
            passengerInfo.wheelChairRequestSSR = nil
            return
        }
        selectedWheelChairOption = wheelChairSSRList[index-1].name
        passengerInfo.wheelChairRequestSSR = wheelChairSSRList[index-1].code
    }
    
    public func getMealPreferenceOptions() -> [String] {
        var options = ["None"]
        mealSSRList.forEach { ssr in
            options.append(ssr.name)
        }
        return options
    }
    
    // MARK: - Travel Insurance Functionalities
    public var travelInsuranceOptions: [String] {
        var options = [String]()
        for item in 0..<travelInsuranceData.count {
            options.append(travelInsuranceData[item].dispayName ?? "")
        }
        return options
    }
    
    public var selectedTravelInsuranceOptionIndex: Int {
        var defaultSelectedIndex = 0
        for item in 0..<travelInsuranceData.count {
            if travelInsuranceData[item].option?.defaultOption == 1 {
                defaultSelectedIndex = item
            }
            if passengerInfo.travelInsurance.optionsCode == travelInsuranceData[item].option?.code {
                return item
            }
        }
        return defaultSelectedIndex
    }
    
    public var gettravelInsuranceDetails : (htmlStr: String, name: String) {
        return (htmlStr: self.travelInsuranceDetailResponse?.description ?? "", name: self.travelInsuranceDetailResponse?.name ?? "")
    }
    
    public func travelInsuranceNameTypeInfo(with index: Int, name: String) {
        if travelInsuranceData.count > 0 {
            travelInsuranceData[index].dispayName = name
        }
    }
    
    public func onSelectTravelInsurancePreference(index: Int) {
        passengerInfo.travelInsurance = travelInsuranceData[index].isSelfRisk == 1 ? TravelInsuranceInfo(code: "", optionsCode: "") : TravelInsuranceInfo(code: travelInsuranceData[index].code ?? "", optionsCode: travelInsuranceData[index].option?.code ?? "")
    }
    
    public func generateTravelInsuranceOptionsRowTypeData(wihSelected row: Int) {
        travelInsuranceOptionsRowTypeData.removeAll()
        for item in 0..<travelInsuranceData.count {
            travelInsuranceOptionsRowTypeData.append(travelInsuranceData[item].cellType)
        }
    }
    
    public var travelInsuranceOptionsRowData: [TravelInsuranceOptionsRowType] {
        return travelInsuranceOptionsRowTypeData
    }
    
    public func getTravelInsuranceSubtitleString(using row: Int) -> String {
        var travelInsuranceSubTitleStr = ""
        if travelInsuranceData.count > 0 {
            travelInsuranceSubTitleStr = travelInsuranceData[row].dispayName ?? ""
        }
        return travelInsuranceSubTitleStr
    }
    
    public func getTravelInsurancePriceInfo(withSelected row: Int) -> NSMutableAttributedString {
        let travelInsurancePriceStr: NSMutableAttributedString = NSMutableAttributedString()
        if travelInsuranceData.count > 0 {
            let priceString = NSAttributedString(string: (travelInsuranceData[row].option?.price ?? 0).withCommas() + "BDT ", attributes:
                                                    [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                                                     NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                                                     NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)])
            
            let spaceString = NSAttributedString(string: " ")
            
            let discountPriceString = NSAttributedString(string: (travelInsuranceData[row].option?.discountPrice ?? 0).withCommas() + "BDT", attributes:
                                                            [NSAttributedString.Key.foregroundColor: UIColor.orange,
                                                             NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
            
            travelInsurancePriceStr.append(priceString)
            travelInsurancePriceStr.append(spaceString)
            travelInsurancePriceStr.append(discountPriceString)
        }
        
        return travelInsurancePriceStr
    }
    
    public func generateTravelInsuranceData() {
        self.travelInsuranceData.removeAll()
        
        let emptyChargeData = TravelInsuranceData()
        self.travelInsuranceData.append(emptyChargeData)
        
        guard let travelInsuranceDataResponse else { return }
        
        for insurance in travelInsuranceDataResponse {
            guard let insuranceOptions = insurance.options else {
                return
            }

            if insuranceOptions.count <= 0 {
                let insuranceData = TravelInsuranceData(
                    name: insurance.name,
                    dispayName: insurance.name,
                    isSelfRisk: insurance.selfRisk,
                    cellType: .optionSelect
                )
                self.travelInsuranceData.append(insuranceData)
                
            } else {
                for insuranceOption in insuranceOptions {
                    let insuranceData = TravelInsuranceData(
                        code: insurance.code,
                        name: insurance.name,
                        dispayName: ("\(insurance.name ?? "") , \(insuranceOption.name ?? "")"),
                        isSelfRisk: insurance.selfRisk,
                        cellType: .optionSelect,
                        option: insuranceOption
                    )
                    self.travelInsuranceData.append(insuranceData)
                }
            }
        }
        
        ///extra cell data for learn more cell
        let emptylearnMoreData = TravelInsuranceData(cellType: .learnMore)
        
        self.travelInsuranceData.append(emptylearnMoreData)
    }
    
    public func nameVisibilityStatus(withSelected row: Int) {
        for index in 0..<travelInsuranceData.count {
            travelInsuranceData[index].isVisibleName = false
        }
        
        if travelInsuranceData.indices.contains(row) {
            if travelInsuranceData[row].name != nil {
                travelInsuranceData[row].isVisibleName = true
            }
        }
    }
    
    public func generateTravelInsuranceDetailData() {
        self.travelInsuranceDetails.removeAll()
        let totalOptions = self.travelInsuranceDataResponse?.count ?? 0
        
        for option in 0..<totalOptions {
            
            let insuranceData = TravelInsuranceDetails(
                name: self.travelInsuranceDataResponse?[option].name ?? "",
                imageUrl: self.travelInsuranceDataResponse?[option].logo ?? "",
                code: self.travelInsuranceDataResponse?[option].code ?? "")
            travelInsuranceDetails.append(insuranceData)
        }
    }
    
    public var travelInsuranceDetailsData: [TravelInsuranceDetails] {
        return self.travelInsuranceDetails
    }
    
    
    //MARK:- Covid19 Test Functionalities
    public func getCovid19TestOptions() -> [String] {
        var options = [String]()
        for item in 0..<covid19TestData.count {
            options.append(covid19TestData[item].displayName ?? "")
        }
        return options
    }
    
    public func getSelectedCovid19TestOptionIndex() -> Int {
        var defaultSelectedIndex = 0
        for item in 0..<covid19TestData.count {
            if covid19TestData[item].isSelfTest == true {
                defaultSelectedIndex = item
            }
            if passengerInfo.covid.optionsCode == covid19TestData[item].option?.code {
                return item
            }
        }
        return defaultSelectedIndex
    }
    
    public func getCovid19TestCenterDetails() -> (htmlStr: String, testCenterName: String){
        return (htmlStr: self.covidTestCenterResponse?.description ?? "", testCenterName: self.covidTestCenterResponse?.name ?? "")
    }
    
    public func setCovid19TestAddressInfo(with addressStr: String, and index: Int) {
        if covid19TestData.count > 0 {
            covid19TestData[index].testAddress = addressStr
        }
    }
    
    public func getCovid19TestAddressInfo(with index: Int) -> String {
        if covid19TestData.count > 0 {
            if covid19TestData[index].isAddressInfoVisible == true && covid19TestData[index].option?.isAddress == true {
                return covid19TestData[index].testAddress ?? ""
            }
        }
        return ""
    }
    
    public func onSelectCovid19TestPreference(index: Int) {
        let covidTestInfo = CovidTestInfo(code: covid19TestData[index].code ?? "", optionsCode: covid19TestData[index].option?.code ?? "", address: "", selfTest: covid19TestData[index].isSelfTest ?? false)
        passengerInfo.covid = covidTestInfo
    }
    
    public func getPassengerAdditionalRequirements(with row: Int) -> PassengersAdditionalReq {
        var additionalRequirements = PassengersAdditionalReq(
            selectedWheelChairOption: selectedWheelChairOption,
            selectedMealPreferenceOption: selectedMealOption
        )
        
        if isDomesticFlight {
            guard row >= 0 && row < travelInsuranceData.count else {
                return additionalRequirements
            }
            
            additionalRequirements.travelInsuranceSubtitle = travelInsuranceData[row].name ?? ""
            additionalRequirements.selectedTravelInsuranceCode = travelInsuranceData[row].code ?? ""
            additionalRequirements.selectedTravelInsuranceCodeOption = travelInsuranceData[row].option
            
            return additionalRequirements
            
        } else {
            guard row >= 0 && row < travelInsuranceData.count else {
                return additionalRequirements
            }
            
            passengerInfo.covid.address = covid19TestData[row].testCenterAddress
            
            additionalRequirements.covid19TestSubtitle = covid19TestAddressDetailsText
            additionalRequirements.selectedCovid19TestOption = covid19TestData[row].option
            additionalRequirements.selectedCovid19Testcode = covid19TestData[row].code ?? ""
            additionalRequirements.covid19TestAddress = covid19TestData[row].testCenterAddress
            
            return additionalRequirements
        }
    }
    
    public func generateCovid19TestOptionRows() {
        covid19TestOptionsRowTypeData.removeAll()
        for item in 0..<covid19TestData.count {
            covid19TestOptionsRowTypeData.append(covid19TestData[item].cellType)
        }
    }
    
    public var covid19TestOptionsRowTypes: [Covid19TestOptionsRowType] {
        return covid19TestOptionsRowTypeData
    }
    
    public func getCovid19TestSubtitleString(using row: Int) -> String {
        var covid19TestSubtitleStr = ""
        
        guard row >= 0 && row < covid19TestData.count else { return covid19TestSubtitleStr }
        
        if covid19TestData[row].isSelfTest == true {
            covid19TestSubtitleStr = covid19TestData[row].name ?? ""
        } else {
            covid19TestSubtitleStr = covid19TestData[row].covid19SubtitleText
        }
        
        self.covid19TestAddressDetailsText = covid19TestSubtitleStr
        
        return covid19TestSubtitleStr
    }
    
    public func getCovid19TestPriceInfo(withSelected row: Int) -> NSMutableAttributedString {
        let covidTestPriceString: NSMutableAttributedString = NSMutableAttributedString()
        if covid19TestData.count > 0 {
            let defaultDisocuntPrice = NSAttributedString(string:"0 BDT", attributes: [NSAttributedString.Key.foregroundColor: UIColor.orange,NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
            
            var priceString: NSAttributedString = NSAttributedString()
            var discountPriceString: NSAttributedString = NSAttributedString()
            var spaceString: NSAttributedString = NSAttributedString()
            
            if covid19TestData[row].isSelfTest == true {
                covidTestPriceString.append(defaultDisocuntPrice)
            } else {
                priceString = NSAttributedString(string: (covid19TestData[row].option?.price ?? 0).withCommas() + "BDT ", attributes:
                                                    [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                                                     NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                                                     NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)])
                
                spaceString = NSAttributedString(string: " ")
                
                discountPriceString = NSAttributedString(string: (covid19TestData[row].option?.discountPrice ?? 0).withCommas() + "BDT", attributes:
                                                            [NSAttributedString.Key.foregroundColor: UIColor.orange,
                                                             NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
                
                covidTestPriceString.append(priceString)
                covidTestPriceString.append(spaceString)
                covidTestPriceString.append(discountPriceString)
            }
        }
        return covidTestPriceString
    }
    
    public func generateCovid19TestData() {
        self.covid19TestData.removeAll()
        ///Add an empty cell data for amount cell
        let emptyTestChargeData = Covid19TestData(code: "-", name: nil, displayName: nil, isAddressInfoVisible: false, isSelfTest: false, testAddress: "", cellType: .testCharge, option: nil)
        self.covid19TestData.append(emptyTestChargeData)
        
        ///test label info cell data
        let totalOptions = self.covid19TestDataResponse?.count ?? 0
        for option in 0..<totalOptions {
            
            let totalTestOptions = self.covid19TestDataResponse?[option].options?.count ?? 0
            if totalTestOptions == 0 {
                
                ///Check self test has any option or not
                if self.covid19TestDataResponse?[option].selfTest == true {
                    let testData = Covid19TestData(
                        code: "",
                        name: "I will test myself",
                        displayName: covid19TestDataResponse?[option].name,
                        isAddressInfoVisible: false,
                        isSelfTest: self.covid19TestDataResponse?[option].selfTest,
                        testAddress: "",
                        cellType: .optionSelect,
                        option: nil
                    )
                    self.covid19TestData.append(testData)
                }
            }else if totalTestOptions > 0 {
                for testOption in 0..<totalTestOptions {
                    
                    ///Add available test options
                    let testData = Covid19TestData(
                        code: self.covid19TestDataResponse?[option].code ?? "",
                        name: self.covid19TestDataResponse?[option].name ?? "",
                        displayName: (
                            self.covid19TestDataResponse?[option].selfTest ?? false ?
                            (self.covid19TestDataResponse?[option].name ?? "") :
                                ("\(self.covid19TestDataResponse?[option].name ?? ""), \(self.covid19TestDataResponse?[option].options?[testOption].name ?? "")")
                        ),
                        isAddressInfoVisible: false,
                        isSelfTest: self.covid19TestDataResponse?[option].selfTest,
                        testAddress: "",
                        cellType: .optionSelect,
                        option: self.covid19TestDataResponse?[option].options?[testOption]
                    )
                    self.covid19TestData.append(testData)
                }
            }
        }
        
        ///extra cell data for learn more cell
        let emptyLearnMoreData = Covid19TestData(code: "-", name: nil, displayName: nil, isAddressInfoVisible: false, isSelfTest: false, testAddress: "", cellType: .learnMore, option: nil)
        self.covid19TestData.append(emptyLearnMoreData)
    }
    
    public func setAddressVisibilityStatus(withSelected row: Int){
        for index in 0..<covid19TestData.count{
            covid19TestData[index].isAddressInfoVisible = false
        }
        
        if covid19TestData.indices.contains(row) {
            if covid19TestData[row].option?.isAddress == true {
                covid19TestData[row].isAddressInfoVisible = true
            }
        }
    }
    
    public func getAddressVisibilityStatus(withSelected row: Int) -> Bool {
        return covid19TestData[row].isAddressInfoVisible ?? false
    }
    
    public func generateCovidTestCenterDetailsData() {
        self.covid19TestCenterDetails.removeAll()
        let totalOptions = self.covid19TestDataResponse?.count ?? 0
        for option in 0..<totalOptions {
            if covid19TestDataResponse?[option].selfTest == false {
                covid19TestCenterDetails.append(Covid19TestCenterDetails(name: self.covid19TestDataResponse?[option].name ?? "", imageUrl: self.covid19TestDataResponse?[option].logo ?? "", code: self.covid19TestDataResponse?[option].code ?? ""))
            }
        }
    }
    
    public func getCovidTestCenterDetailsData() -> [Covid19TestCenterDetails]{
        return self.covid19TestCenterDetails
    }
    
    // MARK: - Private functions
    private func country(for code: String) -> Country? {
        for country in countries {
            if country.code == code {
                return country
            }
        }
        return nil
    }
    
    private func updatedFields() -> [String: Any] {
        var updatedFields: [String: Any] = [:]
        
        let code = passengerInfo.code
        updatedFields[Constants.APIParameterKey.titleName] = passengerInfo.titleName.rawValue
        
        if code.count == 0 ||
            passengerInfo.givenName != (code == PRIMARY_USER_CODE ? user?.givenName : selectedPassenger?.givenName) {
            updatedFields[Constants.APIParameterKey.givenName] = passengerInfo.givenName
        }
        if code.count == 0 ||
            passengerInfo.surName != (code == PRIMARY_USER_CODE ? user?.surName : selectedPassenger?.surName) {
            updatedFields[Constants.APIParameterKey.surName] = passengerInfo.surName
        }
        if code.count == 0 ||
            passengerInfo.gender != (code == PRIMARY_USER_CODE ? user?.gender : selectedPassenger?.gender) {
            updatedFields[Constants.APIParameterKey.gender] = passengerInfo.gender?.rawValue
        }
        if code.count == 0 ||
            passengerInfo.dob?.toString(format: .isoDate) != (code == PRIMARY_USER_CODE ? user?.dateOfBirth : selectedPassenger?.dateOfBirth) {
            updatedFields[Constants.APIParameterKey.dateOfBirth] = passengerInfo.dob?.toString(format: .isoDate)
        }
        if code.count == 0 ||
            passengerInfo.nationality?.code != (code == PRIMARY_USER_CODE ? user?.nationality : selectedPassenger?.nationality) {
            updatedFields[Constants.APIParameterKey.nationality] = passengerInfo.nationality?.code
        }
        if code.count == 0 ||
            passengerInfo.mobile != (code == PRIMARY_USER_CODE ? user?.mobileNumber : selectedPassenger?.mobileNumber) {
            updatedFields[Constants.APIParameterKey.mobileNumber] = passengerInfo.mobile
        }
        if code.count == 0 ||
            passengerInfo.email != (code == PRIMARY_USER_CODE ? user?.email : selectedPassenger?.email) {
            updatedFields[Constants.APIParameterKey.email] = passengerInfo.email
        }
        if code.count == 0 ||
            passengerInfo.passportNumber != (code == PRIMARY_USER_CODE ? user?.passportNumber : selectedPassenger?.passportNumber) {
            updatedFields[Constants.APIParameterKey.passportNumber] =  passengerInfo.passportNumber
        }
        if code.count == 0 ||
            passengerInfo.passportExpiryDate?.toString(format: .isoDate) != (code == PRIMARY_USER_CODE ? user?.passportExpireDate : selectedPassenger?.passportExpireDate) {
            updatedFields[Constants.APIParameterKey.passportExpireDate] = passengerInfo.passportExpiryDate?.toString(format: .isoDate)
        }
        if code.count == 0 ||
            passengerInfo.frequentFlyerNumber != (code == PRIMARY_USER_CODE ? user?.frequentFlyerNumber : selectedPassenger?.frequentFlyerNumber) {
            updatedFields[Constants.APIParameterKey.frequentFlyerNumber] = passengerInfo.frequentFlyerNumber
        }
        
        if code.count == 0 ||
            passengerInfo.passportURLStr != (code == PRIMARY_USER_CODE ? user?.passportCopy: selectedPassenger?.passportCopy) {
            updatedFields[Constants.APIParameterKey.passportCopy] = passengerInfo.passportURLStr
        }
        
        if code.count == 0 ||
            passengerInfo.visaURLStr != (code == PRIMARY_USER_CODE ? user?.visaCopy: selectedPassenger?.visaCopy) {
            updatedFields[Constants.APIParameterKey.visaCopy] = passengerInfo.visaURLStr
        }
        
        return updatedFields
    }
    
    private func onSelectUserFromQuickPick(selectedRow: Int) {
        analytics.log(FlightEvent.selectPassengerFromQuickPick())
        
        shouldAddUpdatePassenger = false
        
        if selectedRow == 0 {
            passengerInfo.code = PRIMARY_USER_CODE
            
            guard let user = user else {
                return
            }
            
            passengerInfo.givenName = user.givenName
            passengerInfo.surName = user.surName
            passengerInfo.gender = user.gender
            passengerInfo.dob = Date(fromString: user.dateOfBirth ?? "", format: .isoDate)
            passengerInfo.nationality = country(for: user.nationality)
            passengerInfo.mobile = user.mobileNumber
            passengerInfo.email = user.email
            passengerInfo.passportNumber = user.passportNumber
            passengerInfo.passportExpiryDate = Date(fromString: user.passportExpireDate ?? "", format: .isoDate)
            passengerInfo.frequentFlyerNumber = user.frequentFlyerNumber
            passengerInfo.passportURLStr = user.passportCopy
            passengerInfo.visaURLStr = user.visaCopy
            
        } else {
            let selectedPassenger = quickPickPassengers[selectedRow - 1]
            passengerInfo.code = selectedPassenger.code
            self.selectedPassenger = selectedPassenger
            
            passengerInfo.givenName = selectedPassenger.givenName
            passengerInfo.surName = selectedPassenger.surName
            passengerInfo.gender = selectedPassenger.gender
            passengerInfo.dob = Date(fromString: selectedPassenger.dateOfBirth , format: .isoDate)
            passengerInfo.nationality = country(for: selectedPassenger.nationality)
            passengerInfo.mobile = selectedPassenger.mobileNumber
            passengerInfo.email = selectedPassenger.email
            passengerInfo.passportNumber = selectedPassenger.passportNumber ?? ""
            passengerInfo.passportExpiryDate = Date(fromString: selectedPassenger.passportExpireDate ?? "" , format: .isoDate)
            passengerInfo.frequentFlyerNumber = selectedPassenger.frequentFlyerNumber ?? ""
            passengerInfo.passportURLStr = selectedPassenger.passportCopy ?? ""
            passengerInfo.visaURLStr = selectedPassenger.visaCopy ?? ""
        }
        
        viewDelegate?.onDataChanged(viewModel: self)
    }
    
    private func hasUpdate() -> Bool {
        if passengerInfo.code.count == 0 {
            return false
        }
        
        return updatedFields().count > 0
    }
    
    deinit {
        STLog.info("\(String(describing: self)) deinit")
    }
}
//MARK:- API Calls
public extension FlightPassengerInfoViewModel {
    func fetchAdditionalRequirements(onCompletion: @escaping (Bool) -> Void) {
        isLoading.value = true
        fetchSSRCodes()
        fetchCovid19TestOptions()
        fetchTravelInsurance()
        
        dispatchGroup.notify(queue: .main) {
            self.isLoading.value = false
            onCompletion(true)
        }
    }
    
    private func fetchSSRCodes() {
        dispatchGroup.enter()
        FlightAPIClient().fetchSSRCodes { [weak self ]response in
            switch response {
            case .success(let response):
                if let ssrTypes = response.response {
                    self?.fetchCovid19TestOptions()
                    self?.fetchTravelInsurance()
                    for ssrType in ssrTypes {
                        if ssrType.type == "Meal" {
                            self?.mealSSRList = ssrType.ssr
                        } else if ssrType.type ==  "Wheelchair" {
                            self?.wheelChairSSRList = ssrType.ssr
                        }
                    }
                } else {
                    STLog.error(response.message)
                }
                self?.dispatchGroup.leave()
            case .failure(let error):
                STLog.error(error)
                self?.dispatchGroup.leave()
            }
        }
    }
    
    private func fetchCovid19TestOptions() {
        dispatchGroup.enter()
        FlightAPIClient().fetchCovid19TestInfo{ [weak self] response in
            switch response {
            case .success(let response):
                if let covid19Testdata = response.response {
                    self?.covid19TestDataResponse = covid19Testdata
                    self?.generateCovid19TestData()
                    self?.generateCovidTestCenterDetailsData()
                } else {
                    STLog.error(response.message)
                }
                self?.dispatchGroup.leave()
            case .failure(let error):
                STLog.error(error)
                self?.dispatchGroup.leave()
            }
        }
        
        /*
         let path = Bundle.main.path(forResource: "Covid19Test", ofType: "json")!
         let jsonData = try! String(contentsOfFile: path).data(using: .utf8)!
         let response = try! JSONDecoder().decode(Response<[Covid19TestOptionResponse]>.self, from: jsonData)
         self.covid19Testdata = response.response
         self.generateCovid19TestTableData()
         self.generateCovidTestCenterDetailsData()
         */
        
    }
    
    func fetchCovid19TestCenterDetails(withCode: String, onCompletion: @escaping (Bool) -> Void) {
        FlightAPIClient().fetchCovid19TestCenterDetails(withCode: withCode) { [weak self] response in
            switch response {
            case .success(let response):
                if let covidTestCenterResponse = response.response {
                    self?.covidTestCenterResponse = covidTestCenterResponse
                    onCompletion(true)
                } else {
                    STLog.error(response.message)
                    onCompletion(false)
                }
            case .failure(let error):
                STLog.error(error)
                onCompletion(false)
            }
        }
    }
    
    // MARK: - Travel Insurance Service API Call
    private func fetchTravelInsurance() {
        dispatchGroup.enter()
        FlightAPIClient().fetchTravelInsurance { [weak self] result in
            switch result {
            case .success(let response):
                if let travelInsuranceData = response.response {
                    self?.travelInsuranceDataResponse = travelInsuranceData
                    self?.generateTravelInsuranceData()
                    self?.generateTravelInsuranceDetailData()
                } else {
                    STLog.info(response.message)
                }
                self?.dispatchGroup.leave()
            case .failure(let error):
                STLog.error(error)
                self?.dispatchGroup.leave()
            }
        }
    }
    
    func fetchTravelInsuranceDetails(code: String, onCompletion: @escaping (Bool) -> Void) {
        FlightAPIClient().fetchTravelInsuranceDetails(code: code) { [weak self] result in
            switch result {
            case .success(let response):
                if let insuranceDetailResponse = response.response {
                    self?.travelInsuranceDetailResponse = insuranceDetailResponse
                    onCompletion(true)
                } else {
                    STLog.info(response.message)
                    onCompletion(false)
                }
            case .failure(let error):
                STLog.info(error)
                onCompletion(false)
            }
        }
    }
}

public struct Covid19TestData {
    public let code: String?
    public let name: String?
    public let displayName: String?
    public var isAddressInfoVisible: Bool?
    public let isSelfTest: Bool?
    public var testAddress: String?
    public let cellType: Covid19TestOptionsRowType
    public let option: CovidTestOptions?
    
    public init(code: String?, name: String?, displayName: String?, isAddressInfoVisible: Bool? = nil, isSelfTest: Bool?, testAddress: String? = nil, cellType: Covid19TestOptionsRowType, option: CovidTestOptions?) {
        self.code = code
        self.name = name
        self.displayName = displayName
        self.isAddressInfoVisible = isAddressInfoVisible
        self.isSelfTest = isSelfTest
        self.testAddress = testAddress
        self.cellType = cellType
        self.option = option
    }
    
    var testCenterAddress: String {
        return option?.isAddress == true ? (testAddress ?? "") : ""
    }
    
    var covid19SubtitleText: String {
        var subTitle = ""
        if option?.isAddress == false {
            subTitle = displayName ?? ""
        } else {
            subTitle = (name ?? "") + ", " + "Home collection from " + (testAddress ?? "")
        }
        return subTitle
    }
}

public struct Covid19TestCenterDetails {
    public let name: String?
    public let imageUrl: String?
    public let code: String
    
    public init(name: String?, imageUrl: String?, code: String) {
        self.name = name
        self.imageUrl = imageUrl
        self.code = code
    }
}

public struct TravelInsuranceData {
    public var code: String?
    public var name: String?
    public var dispayName: String?
    public var isVisibleName: Bool?
    public var isSelfRisk: Int
    public var cellType: TravelInsuranceOptionsRowType
    public var option: TravelInsuranceOption?
    
    public init() {
        self.code = ""
        self.name = ""
        self.dispayName = nil
        self.isVisibleName = nil
        self.isSelfRisk = 0
        self.cellType = .charge
        self.option = nil
    }
    
    init(name: String? = nil, dispayName: String? = nil, isSelfRisk: Int, cellType: TravelInsuranceOptionsRowType) {
        self.code = ""
        self.name = name
        self.dispayName = dispayName
        self.isVisibleName = nil
        self.isSelfRisk = isSelfRisk
        self.cellType = cellType
        self.option = nil
    }
    
    init(code: String? = nil, name: String? = nil, dispayName: String? = nil, isVisibleName: Bool? = nil, isSelfRisk: Int, cellType: TravelInsuranceOptionsRowType, option: TravelInsuranceOption? = nil) {
        self.code = code
        self.name = name
        self.dispayName = dispayName
        self.isVisibleName = isVisibleName
        self.isSelfRisk = isSelfRisk
        self.cellType = cellType
        self.option = option
    }
    
    init(cellType: TravelInsuranceOptionsRowType) {
        self.code = ""
        self.name = ""
        self.dispayName = nil
        self.isVisibleName = nil
        self.isSelfRisk = 0
        self.cellType = cellType
        self.option = nil
    }
}

public struct TravelInsuranceDetails {
    public let name: String?
    public let imageUrl: String?
    public let code: String
    
    public init(name: String?, imageUrl: String?, code: String) {
        self.name = name
        self.imageUrl = imageUrl
        self.code = code
    }
}

//MARK:- Submittion and delegate conformations
public extension FlightPassengerInfoViewModel {
    func submit() {
        for section in 0..<sections.count {
            for row in 0..<sections[section].count {
                let indexPath = IndexPath(row: row, section: section)
                let isOptional = FlightPassengerInfoValidator.isOptional(rowType: sections[section][row], isPrimaryPassenger: isPrimaryPassenger, isDomesticFlight: isDomesticFlight, isAttachmentAvailable: self.isAttachmentAvailable)
                let result = passengerInfo.validateInfo(for: sections[section][row], isOptional: isOptional)
                
                switch result {
                case .failure(.validationError(let message)):
                    shouldValidateRowData = true
                    viewDelegate?.validationError(for: indexPath, message: message, completion: { [weak self] in
                        self?.shouldValidateRowData = false
                    })
                    return
                case .success:
                    break
                }
            }
        }
        
        if !shouldAddUpdatePassenger {
            viewDelegate?.passengerInfoFilled(passengerInfo: passengerInfo, for: passengerIndex)
            return
        }
        
        isLoading.value = true
        let completionHandler = { [weak self] (user: STUserAccount?) in
            guard let strongSelf = self else { return }
            strongSelf.viewDelegate?.passengerInfoFilled(passengerInfo: strongSelf.passengerInfo, for: strongSelf.passengerIndex)
            strongSelf.isLoading.value = false
        }
        
        if hasUpdate() {
            guard passengerInfo.code.count > 0 else {
                return
            }
            
            if passengerInfo.code == PRIMARY_USER_CODE {
                accountService.updateProfile(params: updatedFields(), completion: completionHandler)
            } else {
                var params = passengerInfo.passengerDictionary
                params[Constants.APIParameterKey.code] = passengerInfo.code
                accountService.addQuickPick(params: params, completion: completionHandler)
            }
        } else {
            accountService.addQuickPick(params: passengerInfo.passengerDictionary, completion: completionHandler)
        }
    }
    
    func didFinish() {
        viewDelegate?.passengerInfoInputDidFinish()
    }
    
    func didFinishPickingMedia(for fileType: FileType, mediaData: Data) {
        isLoading.value = true
        uploadingFile.value = fileType
        
        let request  = accountService.uploadImageFile(imageData: mediaData, onSuccess: { [weak self] path in
            // save path for proper user
            if fileType == .passport {
                self?.passengerInfo.passportURLStr = path
            } else if fileType == .visa {
                self?.passengerInfo.visaURLStr = path
            }
            
            self?.isLoading.value = false
            self?.uploadingFile.value = nil
            self?.viewDelegate?.uploadFinished()
        }, onFailure: { [weak self] message in
            self?.viewDelegate?.failedToUpload(with: message)
            self?.isLoading.value = false
            self?.uploadingFile.value = nil
        })
        
        request.uploadProgress(queue: .main, closure: { [weak self] progress in
            self?.viewDelegate?.uploading(progress: Float(progress.fractionCompleted))
        })
    }
}

//MARK:- TextInputDelegate
public extension FlightPassengerInfoViewModel {
    func didChangeText(for indexPath: IndexPath?, text: String?) {
        guard let indexPath = indexPath, let text = text else {
            return
        }
        
        STLog.info("Text changed to:\(String(describing: text)) for \(String(describing: indexPath))")
        
        let rowType = sections[indexPath.section][indexPath.row]
        switch rowType {
        case .givenName:
            passengerInfo.givenName = text
        case .surName:
            passengerInfo.surName = text
        case .mobile:
            passengerInfo.mobile = text
        case .email:
            passengerInfo.email = text
        case .passportNumber:
            passengerInfo.passportNumber = text
        case .frequentFlyerNumber:
            passengerInfo.frequentFlyerNumber = text
        default:
            break
        }
        
        viewDelegate?.onAddUpdateStatusChanged(viewModel: self)
    }
}

//MARK:- TextSelectionDelegate
public extension FlightPassengerInfoViewModel {
    func didSelectText(for indexPath: IndexPath?, text: String?, selectedRow: Int) {
        guard let indexPath = indexPath else {
            return
        }
        
        STLog.info("Text changed to:\(String(describing: text)) for \(String(describing: indexPath))")
        
        let rowType = sections[indexPath.section][indexPath.row]
        switch rowType {
        case .quickPick:
            onSelectUserFromQuickPick(selectedRow: selectedRow)
        case .nationality:
            passengerInfo.nationality = countries[selectedRow]
        default:
            break
        }
        
        viewDelegate?.onAddUpdateStatusChanged(viewModel: self)
    }
}

public extension FlightPassengerInfoViewModel {
    func didSelectDoB(_ dob: Date?) {
        passengerInfo.dob = dob
        viewDelegate?.onAddUpdateStatusChanged(viewModel: self)
    }
}

//MARK:- GenderSelectionDelegate
public extension FlightPassengerInfoViewModel {
    func genderSelectionChanged(for indexPath: IndexPath?, selectedGender: GenderType) {
        guard let indexPath = indexPath else {
            return
        }
        
        STLog.info("Gender changed to:\(String(describing: selectedGender)) for \(String(describing: indexPath))")
        
        let rowType = sections[indexPath.section][indexPath.row]
        if rowType == .gender {
            passengerInfo.gender = selectedGender
        }
        
        viewDelegate?.onAddUpdateStatusChanged(viewModel: self)
    }
}

//MARK:- InfoUploadCellDelegate
public extension FlightPassengerInfoViewModel {
    func uploadButtonTapped(type: FileType, indexPath: IndexPath) {
        let urlStr = type == .passport ? passengerInfo.passportURLStr : passengerInfo.visaURLStr
        if type == .passport {
            analytics.log(FlightEvent.uploadPassport())
        }
        viewDelegate?.uploadFile(type: type, with: urlStr)
    }
}

