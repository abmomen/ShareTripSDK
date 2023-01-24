//
//  FlightSearchVC.swift
//  ShareTrip
//
//  Created by Mac on 8/27/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit


//MARK: - FlightSerachVC Delegate
protocol FlightSearchVCDelegate: AnyObject {
    func updatedFlightSearchViewModel(_ viewModel: FlightSearchViewModel)
}

class FlightSearchVC: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak private var searchTableView: UITableView!
    
    //MARK: - Private Properties
    private static let AirportSearchVC = "AirportSearchVC"
    private var selectedFlightScheduledType: FlightScheduledType?
    private var selectedCellIndex: IndexPath?
    private var flightPromotion: FlightPromotions?
    
    //MARK: - Properties
    weak var flightSearchVCDelegate: FlightSearchVCDelegate?
    private var flightSearchViewModel = FlightSearchViewModel()
    
    //MARK: Analytics Manager
    private let analytics: AnalyticsManager = {
        let fae = FirebaseAnalyticsEngine()
        let manager = AnalyticsManager([fae])
        return manager
    }()
    
    //MARK:- VC's Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialData()
        setupScene()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchTableView.reloadData()
        
        if isModal {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "close-mono"), style: .done, target: self, action: #selector(closedButtonTapped(_:)))
            
        } else {
            self.tabBarController?.tabBar.isHidden = true
            if let totalPoints = STAppManager.shared.userAccount?.totalPoints {
                navigationItem.rightBarButtonItem = TripCoinBarButtonItem.createWithText(totalPoints.withCommas())
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == FlightSearchVC.AirportSearchVC {
            let airportSearchVC = segue.destination as! AirportSearchVC
            airportSearchVC.delegate = self
            airportSearchVC.cellIndex = selectedCellIndex!
            
            if let flightScheduledType = selectedFlightScheduledType {
                airportSearchVC.title = flightScheduledType == .departure ? "Flying From" : "Flying To"
            }
        }
    }
    
    func setViewModel(_ searchViewModel: FlightSearchViewModel) {
        self.flightSearchViewModel = searchViewModel
        flightSearchVCDelegate?.updatedFlightSearchViewModel(searchViewModel)
    }
    
    //MARK: - deinit
    deinit {
        selectedFlightScheduledType = nil
        selectedCellIndex =  nil
        flightSearchVCDelegate = nil
        STLog.info("deinit: FlightSearchVC")
    }
    
    //MARK: Helpers
    private func setupInitialData() {
        if let index = flightSearchViewModel.cellOptions.firstIndex(of: .date) {
            if flightSearchViewModel.getDateRange(for: index) == nil {
                let date1 = Date().adjust(.day, offset: searchingDateOffset)
                let date2 = Date().adjust(.day, offset: searchingDateOffset + 2)
                flightSearchViewModel.setDateRange(for: index, value: date1...date2)
            }
        }
        
        if STAppManager.shared.popularAirports.count == 0 {
            fetchTopAirports()
        } else {
            if flightSearchViewModel.getDeparture(for: 1) == nil {
                flightSearchViewModel.setDeparture(for: 1, value: STAppManager.shared.popularAirports.first!)
            }
        }
        fetchFlightPromotionBanner()
    }
    
    private func setupScene(){
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.allowsSelection = false
        
        searchTableView.registerCell(FlightRouteCell.self)
        searchTableView.registerCell(SingleButtonCell.self)
        searchTableView.registerCell(DoubleButtonCell.self)

        searchTableView.registerNibCell(PostCardCell.self)
        searchTableView.registerNibCell(AirportInputCell.self)
        searchTableView.registerNibCell(SingleInputTitleCell.self)
        searchTableView.registerNibCell(ExploreDestinationTVCell.self)
        
        searchTableView.addTopBackgroundView(viewColor: .clearBlue)
    }
    
    private var searchingDateOffset: Int {
        let now = Date()
        let hour = now.component(.hour) ?? 0
        let minute = now.component(.minute) ?? 0
        let currentTimeInMinute = hour*60 + minute
        
        let timeInMinute = UserDefaults.standard.integer(forKey: Constants.RemoteConfigKey.flight_search_threshold_time)
        let thresholdTimeInMinute = timeInMinute == 0 ? Constants.FlightConstants.thresholdTimeInMinute : timeInMinute
        if currentTimeInMinute < thresholdTimeInMinute {
            return Constants.FlightConstants.flightSearchingDateOffset
        } else {
            return Constants.FlightConstants.flightSearchingDateOffset + 1
        }
    }
    
    //MARK: UIActions
    @objc
    private func closedButtonTapped(_ sender: UIBarButtonItem){
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    private func handleDateSelection(for indexPath: IndexPath) {
        let calendarVC = FlightCalendarVC()
        var minDate = Date().adjust(.day, offset: searchingDateOffset)
        let maxDate = minDate.adjust(.year, offset: 1)
        
        if let srcDestTuple = flightSearchViewModel.getSourceDestCode(for: indexPath.row),
           srcDestTuple.0 == "DAC" {
            let priceIndicator = FlightPriceIndicatorViewModel(srcCode: srcDestTuple.0, destCode: srcDestTuple.1, routeType: flightSearchViewModel.flightRouteType)
            calendarVC.priceIndicator = priceIndicator
        }
        if flightSearchViewModel.flightRouteType == .round {
            let dateRange = flightSearchViewModel.getDateRange(for: indexPath.row)
            let firstDateViewData = JTCalendarDateViewData(title: "Departure Date", selectedDate: dateRange?.lowerBound)
            let secondDateViewData = JTCalendarDateViewData(title: "Return Date", selectedDate: dateRange?.upperBound)
            
            calendarVC.configure(
                minAllowableDate: minDate,
                maxAllowableDate: maxDate,
                firstDateViewData: firstDateViewData,
                secondDateViewData: secondDateViewData,
                allowSingleDate: true,
                delegate: self,
                indexPath: indexPath
            )
        } else {
            let date = flightSearchViewModel.getDate(for: indexPath.row)
            if flightSearchViewModel.flightRouteType == .multiCity {
                var row = indexPath.row
                while(row > 2) {
                    row -= 2
                    if let date = flightSearchViewModel.getDate(for: row) {
                        minDate = date
                        break
                    }
                }
            }
            let dateViewData = JTCalendarDateViewData(title: "Departure Date", selectedDate: date)
            calendarVC.configure(
                minAllowableDate: minDate,
                maxAllowableDate: maxDate,
                dateViewData: dateViewData,
                delegate: self,
                indexPath: indexPath
            )
        }
        
        navigationController?.pushViewController(calendarVC, animated: true)
    }
    
    private func handTravellerClassSelection() {
        let travellerClassVC = TravellerClassVC.instantiate()
        travellerClassVC.travellerClassViewModel = flightSearchViewModel.travellerClassViewModel
        travellerClassVC.delegate = self
        navigationController?.pushViewController(travellerClassVC, animated: true)
    }
    
    private func handleSearchFlightButtonTapped() {
        let result = flightSearchViewModel.validate()
        switch result {
        case .success:
            break
        case .failure(.validationError(let message)):
            showMessage(message, type: .error)
            return
        }
        
        if let req = flightSearchViewModel.getFlightSearchRequest() {
            analytics.log(FlightEvent.search(request: req))
            if req.flightClass == .business {
                analytics.log(FlightEvent.searchBusinessClass())
            }
        }
        
        if isModal {
            if flightSearchViewModel.getFlightSearchRequest() != nil {
                flightSearchVCDelegate?.updatedFlightSearchViewModel(flightSearchViewModel)
            }
            dismiss(animated: true, completion: nil)
        } else {
            let flightListVC = FlightListVC.instantiate()
            if let flightSearchRequest = flightSearchViewModel.getFlightSearchRequest() {
                flightListVC.flightSearchViewModel = flightSearchViewModel
                flightListVC.flightListViewModel = FlightListViewModel(request: flightSearchRequest, delegate: flightListVC)
            }
            navigationController?.pushViewController(flightListVC, animated: false)
        }
    }
    
    private func handleSwapButtonTapped(for indexPath: IndexPath) {
        flightSearchViewModel.swapAirports(for: indexPath.row)
        searchTableView.reloadRowsSafely(at: [indexPath], with: .none)
    }
    
    private func handleExploreButtonTap() {
        let vc = SafeDestinationSearchVC.instantiate()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func resetViewModelData(_ isPromotionAvailable: Bool) {
        self.flightSearchViewModel.isPromotionAvailable = isPromotionAvailable
        self.flightSearchViewModel.updateCellOption(for: .none)
    }
    
    //MARK: - API Calls
    private func fetchTopAirports(reset: Bool = false) {
        guard reset || STAppManager.shared.popularAirports.count == 0 else { return }
        
        _ = FlightAPIClient().airportSearch(name: "top") { [weak self] (result) in
            switch result {
            case .success(let response):
                if response.code == APIResponseCode.success, let popularAirports = response.response, popularAirports.count > 0 {
                    STAppManager.shared.popularAirports = popularAirports
                    
                    self?.flightSearchViewModel.setDeparture(for: 1, value: popularAirports.first!)
                    DispatchQueue.main.async {
                        self?.searchTableView.reloadRowsSafely(at: [IndexPath(row: 1, section: 0)], with: .none)
                    }
                } else {
                    STLog.error(response.message)
                }
            case .failure(let error):
                STLog.error(error.localizedDescription)
            }
        }
    }
    
    private func fetchFlightPromotionBanner() {
        FlightAPIClient().fetchFlightPromotions(completion: { [weak self](result) in
            switch result {
            case .success(let response):
                if response.code == APIResponseCode.success, let flightPromotions = response.response {
                    self?.flightPromotion = flightPromotions
                    self?.resetViewModelData(true)
                    DispatchQueue.main.async { self?.searchTableView.reloadData()}
                } else {
                    self?.resetViewModelData(false)
                    DispatchQueue.main.async { self?.searchTableView.reloadData()}
                    STLog.error(response.message)
                }
            case .failure(let error):
                self?.resetViewModelData(false)
                DispatchQueue.main.async { self?.searchTableView.reloadData()}
                STLog.error(error.localizedDescription)
            }
        })
    }
}

//MARK:- UITableViewDataSource
extension FlightSearchVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flightSearchViewModel.cellOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellOption = flightSearchViewModel.cellOptions[indexPath.row]
        
        switch cellOption {
        case .routeType:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as FlightRouteCell
            cell.configure(selectedRoute: flightSearchViewModel.flightRouteType, delegate: self)
            return cell
            
        case .airport:
            let flightInfoTuple = flightSearchViewModel.getFlightInfoTuple(for: indexPath.row)
            let firstValue = flightInfoTuple?.departure?.iata
            let secondValue = flightInfoTuple?.arrival?.iata
            
            let swapButtonShown = flightSearchViewModel.flightRouteType != FlightRouteType.multiCity
            
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as AirportInputCell
            let inputData = AirportInputData(dotShown: false, swapShown: swapButtonShown, inputTypeImage: "plane-vertical-mono", firstPlaceholder: "Airport", secondPlaceholder: "Airport", firstInputValue: firstValue, secondInputValue: secondValue)
            cell.configure(indexPath: indexPath, inputData: inputData) { [weak self] (cellIndexPath, inputNumber) in
                self?.selectedCellIndex = cellIndexPath
                self?.selectedFlightScheduledType = FlightScheduledType(rawValue: inputNumber)
                self?.performSegue(withIdentifier: FlightSearchVC.AirportSearchVC, sender: nil)
            }
            cell.contentView.backgroundColor = UIColor.appPrimary
            cell.swapCallbackClosure = { [weak self] cellIndexPath in
                self?.handleSwapButtonTapped(for: cellIndexPath)
            }
            
            return cell
            
        case .date, .travellerClass:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SingleInputTitleCell
            
            var title: String!
            var placeholder: String!
            var inputValue: String!
            var inputTypeImage: String!
            if cellOption == .date {
                placeholder = "Select date"
                inputValue = flightSearchViewModel.getformatedDateString(for: indexPath.row)
                inputTypeImage = "calander-mono"
                switch flightSearchViewModel.flightRouteType {
                case .round:
                    title = "Departure and Arrival Dates"
                case .oneWay, .multiCity:
                    title = "Departure Date"
                }
            } else {
                title = "Passengers & Cabin Class"
                placeholder = "Passengers & Cabin Class"
                inputValue = flightSearchViewModel.travellersText
                inputTypeImage = "people-mono"
            }
            
            let inputData = SingleInputTitleData(titleLabel: title, inputTypeImage: inputTypeImage,
                                                 placeholder: placeholder, inputValue: inputValue)
            
            let callBackClosure: ((IndexPath) -> Void) = { [weak self] (cellIndex) in
                guard let strongSelf = self else { return }
                let cellOption = strongSelf.flightSearchViewModel.cellOptions[cellIndex.row]
                if cellOption == .date {
                    strongSelf.handleDateSelection(for: cellIndex)
                } else {
                    strongSelf.handTravellerClassSelection()
                }
            }
            
            cell.configure(indexPath: indexPath, singleInputData: inputData, callbackClosure: callBackClosure)
            cell.contentView.backgroundColor = UIColor.appPrimary
            return cell
            
        case .addCity:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as DoubleButtonCell
            let data = DoubleButtonData(typeImage: "circled-add", firstTitle: "ADD CITY", secondTitle: "REMOVE",
                                        firstEnabled: flightSearchViewModel.hasMoreRoutes, secondEnabled: flightSearchViewModel.addedNewRoute)
            cell.configure(buttonData: data, indexPath: indexPath, delegate: self)
            cell.contentView.backgroundColor = UIColor.appPrimary
            return cell
            
        case .searchButton:
            let singleButtonCell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SingleButtonCell
            singleButtonCell.configure(indexPath: indexPath, buttonTitle: "Search Flights", buttonType: .searchButton, enabled: flightSearchViewModel.searchButtonEnabled) { [weak self] (cellIndex) in
                self?.handleSearchFlightButtonTapped()
            }
            singleButtonCell.selectionStyle = .none
            singleButtonCell.contentView.backgroundColor = UIColor.appPrimary
            singleButtonCell.contentView.roundBottomCorners(radius: 12.0, frame: UIScreen.main.bounds)
            return singleButtonCell
            
        case .explore:
            let exploreCell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ExploreDestinationTVCell
            exploreCell.configureCell(title: "Can I travel to...?", "Search for safe destinations available now!", indexPath, "") { [weak self] (cellIndex) in
                self?.handleExploreButtonTap()
            }
            return exploreCell
            
        case .promotionalImage:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as PostCardCell
            let data = PostCardCell.PostCardCellData(
                imageUrl: flightPromotion?.image,
                title: "",
                text: ""
            )
            cell.configure(postCardCellData: data)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let cellOption = flightSearchViewModel.cellOptions[indexPath.row]
        
        if cellOption == .searchButton {
            return 112.0
        } else if cellOption == .explore {
            return 100.0
        } else if cellOption == .promotionalImage {
            return 190.0
        }
        return 68.0
    }
}

//MARK: - Flight Route Type Delegate
extension FlightSearchVC: FlightRouteDelegate {
    func flightRouteTypeChanged(type: FlightRouteType) {
        let oldCount = flightSearchViewModel.cellOptions.count
        flightSearchViewModel.updateCellOption(for: type)
        let newCount = flightSearchViewModel.cellOptions.count
        searchTableView.reloadRowsInSection(section: 0, oldCount: oldCount, newCount: newCount)
    }
}

//MARK: - AirportSearch Delegate
extension FlightSearchVC: AirportSearchDelegate {
    func userDidSelectedAirport(_ airport: Airport, cellIndex: IndexPath) {
        guard let flightScheduledType = selectedFlightScheduledType else { return }
        switch flightScheduledType {
        case .departure:
            flightSearchViewModel.setDeparture(for: cellIndex.row, value: airport)
        case .arrival:
            flightSearchViewModel.setArrival(for: cellIndex.row, value: airport)
        }
        searchTableView.reloadData()
    }
}

//MARK: - Select Airport Delegate
extension FlightSearchVC: DoubleButtonCellDelegate {
    func firstButtonTapped(indexPath: IndexPath) {
        let oldCount = flightSearchViewModel.cellOptions.count
        flightSearchViewModel.addCity()
        let newCount = flightSearchViewModel.cellOptions.count
        searchTableView.reloadRowsInSection(section: 0, oldCount: oldCount, newCount: newCount)
    }
    
    func secondButtonTapped(indexPath: IndexPath) {
        let oldCount = flightSearchViewModel.cellOptions.count
        flightSearchViewModel.removeCity()
        let newCount = flightSearchViewModel.cellOptions.count
        searchTableView.reloadRowsInSection(section: 0, oldCount: oldCount, newCount: newCount)
    }
}

//MARK: - Traveler Info Delegate
extension FlightSearchVC: TravellerClassVCDelegate {
    func travellerInfoChanged() {
        if let index = flightSearchViewModel.cellOptions.firstIndex(of: .travellerClass) {
            searchTableView.reloadRowsSafely(at: [IndexPath(row: index, section: 0)], with: .none)
        }
    }
}

//MARK: - Calendar Delegate
extension FlightSearchVC: JTCalendarVCDelegate {
    func dateSelectionChanged(selectedDate: Date, for indexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        flightSearchViewModel.setDate(for: indexPath.row, value: selectedDate)
        var indexPaths = [indexPath]
        if let index = flightSearchViewModel.cellOptions.firstIndex(of: .searchButton) {
            indexPaths.append(IndexPath(row: index, section: 0))
        }
        searchTableView.reloadRowsSafely(at: indexPaths, with: .none)
    }
    
    func dateSelectionChanged(firstDate: Date, secondDate: Date, for indexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        flightSearchViewModel.setDateRange(for: indexPath.row, value: firstDate...secondDate)
        var indexPaths = [indexPath]
        if let index = flightSearchViewModel.cellOptions.firstIndex(of: .searchButton) {
            indexPaths.append(IndexPath(row: index, section: 0))
        }
        searchTableView.reloadRowsSafely(at: indexPaths, with: .none)
    }
}

//MARK: - Storyboard Extension
extension FlightSearchVC: StoryboardBased {
    static var bundle: Bundle? {
        return Bundle(identifier: "net.sharetrip.ios.flight")
    }
    
    static var storyboardName: String {
        return "Flight"
    }
}
