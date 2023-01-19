//
//  FlightPriceInfoVC.swift
//  ShareTrip
//
//  Created by Mac on 7/10/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit
import STCoreKit

class FlightPriceBreakdownVC: UIViewController {
    
    @IBOutlet weak var pricaTableView: UITableView!
    @IBOutlet weak var totalPayableLabel: UILabel!
    @IBOutlet weak var bookingButton: UIButton!
    @IBOutlet weak var currencyImageView: UIImageView!
    
    var buttonTitle = "Pay Now"
    
    var buttonFunction: (() -> Void)?
    
    var viewModel: FlightPriceBreakdownViewModel!
    
    var selectedDiscountOption: DiscountOptionType = .earnTC {
        didSet {
            viewModel.selectedDiscountOption = selectedDiscountOption
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
    }
    
    @IBAction func bookingButtonTapped(){
        buttonFunction?()
    }
    
    //MARK: - Helpers
    func setupScene() {
        
        pricaTableView.registerHeaderFooter(LeftRightInfoHeaderView.self)
        pricaTableView.registerCell(PriceInfoFareCell.self)
        pricaTableView.registerCell(HorizontalLineCell.self)
        pricaTableView.registerCell(TotalFareCell.self)
        pricaTableView.registerCell(LeftRightInfoCell.self)
        pricaTableView.registerCell(LeftRightPriceInfoCell.self)
        pricaTableView.tableFooterView = UIView()
        pricaTableView.tableHeaderView = UIView()
        pricaTableView.separatorStyle = .none
        pricaTableView.allowsSelection = false
        
        pricaTableView.dataSource = self
        pricaTableView.delegate = self
        bookingButton.setBorder(cornerRadius: 4.0)
        bookingButton.setTitle(buttonTitle, for: .normal)
        
        setupTotalPaybleLabel()
    }
    

    func relaodPriceTable(with priceBreakdown: PriceInfoTableData?) {
        guard let priceBreakdown = priceBreakdown else { return }
        viewModel.updatePriceTable(with: priceBreakdown)
        pricaTableView.reloadData()
        setupTotalPaybleLabel()
    }
    
    func relaodTableViewWith(
        with priceInfoTableData: PriceInfoTableData,
        _ conversionRate: Double,
        and isUSDPaymentAvailable: Bool) {
        viewModel.setConversionRate(conversionRate)
        viewModel.setIsUsdPaymentAvilable(isUSDPaymentAvailable)
        viewModel.updatePriceTable(with: priceInfoTableData)
        setupTotalPaybleLabel()
        pricaTableView.reloadData()
    }
    
    
    func setButtonStatus(enabled: Bool = true){
        bookingButton.isEnabled = enabled
        bookingButton.alpha = enabled ? 1.0 : 0.6
    }
    
    func getTotalPayble() -> Double {
        return viewModel.totalPayable
    }
    
    private func setupTotalPaybleLabel() {
        totalPayableLabel.text = viewModel.totalPayable.withCommas()
        currencyImageView.image = viewModel.currencyImage
    }
}

extension FlightPriceBreakdownVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.flightFareSctions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.flightFareSctions[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowType = viewModel.flightFareSctions[indexPath.section][indexPath.row]
        switch rowType {
        case .rowData:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as PriceInfoFareCell
            if let cellData = viewModel.getRowData(index: indexPath.row) {
                cell.configure(cellData: cellData, conversionRate: viewModel.moneyConversionRate)
            }
            return cell
            
        case .dashLine:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as HorizontalLineCell
            cell.configure(lineHeight: 1.0)
            return cell
            
        case .totalBeforeDiscount:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as TotalFareCell
            cell.configure(
                subTotal: viewModel.totalPrice,
                discount: viewModel.discount
            )
            return cell
            
        case .baggage:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as LeftRightPriceInfoCell
            cell.configure(title: "Baggage", amount: viewModel.baggagePrice)
            return cell
            
        case .covid19Test:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as LeftRightPriceInfoCell
            cell.configure(title: "COVID-19 Test", amount: viewModel.covidTestPrice)
            return cell
            
        case .travelInsurance:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as LeftRightPriceInfoCell
            cell.configure(title: "Travel Insurance Charge", amount: viewModel.travelInsuranceCharge)
            return cell
            
        case .advanceIncomeTax:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as LeftRightPriceInfoCell
            cell.configure(title: "Advance Income Tax", amount: viewModel.advanceIncomeTax)
            return cell
            
        case .stCharge, .couponDiscount:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as LeftRightPriceInfoCell
            if rowType == .stCharge {
                cell.configure(title: "ST Convenience Fee", amount: viewModel.convenienceFee)
            } else if rowType == .couponDiscount {
                cell.configure(title: "Coupon", amount: -1 * viewModel.couponDiscount)
            }
            return cell
            
        case .total:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as LeftRightInfoCell
            cell.configure(
                leftValue: "Final Amount",
                rightValue: viewModel.totalPayable.withCommas()
            )
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let rowType = viewModel.flightFareSctions[indexPath.section][indexPath.row]
        switch rowType {
        case .rowData:
            return 76.0
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 34.0: 0.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView() as LeftRightInfoHeaderView
        let currency = viewModel.currency
        header.setText(left: "Pricing Details", right: currency.rawValue)
        return section == 0 ? header : UIView()
    }
}

extension FlightPriceBreakdownVC: StoryboardBased {
    static var storyboardName: String {
        return "Flight"
    }
}
