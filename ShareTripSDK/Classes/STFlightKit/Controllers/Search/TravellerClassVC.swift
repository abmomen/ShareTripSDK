//
//  TravellerClassVC.swift
//  ShareTrip
//
//  Created by Mac on 9/11/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit


protocol TravellerClassVCDelegate: AnyObject {
    func travellerInfoChanged()
}

class TravellerClassVC: ViewController {
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet private weak var theTableView: UITableView!
    
    var travellerClassViewModel: TravellerClassViewModel!
    weak var delegate: TravellerClassVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        handleCallbacks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let user = STAppManager.shared.userAccount {
            navigationItem.rightBarButtonItem = TripCoinBarButtonItem.createWithText(user.totalPoints.withCommas())
        }
    }
    
    // MARK: - Setup views
    private func setupViews() {
        self.title = "Passengers & Class"
        view.backgroundColor = .appPrimary
        doneButton.backgroundColor = .appPrimary
        
        theTableView.registerHeaderFooter(LeftRightInfoHeaderView.self)
        theTableView.registerNibCell(TravelerCell.self)
        theTableView.registerCell(UITableViewCell.self)
        theTableView.registerCell(SDDateSelectionCell.self)
        
        theTableView.separatorStyle = .singleLine
        theTableView.separatorInset = .zero
        theTableView.backgroundColor = UIColor(hex: 0xfafafa)
        
        var frame = theTableView.bounds
        frame.origin.y = -frame.size.height
        let blueView = UIView(frame: frame)
        blueView.backgroundColor = .appPrimary
        theTableView.addSubview(blueView)
        
        navigationItem.leftBarButtonItems = BackButton.createWithText(
            "Back", color: .white, target: self, action: #selector(backButtonTapped(_:)))
    }
    
    private func handleCallbacks() {
        travellerClassViewModel.callback.didChangeAdultCount = {[weak self] in
            self?.theTableView.reloadData()
        }
        
        travellerClassViewModel.callback.didChangeChildCount = {[weak self] in
            self?.theTableView.reloadData()
        }
        
        travellerClassViewModel.callback.didFailValidation = {[weak self] error in
            self?.showAlert(message: error)
        }
        
        travellerClassViewModel.callback.didPassValidation = {[weak self] in
            self?.delegate?.travellerInfoChanged()
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Button Actions
    @IBAction private func doneButtonAction(_ sender: UIButton) {
        travellerClassViewModel.validateInputs()
    }
    
    @objc
    private func backButtonTapped(_ sender: UIBarButtonItem) {
        travellerClassViewModel.validateInputs()
    }
}

// MARK: - TableView DataSource and Delegate
extension TravellerClassVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return travellerClassViewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return travellerClassViewModel.sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellType = travellerClassViewModel.sections[indexPath.section][indexPath.row]
        
        switch cellType {
        case .traveller(let travellerType):
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as TravelerCell
            cell.config(travellerType: travellerType)
            cell.currentValue = travellerClassViewModel.travellerCount(for: travellerType)
            cell.min = travellerClassViewModel.getMinNumber(for: travellerType)
            cell.max = travellerClassViewModel.getMaxNumber(for: travellerType)
            cell.callback.didStepperValueChanged = {[weak self] travellerCount in
                self?.travellerClassViewModel.updateTravellerCount(travellerCount, for: travellerType)
            }
            return cell
            
        case .childrenAge:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SDDateSelectionCell
            let cellViewModel = travellerClassViewModel.getDateSelectionCellViewModel(for: indexPath)
            cell.configure(viewModel: cellViewModel)
            return cell
            
        case .flightClass(let className):
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as UITableViewCell
            configClassCell(cell, text: className.title)
            setCellSelection(cell, selected: travellerClassViewModel.flightClass.intValue == indexPath.row)
            return cell
        }
    }
    
    // MARK: - Cell's Helper
    func configClassCell(_ cell: UITableViewCell, text: String){
        cell.textLabel?.text = text
        cell.selectionStyle = .none
        cell.tintColor = UIColor.appPrimary
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: .medium)
    }
    
    func setCellSelection(_ cell: UITableViewCell, selected: Bool) {
        cell.accessoryType = selected ? .checkmark : .none
        cell.textLabel?.textColor = selected ? UIColor.appPrimary : .black
    }
}

extension TravellerClassVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellType = travellerClassViewModel.sections[indexPath.section][indexPath.row]
        switch cellType {
        case .childrenAge:
            return UITableView.automaticDimension
        default:
            return 56
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var title = ""
        switch section {
        case 0:
            title = "Passengers"
        case 2:
            title = "Cabin Class"
        default:
            return nil
        }

        let info = section == 0 ? "*Age on the day of travel" : nil
        
        let header = tableView.dequeueReusableHeaderFooterView() as LeftRightInfoHeaderView
        header.labelContainerView.backgroundColor = UIColor(hex: 0xfafafa)
        header.leftLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        header.rightLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        header.rightLabel.textColor = UIColor.darkGray
        header.setText(left: title, right: info)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section != 1 ? 48.0 : .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath), indexPath.section == 2 else { return }
        
        //return if the cell is already selected
        guard travellerClassViewModel.flightClass.intValue != indexPath.row else { return }
        
        // deselect previous selected cell
        if let selectedCell = tableView.cellForRow(at: IndexPath(row: travellerClassViewModel.flightClass.intValue, section: 2)) {
            setCellSelection(selectedCell, selected: false)
        }
        
        setCellSelection(cell, selected: true)
        travellerClassViewModel.setFlightClass(FlightClass.allCases[indexPath.row])
    }
}

extension TravellerClassVC: StoryboardBased {
    static var storyboardName: String {
        return "Flight"
    }
}
