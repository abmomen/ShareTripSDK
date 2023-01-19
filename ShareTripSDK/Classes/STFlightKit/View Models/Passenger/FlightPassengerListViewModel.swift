//
//  FlightPassengerListViewModel.swift
//  STFlightKit
//
//  Created by ST-iOS on 11/28/22.
//

import STCoreKit

public protocol FlightPassengerListViewModel: TableViewViewModel {
    var flightBookingData: FlightBookigData { get }
    var isSubmittable: Bool { get }
}

public class FlightPassengerListViewModelDefault: FlightPassengerListViewModel {

    // MARK: - Dependencies

    public private(set) var flightBookingData: FlightBookigData
    public private(set) var isAttachmentAvailable: Bool

    // MARK: - Private Properties

    private var adults: [PassengerInfo] {
        return flightBookingData.passengersInfos.filter { $0.travellerType == .adult }
    }
    
    private var childs: [PassengerInfo] {
        return flightBookingData.passengersInfos.filter { $0.travellerType == .child }
    }
    
    private var infants: [PassengerInfo] {
        return flightBookingData.passengersInfos.filter { $0.travellerType == .infant }
    }

    // MARK: Initializers

    public init(flightBookingData: FlightBookigData, isAttachmentAvailable: Bool) {
        self.flightBookingData = flightBookingData
        self.isAttachmentAvailable = isAttachmentAvailable
    }

    // MARK: - Protocol Confomration

    public var isSubmittable: Bool {
        return flightBookingData.isSubmittable
    }

    public var numberOfSection: Int {
        return 1
    }

    public func numberOfRows(in section: Int) -> Int {
        return flightBookingData.passengersInfos.count
    }

    public func dataForRow(at indexPath: IndexPath) -> ConfigurableTableViewCellData? {
        let passenger = flightBookingData.passengersInfos[indexPath.row]
        var title = ""
        if passenger.givenName.count > 0 {
            title = passenger.givenName
        } else {
            switch passenger.travellerType {
                case .adult:
                    title = "Adult \(indexPath.row + 1)"
                case .child:
                    title = "Child \(indexPath.row - adults.count + 1)"
                case .infant:
                    title = "Infant \(indexPath.row - adults.count - childs.count + 1)"
            }
        }

        let valid = flightBookingData.isValidPassengerInfo(at: indexPath.row)
        let viewModel = SingleInfoCellData(titlte: title, isValid: valid)
        
        return viewModel
    }

    deinit {
        STLog.info("\(String(describing: self)) deinit")
    }
}
