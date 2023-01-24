//
//  FlightTravellerInfoVC.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 3/2/20.
//  Copyright © 2020 TBBD IOS. All rights reserved.
//

import UIKit



class FlightTravellerInfoVC: UITableViewController {
    private let travellerInfo: [TravellerInfo]
    private var sections = [[RowType]]()
    private var primaryContact: TravellerInfo?

    init( travellerInfo: [TravellerInfo]) {
        self.travellerInfo = travellerInfo.sorted { ($0.travellerType ?? .adult).rawValue < ($1.travellerType ?? .adult).rawValue }

        for traveller in travellerInfo {
            var cells = [RowType]()
            if traveller.covid != nil {
                cells = [.name, .gender, .passportNumber, .nationality, .passportVisaCopy, .covid19TestInfo]
            } else {
                cells = [.name, .gender, .passportNumber, .nationality, .passportVisaCopy]
            }
            sections.append(cells)

            // find primary contact
            if traveller.primaryContact.uppercased() == "YES" {
                primaryContact = traveller
            }
        }
        sections.append([.phone, .email])
        super.init(style: .grouped)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear
        tableView.allowsSelection = false
        tableView.backgroundColor = .white
        tableView.registerNibCell(NameCell.self)
        tableView.registerNibCell(InfoDetailCell.self)
        tableView.registerNibCell(PassportVisaCell.self)
        tableView.registerNibCell(EditableContactCell.self)

        title = "Traveller(s) Details"
        if let totalPoints = STAppManager.shared.userAccount?.totalPoints {
            navigationItem.rightBarButtonItem = TripCoinBarButtonItem.createWithText(totalPoints.withCommas())
        }
    }
    
    private func getCovid19TestSubtitleString(using section: Int) -> String {
        if let covid19TestInfo = travellerInfo[section].covid {
            return (covid19TestInfo.isHomeCollection ?? false ? ("\(covid19TestInfo.center ?? ""), Home Collection From \(covid19TestInfo.customerAddress ?? "")") : ("\(covid19TestInfo.center ?? ""), \(covid19TestInfo.option ?? "")"))
        }
        return "I'll test myself"
    }
}

//MARK: TableView delegate data source method
extension FlightTravellerInfoVC {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = sections[indexPath.section][indexPath.row]
        switch cellType {
        case .name:
            let travellerInfo = self.travellerInfo[indexPath.section]
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as NameCell
            cell.configure(
                imageName: "profile-mono",
                titleText: "Full Name (Given Name + Surname)",
                subTitleText: travellerInfo.givenName + " " + travellerInfo.surName
            )
            return cell

        case .gender, .passportNumber, .nationality:
            let travellerInfo = self.travellerInfo[indexPath.section]
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as InfoDetailCell
            var subTitleLeft = ""
            var subTitleRight = ""

            if cellType == .gender {
                subTitleLeft = travellerInfo.gender
                subTitleRight = travellerInfo.dateOfBirth
            } else if cellType == .passportNumber {
                subTitleLeft = travellerInfo.passportNumber
                let passportExpDate = Date(fromString: travellerInfo.passportExpireDate, format: .isoDateTimeMilliSec)
                subTitleRight = passportExpDate?.toString(format: .isoDate) ?? ""
            } else {
                subTitleLeft = travellerInfo.nationality
                if let ffn = travellerInfo.frequentFlyerNumber {
                    subTitleRight = ffn
                }
            }

            let dataLeft = VerifyInfoData(
                title: cellType.title.0,
                subTitle: subTitleLeft,
                image: cellType.iconName.0
            )
            let dataRight = VerifyInfoData(
                title: cellType.title.1,
                subTitle: subTitleRight,
                image: cellType.iconName.1
            )
            cell.configure(infoDataOne: dataLeft, infoDataTwo: dataRight)
            return cell

        case .passportVisaCopy:
            let traveller = travellerInfo[indexPath.section]
            let passportUrl = traveller.passportCopy ?? ""
            let visaUrl = traveller.visaCopy ?? ""
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as PassportVisaCell
            cell.configure(passportUrl: passportUrl, visaUrl: visaUrl, cellIndexPath: indexPath, delegate: self)
            return cell

        case .phone, .email:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as EditableContactCell
            var subTitleText = ""
            if cellType == .phone {
                subTitleText += primaryContact?.mobileNumber ?? "Not Available"
            } else if cellType == .email {
                subTitleText += primaryContact?.email ?? "Not Available"
            }
            cell.configure(
                imageName: cellType.iconName.0,
                titleText: cellType.title.0,
                subTitleText: subTitleText,
                editingMode: false,
                cellIndexPath: indexPath,
                callbackClosure: nil
            )
            return cell
        case .covid19TestInfo:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as NameCell
            cell.configure(imageName: cellType.iconName.0, titleText: cellType.title.0, subTitleText: getCovid19TestSubtitleString(using: indexPath.section))
            cell.selectionStyle = .none
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = CustomHeaderView(frame: .zero)
        header.customLabel.font = .systemFont(ofSize: 16.0)
        header.customLabel.textColor = .black
        if section != travellerInfo.count {
            var title = ""
            let traveller = travellerInfo[section]
            let adultCount = travellerInfo.filter({ $0.travellerType == .adult || $0.travellerType == nil }).count
            let childCount = travellerInfo.filter({ $0.travellerType == .child }).count

            if let travellerType = traveller.travellerType {
                switch travellerType {
                case .adult:
                    title = "Adult \(section + 1)"
                case .child:
                    title = "Child \(section - adultCount + 1)"
                case .infant:
                    title = "Infant \(section - adultCount - childCount + 1)"
                }
            }
            header.config(title: title, textFont: .systemFont(ofSize: 16.0, weight: .medium), textColor: .black)
            return header
        } else {
            header.config(title: "Contact Information", textFont: .systemFont(ofSize: 16.0, weight: .medium), textColor: .black)
            return header
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellType = sections[indexPath.section][indexPath.row]
        switch cellType {
        case .passportVisaCopy:
            return 130.0
        default:
            return UITableView.automaticDimension
        }
    }
}

extension FlightTravellerInfoVC: PassportVisaCellDelegate {
    func passportViewTapped(cellIndexPath: IndexPath) {
        let passengerInfo = travellerInfo[cellIndexPath.section]
        openFullScreenImageViewer(attachmentURL: passengerInfo.passportCopy ?? "")
    }

    func visaViewTapped(cellIndexPath: IndexPath) {
        let passengerInfo = travellerInfo[cellIndexPath.section]
        openFullScreenImageViewer(attachmentURL: passengerInfo.visaCopy ?? "")
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

extension FlightTravellerInfoVC {
    enum RowType: CaseIterable {
        case name
        case gender
        case passportNumber
        case nationality
        case passportVisaCopy
        case phone
        case email
        case covid19TestInfo

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
            case .phone:
                return ("Phone Number", "")
            case .email:
                return ("Email Address", "")
            case .covid19TestInfo:
                return ("COVID-19 test", "")
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
                return ("", "")
            case .phone:
                return ("phone-mono", "")
            case .email:
                return ("email-mono", "")
            case .covid19TestInfo:
                return ("covid-mono","")
            }
        }

    }
}
