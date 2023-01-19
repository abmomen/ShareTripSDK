//
//  RefundableTravellersDetailsVC.swift
//  ShareTrip
//
//  Created by ST-iOS on 5/19/22.
//  Copyright © 2022 ShareTrip. All rights reserved.
//

import UIKit


class RefundableTravellersDetailsVC: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.backgroundColor = .offWhite
            tableView.registerNibCell(SingleLabelInfoTVCell.self)
            tableView.allowsSelection = false
        }
    }
    
    var travellers = [RefundableTraveller]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItems(withTitle: "Traveller(s) Details")
    }
    
}

extension RefundableTravellersDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return travellers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SingleLabelInfoTVCell
        var title = travellers[indexPath.row].titleName + " "
        title += travellers[indexPath.row].givenName + " "
        title += travellers[indexPath.row].surName
        cell.title = title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension RefundableTravellersDetailsVC: StoryboardBased {
    static var storyboardName: String {
        return "FlightBooking"
    }
}
