//
//  FlightInfoVC.swift
//  TBBD
//
//  Created by Mac on 4/24/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit
import Kingfisher
import STFlightKit
import STCoreKit

class FlightInfoVC: UITableViewController {

    //MARK:- private Properties
    private let history: FlightBookingHistory

    //MARK: init
    init(history: FlightBookingHistory) {
        self.history = history
        super.init(style: .grouped)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK:- ViewController's Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
    }
    
    //MARK:- Helpers
    private func setupScene() {
        title = "Flight Details"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 400
        tableView.backgroundColor = UIColor.offWhite
        tableView.rowHeight = UITableView.automaticDimension
        tableView.registerNibCell(FlightSegmentCardCell.self)
        tableView.registerNibHeaderFooter(FlightInfoHeaderView.self)

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        if let totalPoints = STAppManager.shared.userAccount?.totalPoints {
            navigationItem.rightBarButtonItem = TripCoinBarButtonItem.createWithText(totalPoints.withCommas())
        }

    }
}

// Table View delegate methods
extension FlightInfoVC {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return history.segments.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.segments[section].segmentDetails.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as FlightSegmentCardCell
        cell.configure(with: getFlightSegmentCellData(for: indexPath))
        return cell
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let flightRouteInfo = history.segments[section]
        let header = tableView.dequeueReusableHeaderFooterView() as FlightInfoHeaderView
        let fromPort = flightRouteInfo.segmentDetails.first?.originCode ?? ""
        let toPort = flightRouteInfo.segmentDetails.last?.destinationCode ?? ""
        header.configure(title: fromPort + " - " + toPort)
        return header
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 56.0
    }
    
    //Added an empty view to remove default footer height of tableview section
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
}

//Data formatter.
extension FlightInfoVC {
    private func getFlightSegmentCellData(for indexPath: IndexPath) -> FlightSegmentCellData {
        let flightSegment = history.segments[indexPath.section]
        let flightSegmentDetail = flightSegment.segmentDetails[indexPath.row]
        let airline = flightSegmentDetail.airlines.short + " " + flightSegmentDetail.airlines.code + (flightSegmentDetail.flightNumber ?? "")
        let duration = flightSegmentDetail.duration
        let departTime = flightSegmentDetail.departureDateTime.time
        let departDate = flightSegmentDetail.departureDateTime.date
        let departCode = flightSegmentDetail.originName.code
        let arrivalTime = flightSegmentDetail.arrivalDateTime.time
        let arrivalDate = flightSegmentDetail.arrivalDateTime.date
        let arrivalCode = flightSegmentDetail.destinationName.code
        let classText = history.searchParams.classType ?? ""
        let aircraft = flightSegmentDetail.aircraft
        let transitTime = flightSegmentDetail.transitTime
        let lastSegment = indexPath.row == flightSegment.segmentDetails.count - 1
        let airlineCode = flightSegmentDetail.airlines.code + (flightSegmentDetail.flightNumber ?? "")
        let departAirport = "\(flightSegmentDetail.originName.city), \(flightSegmentDetail.originName.airport)"
        let arrivalAirport = "\(flightSegmentDetail.destinationName.city), \(flightSegmentDetail.destinationName.airport)"

        return FlightSegmentCellData(
            airlinesImage: flightSegmentDetail.logo,
            airline: airline,
            airlineCode: airlineCode,
            duration: duration,
            departTime: departTime,
            departDate: departDate,
            departCode: departCode,
            departAirport: departAirport,
            arrivalTime: arrivalTime,
            arrivalDate: arrivalDate,
            arrivalCode: arrivalCode,
            arrivalAirport: arrivalAirport,
            classText: classText,
            aircraft: aircraft,
            transitTime: transitTime,
            isLastSegment: lastSegment,
            transitVisaRequired: false,
            transitVisaText: "",
            hasTechnicalStoppage: false,
            technicalStoppageText: ""
        )
    }
}
