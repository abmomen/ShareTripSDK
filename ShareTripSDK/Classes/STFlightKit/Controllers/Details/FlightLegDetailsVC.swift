//
//  FlightLegDetailsVC.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 02/12/2019.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit


protocol FlightLegDetailsVCDelegate: AnyObject {
    func showNextLeg(legId: Int)
    func showPrevLeg(legId: Int)
}

class FlightLegDetailsVC: UITableViewController {
    
    var legId: Int!
    var prevLegTitle: String = ""
    var nextLegTitle: String = ""
    var isFirstLeg: Bool!
    var isLastLeg: Bool!
    weak var delegate: FlightLegDetailsVCDelegate!
    
    var flightSegmentCellDatas = [FlightSegmentCellData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let crossButtonImage = UIImage(named: "close-mono")
        super.viewWillAppear(animated)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: crossButtonImage, style: .done, target: self, action: #selector(closedButtonTapped(_:)))
        
        if #available(iOS 13.0, *) {
            // leave as it is.....
        } else {
            // Fallback on earlier versions
            navigationItem.leftBarButtonItem?.tintColor = .white
            let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            navigationController?.navigationBar.titleTextAttributes = textAttributes
        }
    }
    
    @objc private func closedButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    private func setupUI() {
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 400
        tableView.backgroundColor = .offWhite
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.registerNibCell(FlightSegmentCardCell.self)
        tableView.registerNibCell(NextPrevLegDetailsCell.self)
    }
    
    // MARK: - Table view data source
    
    private var rows: [CellType] {
        var rows: [CellType] = [CellType](repeating: .segment, count: flightSegmentCellDatas.count)
        rows.append(.prevNext)
        return rows
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = rows[indexPath.row]
        switch cellType {
        case .segment:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as FlightSegmentCardCell
            cell.configure(with: flightSegmentCellDatas[indexPath.row])
            return cell
        case .prevNext:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as NextPrevLegDetailsCell
            cell.configure(
                legId: legId,
                prevButtonTitle: prevLegTitle,
                nextButtonTitle: nextLegTitle,
                isFirstLeg: isFirstLeg,
                isLastLeg: isLastLeg,
                delegate: self
            )
            return cell
        }
    }
}

extension FlightLegDetailsVC {
    private enum CellType {
        case segment, prevNext
    }
}


extension FlightLegDetailsVC: NextPrevLegDetailsCellDelegate {
    func nextButtonTapped(for legId: Int) {
        delegate.showNextLeg(legId: self.legId)
    }
    
    func prevButtonTapped(for legId: Int) {
        delegate.showPrevLeg(legId: self.legId)
    }
}
