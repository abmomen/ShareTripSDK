//
//  BaggageHistoryDetailsVC.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 07/03/2021.
//  Copyright © 2021 ShareTrip. All rights reserved.
//

import UIKit


class BaggageHistoryDetailsVC: ViewController {

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(), style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear
        tableView.backgroundColor = .white
        return tableView
    }()
    
    var baggageInfo: Baggage?
    var luggageAmount: Double?
    private var viewModel: BaggageHistoryDetailsViewModel?
    private var baggageHistoryInfoTVData = [[BaggageHistoryInfoType]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        setupTV()
    }
    
    private func initialSetup() {
        title = "Baggage Details"
        let baggageInfoVM = BaggageHistoryDetailsViewModel(baggageInfo: baggageInfo, luggageAmount: luggageAmount)
        self.viewModel = baggageInfoVM
        baggageHistoryInfoTVData = self.viewModel?.getBaggageInfoTableData() ?? [[BaggageHistoryInfoType]]()
        
        if let totalPoints = STAppManager.shared.userAccount?.totalPoints {
            navigationItem.rightBarButtonItem = TripCoinBarButtonItem.createWithText(totalPoints.withCommas())
        }

        view.addSubview(tableView)
        var tableViewConstrants = [
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ]

        if #available(iOS 11.0, *) {
            tableViewConstrants.append(tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor))
        } else {
            tableViewConstrants.append(tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        }
        NSLayoutConstraint.activate(tableViewConstrants)
    }
    
    private func getAttributedString(with text: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: 1.88, range: NSRange(location: 0, length: attributedString.length - 1))
        attributedString.addAttributes(
            [
                NSAttributedString.Key.kern: 1.88,
                NSAttributedString.Key.foregroundColor: UIColor.darkGray,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .medium)
            ],
            range: NSRange(location: 0, length: attributedString.length))
        return attributedString
    }
    
}

extension BaggageHistoryDetailsVC: UITableViewDelegate, UITableViewDataSource {
    private func setupTV(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNibCell(BaggageInfoTVCell.self)
        tableView.registerHeaderFooter(SingleInfoHeaderView.self)
        tableView.registerCell(HorizontalLineCell.self)
        tableView.registerCell(LeftRightInfoCell.self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.getBaggageTVSectionCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.baggageHistoryInfoTVData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowType = self.baggageHistoryInfoTVData[indexPath.section][indexPath.row]
        switch rowType {
        case .baggageInfo:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as BaggageInfoTVCell
            cell.selectionStyle = .none
            
            if indexPath.section == 0 {
                let basicBaggageData = viewModel?.getBasicBaggageData(with: indexPath.row)
                cell.config(route: basicBaggageData?.route ?? "", basicBaggageInfo: basicBaggageData?.baggages ?? [BaggageDetail](), baggageType: .basic)
            } else if indexPath.section == 1{
                let extraBaggageData = viewModel?.getExtraBaggageData(with: indexPath.row)
                cell.config(route: extraBaggageData?.route ?? "", extraBaggageInfo: extraBaggageData?.details ?? [ExtraBaggageDetailInfo](), baggageType: .extra)
            }
            return cell
        case .singleDashLine:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as HorizontalLineCell
            cell.configure(lineHeight: 2.0)
            return cell
        case .totalPrice:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as LeftRightInfoCell
            cell.leftLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
            cell.configure(leftValue: "Total Baggage: ", rightValue: "BDT \(luggageAmount?.withCommas() ?? "")")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let rowType = self.baggageHistoryInfoTVData[indexPath.section][indexPath.row]
        switch rowType {
        case .baggageInfo:
            return UITableView.automaticDimension
        case .singleDashLine:
            return 10.0
        case .totalPrice:
            return 40.0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView() as SingleInfoHeaderView
        header.titleLabel.numberOfLines = 0
        
        if section == 1 {
            header.titleLabel.attributedText = getAttributedString(with: "Extra Baggage")
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 30.0
        }
        return 80.0
    }
}

