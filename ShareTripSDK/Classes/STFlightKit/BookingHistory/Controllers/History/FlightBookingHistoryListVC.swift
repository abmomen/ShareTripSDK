//
//  FlightBookingHistoryListVC.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 20/02/2020.
//  Copyright © 2020 TBBD IOS. All rights reserved.
//

import UIKit
import STCoreKit

public class FlightBookingHistoryListVC: UITableViewController {
    
    private let viewModel = FlightBookingHistoryViewModel()
    
    //MARK:- ViewController's Life Cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        handleCallbacks()
        viewModel.fetchFlightBookingHistory()
        tableView.startActivityIndicator()
    }
    
    private func handleCallbacks() {
        viewModel.callback.didFetchHistories = { [weak self] in
            self?.tableView.stopActivityIndicator()
            self?.tableView.reloadData()
        }
        
        viewModel.callback.didFailed = {[weak self] error in
            self?.tableView.stopActivityIndicator()
            self?.tableView.reloadData()
            self?.tableView.setEmptyMessage(EmptyBookingMessage.getMessage(for: .flight))
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
    }
    
    // MARK: - Helpers
    private func setupViews() {
        title = BookingHistoryOption.flight.title
        
        if let totalPoints = STAppManager.shared.userAccount?.totalPoints {
            navigationItem.rightBarButtonItem = TripCoinBarButtonItem.createWithText(totalPoints.withCommas())
        }
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.offWhite
        
        tableView.registerNibCell(FlightBookingCell.self)
    }
    
    // MARK: - UITableViewDataSource
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.histories.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let history = viewModel.histories[indexPath.row]
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as FlightBookingCell
        cell.configure(historyOption: .flight, history: history)
        cell.selectionStyle = .none
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailViewModel = FlightBookingHistoryDetailViewModel(of: viewModel.histories[indexPath.row])
        let flightBookingHistoryDetailVC = FlightBookingHistoryDetailVC(viewModel: detailViewModel)
        navigationController?.pushViewController(flightBookingHistoryDetailVC, animated: true)
    }
    
    public override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height && viewModel.hasMore {
            viewModel.fetchFlightBookingHistory()
            tableView.startActivityIndicator()
        }
    }
}
