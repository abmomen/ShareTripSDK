//
//  BookingHistoryPriceTableVC.swift
//  STCoreKit
//
//  Created by ST-iOS on 12/4/22.
//

import UIKit

public struct HistoryConvenienceFee {
    public let convenienceFee: Double
    
    public init(convenienceFee: Double) {
        self.convenienceFee = convenienceFee
    }
}

public class BookingHistoryPriceTableVC: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.backgroundColor = .white
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let viewModel: PriceTableViewModel
    
    public init(viewModel: PriceTableViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
    }
    
    //MARK: - Helpers
    func setupScene() {
        setupNavigationItems(withTitle: "Pricing Details")
        tableView.registerCell(TotalFareCell.self)
        tableView.registerCell(PriceInfoFareCell.self)
        tableView.registerCell(LeftRightInfoCell.self)
        tableView.registerCell(HorizontalLineCell.self)
        tableView.registerCell(LeftRightPriceInfoCell.self)
        tableView.registerHeaderFooter(LeftRightInfoHeaderView.self)
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

//MARK:- TableView Delegate & DataSource
extension BookingHistoryPriceTableVC: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getSections().count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getSections()[section].count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowType = viewModel.getSections()[indexPath.section][indexPath.row]
        
        switch rowType {
        case .rowData:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as PriceInfoFareCell
            if let cellData = viewModel.getPriceRowData(indexPath.row) {
                cell.configure(cellData: cellData)
            }
            return cell
            
        case .dashLine:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as HorizontalLineCell
            cell.configure(lineHeight: 1.0)
            return cell
            
        case .totalBeforeDiscount:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as TotalFareCell
            let total = viewModel.getTotalPrice()
            let discount = viewModel.getDiscount()
            cell.configure(subTotal: total, discount: discount)
            return cell
            
        case .baggage:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as LeftRightPriceInfoCell
            cell.configure(title: "Baggage", amount: viewModel.getBaggagePrice())
            return cell
            
        case .covid19Test:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as LeftRightPriceInfoCell
            cell.configure(title: "COVID-19 Test", amount: viewModel.getCovid19TestPrice())
            return cell
            
        case .travelInsurance:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as LeftRightPriceInfoCell
            cell.configure(title: "Insurance Charge", amount: viewModel.travelInsuranceCharge)
            return cell
        case .visaCourierFee:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as LeftRightPriceInfoCell
            cell.configure(title: "Visa Courier Charge", amount: viewModel.getVisaCourierCharge())
            return cell
            
        case .advanceIncomeTax:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as LeftRightPriceInfoCell
            cell.configure(title: "Advance Income Tax", amount: viewModel.getadvanceIncomeTax())
            return cell
            
        case .stCharge, .couponDiscount:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as LeftRightPriceInfoCell
            if rowType == .stCharge {
                cell.configure(title: "ST Convenience Fee", amount: viewModel.getConvenienceFee())
            } else if rowType == .couponDiscount {
                cell.configure(title: "Coupon", amount: -1 * viewModel.getCouponDiscount())
            }
            return cell
            
        case .total:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as LeftRightInfoCell
            let totalPayable = viewModel.getTotalPayble()
            cell.configure(leftValue: "Final Amount", rightValue: totalPayable.withCommas())
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let rowType = viewModel.getSections()[indexPath.section][indexPath.row]
        switch rowType {
        case .rowData:
            return UITableView.automaticDimension
        case .dashLine:
            return 13.0
        case .totalBeforeDiscount:
            return 50.0
        case .total:
            return 36.0
        case .baggage, .covid19Test, .travelInsurance, .visaCourierFee, .advanceIncomeTax, .stCharge, .couponDiscount:
            return 20.0
        }
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView() as LeftRightInfoHeaderView
        header.labelContainerView.backgroundColor = UIColor.veryLightPink
        header.setText(left: "Pricing Details", right: "BDT")
        return section == 0 ? header : UIView()
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 34.0 : 0
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
}

