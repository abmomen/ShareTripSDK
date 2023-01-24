//
//  MyBLHomeVC.swift
//  ShareTripSDK
//
//  Created by ST-iOS on 1/19/23.
//

import UIKit

public class MyBLHomeVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = MyBLHomeViewModel()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Tickets"
        tableView.backgroundColor = .offWhite
        tableView.registerNibCell(AllServicesButtonCell.self)
        
        handleCallbacks()
    }
    
    private func handleCallbacks() {
        viewModel.fetchDeals()
        
        viewModel.callbacks.didSuccess = {[weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.callbacks.didFailed = {[weak self] error in
            self?.tableView.reloadData()
            self?.showMessage(error, type: .error)
        }
    }

}

extension MyBLHomeVC: UITableViewDelegate, UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.secions.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.secions[section] {
            
        case .features, .adds:
            return 1
            
        case .deals:
            return viewModel.deals.count
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        switch viewModel.secions[indexPath.section] {
        case .features:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as AllServicesButtonCell
            cell.didTapFlight = {[weak self] in
                self?.navigationController?.pushViewController(FlightSearchVC.instantiate(), animated: true)
            }
            
            cell.didTapHotel = {[weak self] in
                self?.showAlert(message: "Coming Soon...")
            }
            
            cell.didTapVisa = {[weak self] in
                self?.showAlert(message: "Coming Soon...")
            }
            
            return cell
    
        default:
            return UITableViewCell()
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {        
        switch viewModel.secions[indexPath.section] {
        case .features:
            return 150
    
        default:
            return 44
        }
    }
}


extension MyBLHomeVC: StoryboardBased {
    public static var storyboardName: String {
        return "MyBL"
    }
}
