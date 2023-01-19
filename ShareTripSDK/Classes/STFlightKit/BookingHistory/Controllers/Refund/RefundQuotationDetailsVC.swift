//
//  RefundQuotationDetailsVC.swift
//  ShareTrip
//
//  Created by ST-iOS on 5/18/22.
//  Copyright © 2022 ShareTrip. All rights reserved.
//

import UIKit
import PKHUD


class RefundQuotationDetailsVC: UIViewController {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.registerHeaderFooter(LeftRightInfoHeaderView.self)
            tableView.registerCell(HorizontalLineCell.self)
            tableView.registerCell(LeftRightInfoCell.self)
            tableView.registerCell(LeftRightPriceInfoCell.self)
            tableView.registerNibCell(SingleLineInfoCardCell.self)
            tableView.backgroundColor = .offWhite
        }
    }
    
    @IBOutlet weak var nextButton: UIButton! {
        didSet {
            nextButton.layer.cornerRadius = 8
            nextButton.clipsToBounds = true
        }
    }
    
    var viewModel: RefundQuotationViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItems(withTitle: "Refund Details")
        viewModel.fetchRefundQuotation()
        HUD.show(.progress)
        handleCallbacks()
        handleNextButtonStatus()
    }
    
    private func handleCallbacks() {
        viewModel.callback.didFetchRefundQuotations = {[weak self] in
            HUD.hide()
            self?.tableView.reloadData()
            self?.handleNextButtonStatus(isEnabled: true)
        }
        
        viewModel.callback.didFailed = {[weak self] error in
            HUD.hide()
            self?.showAlert(message: error)
            self?.viewModel.sections.removeAll()
            self?.tableView.reloadData()
            self?.tableView.setEmptyMessage("Unable to fetch refund quotations")
            self?.handleNextButtonStatus()
        }
    }
    
    private func handleNextButtonStatus(isEnabled: Bool = false) {
        nextButton.isEnabled = isEnabled
        let alpha = isEnabled ? 1: 0.2
        nextButton.backgroundColor = .appPrimary.withAlphaComponent(alpha)
    }
    
    @IBAction func didTapNextButton(_ sender: UIButton) {
        let confirmViewModel = FlightRefundConfirmViewModel(viewModel.refundSearchId)
        let confirmVC = ConfirmFlightRefundVC.instantiate()
        confirmVC.viewModel = confirmViewModel
        navigationController?.pushViewController(confirmVC, animated: true)
    }
}

extension RefundQuotationDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = viewModel.sections[indexPath.row]
        
        switch row {
        case .totalAmount, .airlineCharge, .stCharge, .totalCharge:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as LeftRightPriceInfoCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.configure(title: row.title, amount: viewModel.getAmount(for: row))
            return cell
        case .dividerLine:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as HorizontalLineCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        case .totalRefundable:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as LeftRightInfoCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            let totalRefundableAmount = Int(viewModel.getAmount(for: row)).withCommas()
            cell.configure(leftValue: "Amount to be Refunded", rightValue: "BDT: \(totalRefundableAmount)")
            return cell
        case .travellerDetails:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SingleLineInfoCardCell
            cell.configure(title: "Traveller(s) Details")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = viewModel.sections[indexPath.row]
        if row == .travellerDetails {
            let travellerDetailsVC = RefundableTravellersDetailsVC.instantiate()
            travellerDetailsVC.travellers = viewModel.selectedTravellers
            navigationController?.pushViewController(travellerDetailsVC, animated: true)
        }
        return
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView() as LeftRightInfoHeaderView
        headerView.setText(left: "Details", right: "BDT")
        headerView.backgroundColor = .offWhite
        return viewModel.sections.count > 0 ? headerView: UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = viewModel.sections[indexPath.row]
        
        switch row {
        case .totalAmount, .airlineCharge, .stCharge, .totalCharge:
            return 28
        case .dividerLine:
            return 5
        case .totalRefundable:
            return 44
        case .travellerDetails:
            return 56
        }
    }
}

extension RefundQuotationDetailsVC: StoryboardBased {
    static var storyboardName: String {
        return "FlightBooking"
    }
}
