//
//  RefundablePassengersSelectionVC.swift
//  ShareTrip
//
//  Created by ST-iOS on 5/18/22.
//  Copyright © 2022 ShareTrip. All rights reserved.
//

import UIKit
import PKHUD


class RefundablePassengersSelectionVC: ViewController {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.registerNibCell(SwitchCell.self)
            tableView.registerHeaderFooter(SelectDeselectButtonView.self)
        }
    }
    
    @IBOutlet weak var nextButton: UIButton! {
        didSet {
            nextButton.layer.cornerRadius = 8
            nextButton.clipsToBounds = true
        }
    }
    
    var viewModel: RefundVoidViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItems(withTitle: "Select Passenger")

        viewModel.fetchRefundEligibleTravellers()
        HUD.show(.progress)
        handleCallbacks()
        handleNextButtonState()
    }
    
    private func handleCallbacks() {
        viewModel.callback.didFetchEligibleTravellers = {[weak self] in
            self?.handleTableView()
        }
        
        viewModel.callback.didFailed = {[weak self] error in
            self?.handleTableView()
        }
        
        viewModel.callback.didChangeSelection = {[weak self] in
            self?.tableView.reloadData()
            self?.handleNextButtonState()
        }
    }
    
    private func handleTableView() {
        HUD.hide()
        if viewModel.refundableTravellers.count <= 0 {
            tableView.setEmptyMessage("No refundable travellers found")
        } else {
            tableView.reloadData()
        }
    }
    
    @IBAction func didTapNextButton(_ sender: UIButton) {
        let refundQuotationVC = RefundQuotationDetailsVC.instantiate()
        refundQuotationVC.viewModel = viewModel.getQuotationViewModel()
        navigationController?.pushViewController(refundQuotationVC, animated: true)
    }
    
    private func handleNextButtonState() {
        nextButton.isEnabled = viewModel.getSelectedTravellers().count > 0
        let buttonColorAlpha = (viewModel.getSelectedTravellers().count > 0) ? 1 : 0.2
        nextButton.backgroundColor = UIColor.appPrimary.withAlphaComponent(buttonColorAlpha)
    }
}

extension RefundablePassengersSelectionVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.refundableTravellers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let traveller = viewModel.refundableTravellers[indexPath.row]
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SwitchCell
        cell.configure(
            title: traveller.titleName + " " + traveller.givenName + " " + traveller.surName,
            checked: viewModel.isSelectedTraveller(traveller: traveller),
            indexPath: indexPath,
            delegate: self
        )
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView() as SelectDeselectButtonView
        headerView.titleLabel.text = "Select Passengers"
        headerView.callback.isSelected = {[weak self] isSelected in
            if isSelected {
                self?.viewModel.selectAllTravellers()
            } else {
                self?.viewModel.deSelectAllTravellers()
            }
        }
        return viewModel.refundableTravellers.count > 0 ? headerView: UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.refundableTravellers.count > 0 ? 44: .leastNonzeroMagnitude
    }
}

extension RefundablePassengersSelectionVC: SwitchCellDelegate {
    func switchButtonStatusChanged(status: Bool, cellIndexPath: IndexPath) {
        let traveller = viewModel.refundableTravellers[cellIndexPath.row]
        if status {
            viewModel.selectTraveller(traveller: traveller)
        } else {
            viewModel.deSelectTraveller(traveller: traveller)
        }
        
    }
}

extension RefundablePassengersSelectionVC: StoryboardBased {
    static var storyboardName: String {
        return "FlightBooking"
    }
}
