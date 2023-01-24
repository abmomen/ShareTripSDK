//
//  FlightFilterVC.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 12/2/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit


protocol FlightFilterVCDelegate: AnyObject {
    func resetFilterButtonDidTapped()
    func searchFilterButtonDidTapped(filteredData: FlightFilterData)
}

class FlightFilterVC: ViewController {
    
    //MARK: - Private Properties
    private var selectedFilterType: FlightFilterType?
    
    //MARK: - Public Properties
    var viewModel: FlightFilterViewModel!
    var navTitleViewData: FlightNavTitleViewData!
    
    weak var delegate: PriceRangeCellDelegate?
    weak var filterDelegate: FlightFilterVCDelegate?
    weak var bottomFilterCardView: FlightFilterCardView?
    
    //MARK: UIView's Components
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("FILTER SEARCH", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17.0, weight: .semibold)
        button.backgroundColor = .appPrimary
        button.addTarget(self, action: #selector(filterSearchbuttonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        setupView()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let user = STAppManager.shared.userAccount {
            navigationItem.rightBarButtonItem = TripCoinBarButtonItem.createWithText(user.totalPoints.withCommas())
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "close-mono"), style: .done, target: self, action: #selector(closedButtonTapped(_:)))
        }
    }
    
    //MARK:- Helpers
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear
        tableView.backgroundColor = .offWhite
        tableView.registerNibCell(FilterCell.self)
        tableView.registerNibCell(FilterResetCell.self)
    }
    
    private func setupView() {
        let titleView = FlightNavTitleView(viewData: navTitleViewData)
        navigationItem.titleView = titleView
        view.backgroundColor = .offWhite
        view.addSubview(tableView)
        view.addSubview(filterButton)
        
        var constraints = [
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filterButton.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            filterButton.heightAnchor.constraint(equalToConstant: 44.0),
        ]
        constraints.append(filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor))
        NSLayoutConstraint.activate(constraints)
    }
    
    private func showFilterCardView(_ filterType: FlightFilterType) {
        
        let maxHeight = view.frame.size.height * 0.85
        let cardView = FlightFilterCardView(
            filterType: filterType,
            viewModel: viewModel,
            maxHeight: maxHeight,
            delegate: self
        )
        view.addSubview(cardView)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cardView.topAnchor.constraint(equalTo: view.topAnchor),
            cardView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        bottomFilterCardView = cardView
        view.layoutIfNeeded()
        cardView.showFilterCardView()
    }
    
    private func hideFilterCardView() {
        bottomFilterCardView?.hideFilterCardView()
    }
    
    //MARK: Actions:
    @objc
    private func closedButtonTapped(_ sender: UIButton) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func filterSearchbuttonTapped(_ sender: UIButton) {
        filterDelegate?.searchFilterButtonDidTapped(filteredData: viewModel.filteredData)
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    private func handleFilterTypeSelection(_ filterType: FlightFilterType) {
        selectedFilterType = filterType
        showFilterCardView(filterType)
    }
}

//MARK: - UITableViewDelegate
extension FlightFilterVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FlightFilterType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellType = FlightFilterType.allCases[indexPath.row]
        switch cellType {
        case .reset:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as FilterResetCell
            let numberOfFlight = viewModel.flightCount == 0 ? "No Flight Available" :
            "\(viewModel.flightCount) \("Flight".getPlural(count: viewModel.flightCount)) Available"
            cell.configure(subtitle: numberOfFlight, delegate: self)
            return cell
        case .priceRange, .airline, .layover, .schedule, .stoppage, .weight, .refundble:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as FilterCell
            
            var subtitle: String = cellType.subTitle
            switch cellType {
            case .priceRange:
                let priceRange: FilterPriceRange = viewModel.filterPriceRange
                let currentLow = priceRange.currentLow ?? priceRange.low
                let currentHigh = priceRange.currentHigh ?? priceRange.high
                subtitle = "\(currentLow.withCommas()) - \(currentHigh.withCommas())"
            default:
                break
            }
            
            cell.configure(title: cellType.title, subTitle: subtitle)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cellType = FlightFilterType.allCases[indexPath.row]
        if cellType != .reset {
            handleFilterTypeSelection(cellType)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72.0
    }
}

//MARK: - PriceRangeCellDelegate
extension FlightFilterVC: PriceRangeCellDelegate {
    func rangeSeekSliderDidChange(minValue: CGFloat, maxValue: CGFloat) {
        viewModel.setPriceRange(minValue: Int(minValue), maxValue: Int(maxValue))
    }
}

//MARK: - FilterResetCellDelegate
extension FlightFilterVC: FilterResetCellDelegate {
    func filterResetButtonTapped() {
        viewModel.resetFilterData()
        
        tableView.reloadData()
        filterDelegate?.resetFilterButtonDidTapped()
        
        delay(0.10) { [weak self] in
            self?.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
}

//MARK: - FilterCardViewDelgate
extension FlightFilterVC : FlightFilterCardViewDelgate {
    func crossButtonTapped() {
        hideFilterCardView()
    }
    
    func applyButtonTapped() {
        hideFilterCardView()
        guard let filterType = selectedFilterType else { return }
        let indexPath = IndexPath(row: filterType.rawValue, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
