//
//  FlightVerifyInfoTableVC.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 11/26/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit


enum InfoCellType: Int, CaseIterable {
    case name
    case gender
    case passportNumber
    case nationality
    case passportVisaCopy
    case mealPreference
    case wheelchair
    case covid19Test
    case travelInsurance

    var title: (String, String) {
        switch self {
        case .name:
            return ("Full Name (Given Name + Surname)","")
        case .gender:
            return ("Gender", "Date of Birth")
        case .passportNumber:
            return ("Passport Number", "Passport Expiry Date")
        case .nationality:
            return ("Nationality", "FFN (If any)")
        case .passportVisaCopy:
            return ("", "")
        case .mealPreference:
            return ("Selected meal type", "")
        case .wheelchair:
            return ("Request wheelchair", "")
        case .covid19Test:
            return ("COVID-19 test", "")
        case .travelInsurance:
            return ("Travel Insurance", "")
        }
    }
    var iconName: (String, String) {
        switch self {
        case .name:
            return ("profile-mono", "")
        case .gender:
            return ("male-mono", "calander-mono")
        case .passportNumber:
            return ("passport-mono", "calander-mono")
        case .nationality:
            return ("flag-mono", "ffn-mono")
        case .passportVisaCopy:
            return ("","")
        case .covid19Test:
            return ("covid-mono","")
        case .mealPreference:
            return ("meal-mono", "")
        case .wheelchair:
            return ("wheelchair-mono", "")
        case .travelInsurance:
            return ("profile-mono", "")
        }
    }
}
enum FlightContactInfoRowType: Int, CaseIterable {
    case phoneNumber
    case email
    case confirmation

    var title: String {
        switch self {
        case .phoneNumber:
            return "Phone Number"
        case .email:
            return "Email Address"
        default:
            return ""
        }
    }

    var imageName: String {
        switch self {
        case .phoneNumber:
            return "phone-mono"
        case .email:
            return "email-mono"
        default:
            return ""
        }
    }
}

class FlightVerifyInfoVC: ViewController {
    //MARK: Private properties
    private var flightBookingData: FlightBookigData
    private var firstInfo: PassengerInfo?
    private var editingMode: Bool = false
    private var checked: Bool = true
    private var updatedPhoneNumber: String?
    private var updatedEmail: String?
    private var cellType = [InfoCellType]()
    private var covid19TestTotalPrice = Double()
    private var travelInsuranceTotalCharge = Double()

    //MARK: Quick Fix
    var totalDiscount: Double!
    var useCouponView: UseCouponView!
    var priceInfoTableData: PriceInfoTableData!
    var viewModel: FlightPassengerListViewModel!
    var flightDetailsViewModel: FlightDetailsViewModel!
    var availableDiscountOptions: [DiscountOption]!
    var baggageViewModel: BaggageViewModel?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(), style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear
        tableView.backgroundColor = .white
        return tableView
    }()
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var continueButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .appPrimary
        button.setTitle("CONTINUE", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(continueButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    init(flightBookingData: FlightBookigData) {
        self.flightBookingData = flightBookingData
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        setCellTypeInfo()
        setCovid19TestPriceData()
        travelInsuranceAmountCalculation()
        setupTableView()
        setupView()
    }
    
    private func setCellTypeInfo(){
        if flightBookingData.isDomestic {
            cellType = [.name, .gender, .nationality, .passportNumber, .passportVisaCopy, .mealPreference, .wheelchair, .travelInsurance]
        } else {
            cellType = [.name, .gender, .nationality, .passportNumber, .passportVisaCopy, .mealPreference, .wheelchair, .covid19Test]
        }
    }
    
    private func setCovid19TestPriceData(){
        if flightBookingData.isDomestic {
            self.priceInfoTableData.covid19TestPrice = 0
        } else {
            for item in 0..<flightBookingData.passengersAdditionalRequirementInfos.count {
                covid19TestTotalPrice = covid19TestTotalPrice + (flightBookingData.passengersAdditionalRequirementInfos[item].selectedCovid19TestOption?.discountPrice ?? 0)
            }
            priceInfoTableData.covid19TestPrice = covid19TestTotalPrice
        }
    }
    
    // MARK: -  TravelInsurance Amount Calculations
    private func travelInsuranceAmountCalculation() {
        if !flightBookingData.isDomestic {
            self.priceInfoTableData.travelInsuraceCharge = .zero
        } else {
            for item in 0..<flightBookingData.passengersAdditionalRequirementInfos.count {
                travelInsuranceTotalCharge += ( Double(flightDetailsViewModel.flightSegmentsCount) * Double(flightBookingData.passengersAdditionalRequirementInfos[item].selectedTravelInsuranceCodeOption?.discountPrice ?? 0))
            }
            priceInfoTableData.travelInsuraceCharge = travelInsuranceTotalCharge
        }
    }
    
    private func setupTableView(){
        tableView.registerHeaderFooter(RightButtonHeaderView.self)
        tableView.registerNibCell(NameCell.self)
        tableView.registerNibCell(InfoDetailCell.self)
        tableView.registerNibCell(PassportVisaCell.self)
        tableView.registerNibCell(EditableContactCell.self)
        tableView.registerCell(CheckboxCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }

    private func setupView(){
        title = "Verify Information"
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        view.addSubview(bottomView)
        bottomView.addSubview(continueButton)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 44.0),
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            continueButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor),
            continueButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor),
            continueButton.topAnchor.constraint(equalTo: bottomView.topAnchor),
            continueButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor)
        ])
    }

    private func setupContinueButtonStatus() {
        if editingMode {
            continueButton.isEnabled = false
            continueButton.alpha = 0.50
        } else {
            if checked {
                continueButton.isEnabled = true
                continueButton.alpha = 1.0
            } else {
                continueButton.isEnabled = false
                continueButton.alpha = 0.50
            }
        }
    }

    //MARK: Button Action
    @objc func handleEditButtonTapped(_ sender: UIButton) {

        if editingMode {
            if let email = updatedEmail {
                let result = email.validateForEmail()
                if case .failure(.validationError(let message)) = result {
                    showMessage(message, type: .error)
                    return
                }
            }
        }

        editingMode = !editingMode
        setupContinueButtonStatus()
        let buttonText = editingMode ? "SAVE" : "EDIT"
        sender.setTitle(buttonText, for: .normal)

        let section = flightBookingData.passengersInfos.count
        let rows = [
            IndexPath(row: FlightContactInfoRowType.phoneNumber.rawValue, section: section),
            IndexPath(row: FlightContactInfoRowType.email.rawValue, section: section)
        ]
        tableView.reloadRows(at: rows, with: .automatic)
    }

    @objc func continueButtonTapped(_ sender: UIButton) {

        let passengersInfos = flightBookingData.passengersInfos
        let passengerAdditionalRequirementsInfos = flightBookingData.passengersAdditionalRequirementInfos
        if let email = updatedEmail, email != passengersInfos.first?.email  {
            passengersInfos.first?.email = email
        }
        
        if updatedPhoneNumber == nil {
            updatedPhoneNumber = passengersInfos.first?.mobile
        }
        
        let phoneNumbervalidator = updatedPhoneNumber?.isValidPhoneNumber() ?? false
        if phoneNumbervalidator {
            if let phoneNumber = updatedPhoneNumber {
                passengersInfos.first?.mobile = phoneNumber
            }

            let flightSummaryVC = FlightSummaryVC.instantiate()
            flightSummaryVC.travellers = passengersInfos
            flightSummaryVC.flightDetailsViewModel = flightDetailsViewModel
            flightSummaryVC.priceInfoTableData = priceInfoTableData
            flightSummaryVC.discountOptions = availableDiscountOptions
            flightSummaryVC.useCouponView = useCouponView
            flightSummaryVC.passengerAdditionalRequirementInfos = passengerAdditionalRequirementsInfos
            
            navigationController?.pushViewController(flightSummaryVC, animated: true)
            
        } else {
            let message = "Please provide a valid phone number"
            self.showMessage(message, type: .error, options: [.autoHide(true),.autoHideDelay(4.0), .hideOnTap(true)])
        }
    }

    func handleCheckboxSelection(indexPath: IndexPath, checked: Bool) {
        self.checked = checked
        setupContinueButtonStatus()
    }
}

extension FlightVerifyInfoVC: UITableViewDelegate, UITableViewDataSource {
    //MARK: Tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return flightBookingData.passengersInfos.count + 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section >= flightBookingData.passengersInfos.count {
            return FlightContactInfoRowType.allCases.count
        }
        return self.cellType.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section != flightBookingData.passengersInfos.count {
            let passengerInfo = flightBookingData.passengersInfos[indexPath.section]
            let passengerAdditionalRequirementsInfo = flightBookingData.passengersAdditionalRequirementInfos[indexPath.section]
            let cellType = self.cellType[indexPath.row]
            switch cellType {
            case .name:
                let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as NameCell
                cell.configure(imageName: cellType.iconName.0, titleText: cellType.title.0, subTitleText: passengerInfo.givenName + " " + passengerInfo.surName)
                cell.selectionStyle = .none
                return cell
            case .gender:
                let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as InfoDetailCell
                var infoDataOne: VerifyInfoData?
                var infoDataTwo: VerifyInfoData?
                if let gender = passengerInfo.gender {
                    infoDataOne = VerifyInfoData(title: cellType.title.0, subTitle: gender.rawValue, image: cellType.iconName.0)
                }
                if let dob = passengerInfo.dob {
                    let dateString = dob.toString(format: .shortDate)
                    infoDataTwo = VerifyInfoData(title: cellType.title.1, subTitle: dateString, image: cellType.iconName.1)
                }
                if infoDataOne == nil {
                    swap(&infoDataOne, &infoDataTwo)
                }
                cell.configure(infoDataOne: infoDataOne, infoDataTwo: infoDataTwo)
                cell.selectionStyle = .none
                return cell

            case .passportNumber:
                let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as InfoDetailCell
                if let passportExpDate = passengerInfo.passportExpiryDate {
                    let dateString = passportExpDate.toString(format: .shortDate)
                    let verifyInfoDataOne = VerifyInfoData(title: cellType.title.0, subTitle: passengerInfo.passportNumber, image: cellType.iconName.0)
                    let verifyInfoDataTwo = VerifyInfoData(title: cellType.title.1, subTitle: dateString, image: cellType.iconName.1)
                    cell.configure(infoDataOne: verifyInfoDataOne, infoDataTwo: verifyInfoDataTwo)
                } else {
                    cell.configure(infoDataOne: .none, infoDataTwo: .none)
                }
                cell.selectionStyle = .none
                return cell

            case .nationality:
                let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as InfoDetailCell
                if let country = passengerInfo.nationality {
                    let verifyInfoDataOne = VerifyInfoData(title: cellType.title.0, subTitle: "\(country.name)", image: cellType.iconName.0)
                    let verifyInfoDataTwo = VerifyInfoData(title: cellType.title.1, subTitle: passengerInfo.frequentFlyerNumber, image: cellType.iconName.1)
                    cell.configure(infoDataOne: verifyInfoDataOne, infoDataTwo: verifyInfoDataTwo)
                } else {
                    cell.configure(infoDataOne: .none, infoDataTwo: .none)
                }
                cell.selectionStyle = .none
                return cell

            case .passportVisaCopy:
                let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as PassportVisaCell
                cell.configure(passportUrl: passengerInfo.passportURLStr, visaUrl: passengerInfo.visaURLStr, cellIndexPath: indexPath, delegate: self)
                cell.selectionStyle = .none
                return cell
                
            case .covid19Test:
                let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as NameCell
                cell.configure(imageName: cellType.iconName.0, titleText: cellType.title.0, subTitleText: passengerAdditionalRequirementsInfo.covid19TestSubtitle)
                cell.selectionStyle = .none
                return cell
                
            case .mealPreference:
                let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as NameCell
                cell.configure(imageName: cellType.iconName.0, titleText: cellType.title.0, subTitleText: passengerAdditionalRequirementsInfo.selectedMealPreferenceOption)
                cell.selectionStyle = .none
                return cell
                
            case .wheelchair:
                let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as NameCell
                cell.configure(imageName: cellType.iconName.0, titleText: cellType.title.0, subTitleText: passengerAdditionalRequirementsInfo.selectedWheelChairOption)
                cell.selectionStyle = .none
                return cell
                
            case .travelInsurance:
                let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as NameCell
                cell.configure(imageName: cellType.iconName.0, titleText: cellType.title.0, subTitleText: passengerAdditionalRequirementsInfo.travelInsuranceSubtitle)
                cell.selectionStyle = .none
                return cell
            }
        } else {
            let rowType = FlightContactInfoRowType.allCases[indexPath.row]
            switch rowType {
            case .phoneNumber, .email:
                let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as EditableContactCell

                var value: String?
                if rowType == .email {
                    value = updatedEmail ?? flightBookingData.passengersInfos.first?.email
                } else {
                    value = updatedPhoneNumber ?? flightBookingData.passengersInfos.first?.mobile
                }

                cell.configure(imageName: rowType.imageName, titleText: rowType.title, subTitleText: value, editingMode: editingMode, cellIndexPath: indexPath, callbackClosure: { [weak self] (cellIndexPath, value) in
                    guard let self = self else { return }
                    let cellRowType = FlightContactInfoRowType.allCases[cellIndexPath.row]
                    if cellRowType == .email {
                        self.updatedEmail = value
                    } else {
                        self.updatedPhoneNumber = value
                    }
                })
                cell.selectionStyle = .none
                return cell
            case .confirmation:
                let termAndCondition = "I’ve confirm that the documents and the information provided are correct and can be used for the flight booking process."
                let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as CheckboxCell
                cell.configure(title: termAndCondition, checkboxChecked: true)
                cell.didTapCheckbox = {[weak self] checked in
                    self?.handleCheckboxSelection(indexPath: indexPath, checked: checked)
                }
                return cell
            }
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != flightBookingData.passengersInfos.count {
            let adultCount = flightBookingData.passengersInfos.filter { $0.travellerType == .adult }.count
            let childCount = flightBookingData.passengersInfos.filter { $0.travellerType == .child }.count
            var title = ""
            switch flightBookingData.passengersInfos[section].travellerType {
            case .adult:
                title = title + "Adult \(section + 1)"
            case .child:
                title = title + "Child \(section - adultCount + 1)"
            case .infant:
                title = title + "Infant \(section - adultCount - childCount + 1)"
            }

            let header = CustomHeaderView(frame: .zero)
            header.customLabel.font = .systemFont(ofSize: 16.0)
            header.customLabel.textColor = .black
            header.customLabel.text = title
            return header
        } else {
            let header = tableView.dequeueReusableHeaderFooterView() as RightButtonHeaderView
            header.rightButton.titleLabel?.font = .boldSystemFont(ofSize: 14.0)
            header.rightButton.titleColor(for: .focused)
            header.titleLabel.text = "Contact Information"
            header.titleLabel.font = .systemFont(ofSize: 16.0, weight: .medium)
            header.titleLabel.textColor = .black
            header.rightButton.addTarget(self, action: #selector(self.handleEditButtonTapped(_:)), for: .touchUpInside)
            return header
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section != flightBookingData.passengersInfos.count {
            let cellType = self.cellType[indexPath.row]
            switch cellType {
            case .name, .gender, .passportNumber, .nationality, .covid19Test, .mealPreference, .wheelchair, .travelInsurance:
                return 56.0
            case .passportVisaCopy:
                return 130.0
            }
        } else {
            let rowType = FlightContactInfoRowType.allCases[indexPath.row]
            if rowType == .confirmation {
                return 80
            } else {
                return 56.0
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 56
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == flightBookingData.passengersInfos.count ? 100 : 8
    }
}

extension FlightVerifyInfoVC: PassportVisaCellDelegate {
    func passportViewTapped(cellIndexPath: IndexPath) {
        let passengerInfo = flightBookingData.passengersInfos[cellIndexPath.section]
        openFullScreenImageViewer(attachmentURL: passengerInfo.passportURLStr)
    }

    func visaViewTapped(cellIndexPath: IndexPath) {
        let passengerInfo = flightBookingData.passengersInfos[cellIndexPath.section]
        openFullScreenImageViewer(attachmentURL: passengerInfo.visaURLStr)
    }

    private func openFullScreenImageViewer(attachmentURL: String) {
        if let kingfisherSource = KingfisherSource(urlString: attachmentURL) {
            let fullscreen = FullScreenSlideshowViewController()
            fullscreen.inputs = [kingfisherSource]
            fullscreen.slideshow.activityIndicator = DefaultActivityIndicator()
            fullscreen.modalPresentationStyle = .fullScreen
            self.present(fullscreen, animated: true, completion: nil)
        }
    }
}

