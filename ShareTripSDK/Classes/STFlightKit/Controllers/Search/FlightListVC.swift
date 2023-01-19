//
//  FlightListVC.swift
//  ShareTrip
//
//  Created by Mac on 9/25/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit


class FlightListVC: UIViewController {
    
    @IBOutlet private weak var topBarView: UIView!
    @IBOutlet private weak var availableFlightLabel: UILabel!
    @IBOutlet private weak var vatLabel: UILabel!
    @IBOutlet private weak var filterButton: UIButton!
    @IBOutlet private weak var flightTableView: UITableView!
    @IBOutlet private weak var flightSortingButtonGroup: FlightSortingButtonGroup!
    @IBOutlet private weak var airlinesFilterCollectionView: UICollectionView!
    @IBOutlet private weak var airlinesFilterCollectionViewHLC: NSLayoutConstraint!
    private weak var emptyMessageView: ErrorView?
    
    //MARK: - Private Properties
    private static let FlightDetailSegueID = "FlightDetailSegueID"
    private weak var loadingVC: LoadingVC?
    private var animationTime: Date?
    private var firstTimeLoading: Bool = true
    private weak var cancelSearchAlert: UIAlertController?
    private var selectedAirlineFilterIndex: Int?
    
    //MARK: - Public Properties
    var flightListViewModel: FlightListViewModel!
    var flightSearchViewModel: FlightSearchViewModel!
    
    //MARK: - Analytics
    private let analytics: AnalyticsManager = {
        let fae = FirebaseAnalyticsEngine()
        let manager = AnalyticsManager([fae])
        return manager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetupScene()
        flightListViewModel.fetchInitialFlights()
        addLoadingText()
        setupAirlinesFilterCollectionView()
    }
    
    deinit {
        STLog.info("\(String(describing: self)) deinit")
    }
    
    func reloadData() {
        flightListViewModel.reloadData()
        addLoadingText()
    }
    
    // MARK: - IBAction
    @objc
    private func cancelButtonTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(
            title: "Cancel Search",
            message: "Do you want to cancel search?",
            preferredStyle: .alert
        )
        cancelSearchAlert = alertController
        
        // Create the actions
        let yesAction = UIAlertAction(title: "Yes Cancel", style: .destructive) { [weak self] UIAlertAction in
            self?.navigationController?.popViewController(animated: true)
            self?.flightListViewModel.resetRequestModel()
        }
        
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        present(alertController, animated: true)
    }
    
    @objc
    private func backButtonTapped(_ sender: UIBarButtonItem) {
        
        if let flightSearchVC = navigationController?.previousViewController as? FlightSearchVC {
            flightSearchVC.setViewModel(flightSearchViewModel)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    func navTitleViewTapped(_ sender: UIGestureRecognizer? = nil) {
        let flightSearchVC = FlightSearchVC.instantiate()
        flightSearchVC.flightSearchVCDelegate = self
        flightSearchVC.setViewModel(flightSearchViewModel)
        
        let navController = NavigationController(rootViewController: flightSearchVC)
        navController.navigationBar.shadowImage = UIImage()
        present(navController, animated: true, completion: nil)
    }
    
    @IBAction func filterButtonTapped(_ sender: Any) {
        analytics.log(FlightEvent.clickOnFilter())
        
        if flightListViewModel.flightFilter != nil {
            let flightFilterVC = FlightFilterVC()
            let flightFilterViewModel = flightListViewModel.flightFilterViewModel(flightClass: flightSearchViewModel.flightClass, flightRouteType: flightSearchViewModel.flightRouteType)
            flightFilterVC.viewModel = flightFilterViewModel
            flightFilterVC.navTitleViewData = flightSearchViewModel.navigationTitleViewData(showArrow: false)
            flightFilterVC.filterDelegate = self
            let navController = NavigationController(rootViewController: flightFilterVC)
            present(navController, animated: true, completion: nil)
        } else {
            setFilterButtonStatus()
        }
    }
    
    // MARK: - Helpers
    func initialSetupScene(){
        setupNavigationTitle()
        topBarView.layer.cornerRadius = 8.0
        topBarView.layer.addZeplinShadow(color: .black, alpha: 0.29, x: 0, y: 4, blur: 8.0, spread: 0.0)
        
        flightTableView.delegate = self
        flightTableView.dataSource = self
        flightTableView.prefetchDataSource = self
        flightTableView.registerNibCell(FlightCell.self)
        self.view.backgroundColor = .offWhite
        flightTableView.contentInset = UIEdgeInsets.zero
        flightTableView.contentInsetAdjustmentBehavior = .never
        
        flightSortingButtonGroup.setup(delegate: self)
    }
    
    func setupNavigationTitle() {
        let titleView = FlightNavTitleView(viewData: flightSearchViewModel.navigationTitleViewData())
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.navTitleViewTapped(_:)))
        titleView.isUserInteractionEnabled = true
        titleView.addGestureRecognizer(tapGesture)
        self.navigationItem.titleView = titleView
    }
    
    func setFilterButtonStatus() {
        if flightListViewModel.flightFilter == nil {
            filterButton.isEnabled = false
            filterButton.alpha = 0.6
            flightSortingButtonGroup.disable()
        } else {
            filterButton.isEnabled = true
            filterButton.alpha = 1.0
            flightSortingButtonGroup.enable()
        }
    }
    
    private func addLoadingText(loading: Bool = true) {
        if loading {
            availableFlightLabel.text = "FINDING YOUR FLIGHTS!"
            vatLabel.text = "Fetching best fares"
            filterButton.isHidden = true
            flightSortingButtonGroup.hide()
            navigationItem.leftBarButtonItems = [UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped(_:)))]
        } else {
            availableFlightLabel.text = flightListViewModel.availableFlightCountText
            vatLabel.text = "*Price includes VAT & Tax"
            filterButton.isHidden = false
            flightSortingButtonGroup.show()
            
            cancelSearchAlert?.dismiss(animated: true, completion: nil)
            cancelSearchAlert = nil
            navigationItem.leftBarButtonItems = BackButton.createWithText("Back", color: .white, target: self, action: #selector(backButtonTapped(_:)))
        }
    }
    
    private func setupAirlinesFilterCollectionView() {
        if let layout = airlinesFilterCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        airlinesFilterCollectionView.addZeplinShadow()
        airlinesFilterCollectionView.delegate = self
        airlinesFilterCollectionView.dataSource = self
        airlinesFilterCollectionView.registerNibCell(FlightNameCollectionViewCell.self)
        airlinesFilterCollectionView.isHidden = true
        airlinesFilterCollectionViewHLC.constant = 0
    }
    
    private func updateSortingOptions() {
        flightSortingButtonGroup.setSelected(option: flightListViewModel.getFilterDeal())
    }
}

//MARK:- FlightListViewModelDelegate
extension FlightListVC: FlightListViewModelDelegate {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            addLoadingText(loading: false)
            setFilterButtonStatus()
            flightTableView.reloadData()
            
            if flightListViewModel.rowCount == 0 {
                airlinesFilterCollectionView.isHidden = true
                airlinesFilterCollectionViewHLC.constant = 0
            } else {
                updateSortingOptions()
                airlinesFilterCollectionView.isHidden = false
                airlinesFilterCollectionViewHLC.constant = 56
                airlinesFilterCollectionView.reloadData()
            }
            
            return
        }
        
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        flightTableView.reloadRowsSafely(at: indexPathsToReload, with: .automatic)
    }
    
    func onFetchFailed(with reason: String) {
        addLoadingText(loading: false)
        setFilterButtonStatus()
        showMessage("Flight Not Available", type: .error)
        if flightListViewModel.rowCount == 0 {
            flightTableView.reloadData()
            airlinesFilterCollectionView.isHidden = true
            airlinesFilterCollectionViewHLC.constant = 0
        }
    }
    
    func onResetRequest() {
        addLoadingText()
        flightTableView.reloadData()
    }
    
}

private extension FlightListVC {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= flightListViewModel.currentCount
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = flightTableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
    
    func addEmptyMessageView() {
        let message = "We've searched more than 100 airlines that we sell, and couldn't find any flights on these dates. Please try Changing your search details."
        
        let emptyMessageView = ErrorView(
            frame: self.view.bounds,
            imageName: "no-flight-color",
            title: "Sorry!",
            message: message,
            buttonTitle: "RETRY"
        )
        
        emptyMessageView.buttonCallback = { [weak self] in
            self?.navTitleViewTapped()
        }
        
        emptyMessageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyMessageView)
        
        emptyMessageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        emptyMessageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        emptyMessageView.topAnchor.constraint(equalTo: topBarView.bottomAnchor, constant: 8.0).isActive = true
        emptyMessageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.bringSubviewToFront(emptyMessageView)
        self.emptyMessageView = emptyMessageView
    }
    
    func removeEmptyMessageView() {
        emptyMessageView?.removeFromSuperview()
        emptyMessageView = nil
    }
}

//MARK:- UITableView DataSource & Delegate
extension FlightListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if flightListViewModel.rowCount == 0 {
            addEmptyMessageView()
        } else {
            removeEmptyMessageView()
        }
        
        return flightListViewModel.rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as FlightCell
        
        if isLoadingCell(for: indexPath) {
            cell.configure(with: .none, legCount: flightSearchViewModel.flightLeg)
        } else {
            if let rowViewModel = flightListViewModel.rowViewModel(at: indexPath.row) {
                cell.configure(with: rowViewModel, legCount: rowViewModel.flightLegDatas.count)
            } else {
                cell.configure(with: .none, legCount: flightSearchViewModel.flightLeg)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat!
        if let rowViewModel = flightListViewModel.rowViewModel(at: indexPath.row) {
            let hasDealTag = rowViewModel.dealType == .preferred ||
            rowViewModel.dealType == .best
            height = FlightCell.getCellHeight(
                hasDealTag: hasDealTag,
                legCount: rowViewModel.flightLegDatas.count,
                hasTechincalStoppage: rowViewModel.hasTechnicalStoppage
            )
        } else {
            height = FlightCell.getCellHeight(hasDealTag: false, legCount: flightSearchViewModel.flightLeg, hasTechincalStoppage: false)
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Analytics
        if let rowViewModel = flightListViewModel.rowViewModel(at: indexPath.row) {
            analytics.log(FlightEvent.viewFlightDetails())
            
            if rowViewModel.dealType == FlightDealType.preferred {
                analytics.log(FlightEvent.clickOnPreferredAirline())
            } else if rowViewModel.dealType == FlightDealType.best {
                analytics.log(FlightEvent.clickOnBestDeal())
            }
        }
        
        // goto details view
        let selectedFlight = flightListViewModel.flight(at: indexPath.row)
        let flightSearchRequestParmas = flightSearchViewModel.flightSearchRequestParmas
        
        guard let selectedFlightViewModel = flightListViewModel.selectedFlightViewModel(
            flight: selectedFlight, searchParams: flightSearchRequestParmas) else {
            return
        }
        let flightDetailsVC = FlightDetailsVC.instantiate()
        flightDetailsVC.flightDetailsViewModel = selectedFlightViewModel
        navigationController?.pushViewController(flightDetailsVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
}

extension FlightListVC: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) && flightListViewModel.hasMore {
            flightListViewModel.fetchNextFlights()
        }
    }
}

extension FlightListVC: FlightSearchVCDelegate {
    func updatedFlightSearchViewModel(_ viewModel: FlightSearchViewModel) {
        if let flightSearchRequest = viewModel.getFlightSearchRequest() {
            self.flightSearchViewModel = viewModel
            self.flightListViewModel = FlightListViewModel(request: flightSearchRequest, delegate: self)
            setupNavigationTitle()
            //Load next search
            self.flightListViewModel.onSarchRequestChange()
        }
    }
}

//MARK:- FlightFilterVC Delegate
extension FlightListVC: FlightFilterVCDelegate {
    func resetFilterButtonDidTapped() {
        flightListViewModel.onSarchRequestChange()
    }
    
    func searchFilterButtonDidTapped(filteredData: FlightFilterData) {
        analytics.log(FlightEvent.aplliedFilter(filterData: filteredData))

        var filter = filteredData
        filter.sort = nil
        flightSortingButtonGroup.deselectAll()
        flightListViewModel.onFilterSearch(for: filter)
    }
}

extension FlightListVC: FlightSortingButtonGroupDelegate {
    func sortingButtonTapped(buttonType: FlightSortingOptions, isOn: Bool) {
        analytics.log(FlightEvent.clickOnSort(sortingCriteria: buttonType.rawValue))
        selectedAirlineFilterIndex = nil
        airlinesFilterCollectionViewHLC.constant = 0
        var filter = FlightFilterData()
        if isOn {
            filter.sort = buttonType.rawValue
        }
        flightListViewModel.onFilterSearch(for: filter)
    }
}

extension FlightListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flightListViewModel.flightFilter?.airlines.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = airlinesFilterCollectionView.dequeueReusableCell(forIndexPath: indexPath) as FlightNameCollectionViewCell
        let cellData = flightListViewModel.flightFilter?.airlines[indexPath.row]
        var isLastCell = false
        var isSelected = false
        if let selectedIndex = selectedAirlineFilterIndex {
            if indexPath.row == selectedIndex {
                isSelected = true
            } else {
                isSelected = false
            }
        } else {
            isSelected = false
        }
        if (flightListViewModel.flightFilter?.airlines.count ?? 0) - 1 == indexPath.row {
            isLastCell = true
        } else {
            isLastCell = false
        }
        cell.configure(
            airlineCode: cellData?.code ?? "",
            round: Int(cellData?.records ?? 0),
            isLastCell: isLastCell,
            isSelected: isSelected
        )
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedAirlineFilterIndex = indexPath.row
        let airline = flightListViewModel.flightFilter?.airlines[indexPath.row]
        var selectedAirLines = [String]()
        selectedAirLines.append(airline?.code ?? "")
        let filterData = FlightFilterData(airlines: selectedAirLines)
        flightListViewModel.onFilterSearch(for: filterData)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 108, height: 44)
    }    
}

extension FlightListVC: StoryboardBased {
    static var storyboardName: String {
        return "Flight"
    }
}
