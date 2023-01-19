//
//  SearchDestinationCellInfo.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 10/11/2020.
//  Copyright © 2020 ShareTrip. All rights reserved.
//

import Foundation

public enum SearchDestinationCellInfo: Int {
    case destination
    case searchButton
    case advice

    public var title: String {
        get {
            switch self {
                case .destination: return "Destination"
                case .searchButton: return ""
                case .advice: return ""
            }
        }
    }

    public var placeholder: String {
        get {
            switch self {
                case .destination: return "Select Destination"
                case .searchButton: return ""
                case .advice: return ""
            }
        }
    }

    public var imageName: String {
        get {
            switch self {
                case .destination: return "map-pin-mono"
                case .searchButton: return ""
                case .advice: return ""
            }
        }
    }
}

public enum SearchDestinationResultCellInfo: Int {
    case travelAdvisory
    case destination
    case searchButton
    case permissionInfo
    case destinationDetails

    public var title: String {
        get {
            switch self {
                case .travelAdvisory: return ""
                case .destination: return "Destination"
                case .searchButton: return ""
                case .permissionInfo: return ""
                case .destinationDetails: return ""
            }
        }
    }

    public var placeholder: String {
        get {
            switch self {
                case .travelAdvisory: return ""
                case .destination: return "Select Destination"
                case .searchButton: return ""
                case .permissionInfo: return ""
                case .destinationDetails: return ""
            }
        }
    }

    public var imageName: String {
        get {
            switch self {
                case .travelAdvisory: return ""
                case .destination: return "map-pin-mono"
                case .searchButton: return ""
                case .permissionInfo: return ""
                case .destinationDetails: return ""
            }
        }
    }
}


