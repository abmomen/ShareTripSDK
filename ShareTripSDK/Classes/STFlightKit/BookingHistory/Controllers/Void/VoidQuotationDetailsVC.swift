//
//  VoidQuotationDetailsVC.swift
//  ShareTrip
//
//  Created by ST-iOS on 5/18/22.
//  Copyright © 2022 ShareTrip. All rights reserved.
//

import UIKit
import PKHUD


class VoidQuotationDetailsVC: UIViewController {
    @IBOutlet private weak var nextButton: UIButton! {
        didSet {
            nextButton.layer.cornerRadius = 8
            nextButton.clipsToBounds = true
        }
    }
    
    @IBOutlet private weak var tableView: UITableView! {
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
    
    public var viewModel: FlightVoidQuotationViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItems(withTitle: "Void Details")
        
        viewModel.fetchVoidQuotations()
        HUD.show(.progress)
        
        viewModel.callback.didFetchVoidQuotations = {[weak self] in
            HUD.hide()
            self?.tableView.reloadData()
            self?.handleNextButtonStatus(isEnabled: true)
        }
        
        viewModel.callback.didFailed = {[weak self] error in
            HUD.hide()
            self?.showAlert(message: error)
            self?.viewModel.sections.removeAll()
            self?.tableView.reloadData()
            self?.tableView.setEmptyMessage("Unable to fetch void quotations")
            self?.handleNextButtonStatus()
        }
    }
    
    private func handleNextButtonStatus(isEnabled: Bool = false) {
        nextButton.isEnabled = isEnabled
        let alpha = isEnabled ? 1: 0.2
        nextButton.backgroundColor = .appPrimary.withAlphaComponent(alpha)
    }
    
    @IBAction private func didTapNextButton(_ sender: UIButton) {
        let voidConfirmViewModel = FlightVoidConfirmViewModel(viewModel.voidSearchId)
        let voidConfirmVC = FlightConfirmVoidVC.instantiate()
        voidConfirmVC.viewModel = voidConfirmViewModel
        navigationController?.pushViewController(voidConfirmVC, animated: true)
    }

}

extension VoidQuotationDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = viewModel.sections[indexPath.row]
        switch row {
        case .airfareAmount, .airlineCharge, .stCharge, .totalCharge:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as LeftRightPriceInfoCell
            cell.backgroundColor = .clear
            cell.configure(title: row.title, amount: viewModel.getAmount(for: row))
            return cell
        case .dividerLine:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as HorizontalLineCell
            cell.backgroundColor = .clear
            return cell
        case .totalVoidAmount:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as LeftRightInfoCell
            cell.backgroundColor = .clear
            let totalRefundableAmount = Int(viewModel.getAmount(for: row)).withCommas()
            cell.configure(leftValue: "Amount to be Void", rightValue: "BDT: \(totalRefundableAmount)")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView() as LeftRightInfoHeaderView
        headerView.setText(left: "Details", right: "BDT")
        return viewModel.sections.count > 0 ? headerView: UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = viewModel.sections[indexPath.row]
        
        switch row {
        case .airfareAmount, .airlineCharge, .stCharge, .totalCharge:
            return 28
        case .dividerLine:
            return 5
        case .totalVoidAmount:
            return 44
        }
    }
}


extension VoidQuotationDetailsVC: StoryboardBased {
    static var storyboardName: String {
        return "FlightBooking"
    }
}
