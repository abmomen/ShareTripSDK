//
//  TableViewViewModel.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/28/22.
//

import UIKit

public protocol TableViewViewModel {
    var numberOfSection: Int { get }
    func numberOfRows(in section: Int) -> Int
    func didSelectRow(at indexPath: IndexPath)
    func dataForRow(at indexPath: IndexPath) -> ConfigurableTableViewCellData?
}

public extension TableViewViewModel {
    func didSelectRow(at indexPath: IndexPath) {}
}
