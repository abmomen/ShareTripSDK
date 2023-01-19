//
//  ConfigurableTableViewCellData.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/23/22.
//

import UIKit

public protocol ConfigurableTableViewCellData {
    static var reuseableIDForContainer: String { get }
}

public extension ConfigurableTableViewCellData {
    static var reuseableIDForContainer: String {
        return "\(String(describing: self))Container"
    }
}

public protocol ConfigurableTableViewCellDataContainer {
    associatedtype AccecptableViewModelType: ConfigurableTableViewCellData
    static var reuseableContainerID: String { get }
}

public extension ConfigurableTableViewCellDataContainer {
    static var reuseableContainerID: String {
        return String(describing: AccecptableViewModelType.reuseableIDForContainer)
    }
}

public protocol ConfigurableTableViewCell: UITableViewCell {
    func configure(viewModel: ConfigurableTableViewCellData)
}
