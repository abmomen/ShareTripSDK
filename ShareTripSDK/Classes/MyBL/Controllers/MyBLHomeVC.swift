//
//  MyBLHomeVC.swift
//  ShareTripSDK
//
//  Created by ST-iOS on 1/19/23.
//

import UIKit

public class MyBLHomeVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Tickets"
        tableView.backgroundColor = .offWhite
        tableView.registerNibCell(AllServicesButtonCell.self)
    }

}

extension MyBLHomeVC: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}


extension MyBLHomeVC: StoryboardBased {
    public static var storyboardName: String {
        return "MyBL"
    }
}
