//
//  FlightListViewModel.swift
//  STFlightKit
//
//  Created by ST-iOS on 11/23/22.
//


import Alamofire

protocol FlightListViewModelDelegate: AnyObject {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String)
    func onResetRequest()
}

final class FlightListViewModel {
    private weak var delegate: FlightListViewModelDelegate?
    private var currentPage = 0
    private var fetchDataRequest: DataRequest?
    private var response: FlightSearchResponse?
    private var flights: [Flight] = []
    private var request: FlightSearchRequest {
        didSet {
            onSarchRequestChange()
        }
    }
    
    //MARK:- Computed Properties

    private var total: Int {
        return response?.totalRecords ?? 0
    }
    
    var hasMore: Bool {
        if firstSearch {
            return true
        }
        if let flightSearchResponse = response {
            return flightSearchResponse.totalRecords > flights.count
        } else {
            return false
        }
    }

    private var filteredData: FlightFilterData? {
        didSet {
            //FIXME: exclude stoppage, etc if all option is checked
        }
    }
    
    //MARK:- Initialization
    
    init(request: FlightSearchRequest, delegate: FlightListViewModelDelegate) {
        self.request = request
        self.delegate = delegate
    }
    
    func resetRequestModel() {
        fetchDataRequest?.cancel()
        fetchDataRequest = nil
        currentPage = 0
        firstSearch = true
        flights.removeAll()
        
        //Let ViewController Know about the reset
        delegate?.onResetRequest()
    }

    //MARK:- Flight
    
    var availableFlightCountText: String {
        let availableFlightCount = hasMore ? total : currentCount
        let countText = availableFlightCount == 0 ? "No" : String(availableFlightCount)
        let flightText = "Flight".getPlural(count: availableFlightCount)
        return "\(countText) \(flightText) Available"
    }
    
    var currentCount: Int {
        return flights.count
    }
    
    var rowCount: Int {
        if firstSearch {
            return 10
        } else if hasMore {
            return currentCount + 2
        } else {
            return currentCount
        }
    }
    
    func getFilterDeal() -> FlightSortingOptions {
        guard let filterDeal = response?.filterDeal else { return .unknown }
        return filterDeal
    }
    
    func flight(at index: Int) -> Flight? {
        guard index < flights.count else {
            return nil
        }
        return flights[index]
    }
    
    func rowViewModel(at index: Int) -> FlightRow? {
        
        guard index < flights.count else { return nil }
        
        let flight = flights[index]
        let flightLegDatas = flight.flightLegs.map {
            FlightLegData(originName: $0.originName.code, destinationName: $0.destinationName.code,
                          airplaneName: $0.airlines.short, airplaneLogo: $0.logo,
                          departureTime: $0.departureDateTime.time, arrivalTime: $0.arrivalDateTime.time,
                          stop: $0.stop, dayCount: $0.dayCount, duration: $0.duration)
        }

        var hasTechnicalStoppage = false
        for segment in flight.segments {
            for segmentDetail in segment.segmentDetails {
                if segmentDetail.hiddenStop != nil {
                    hasTechnicalStoppage = true
                    break
                }
            }
        }
        
        return FlightRow(
            currency: flight.currency,
            totalPrice: flight.originPrice,
            discountPrice: flight.price,
            discountPercentage: flight.discount,
            earnPoint: flight.earnPoint,
            sharePoint: flight.sharePoint,
            flightLegDatas: flightLegDatas,
            hasTechnicalStoppage: hasTechnicalStoppage,
            isRefundable: flight.isRefundable ?? "Non Refundable",
            dealType: flight.deal
        )
    }
    
    var flightFilter: FlightFilter? {
        return response?.filters
    }

    func selectedFlightViewModel(flight: Flight?, searchParams: FlightSearchRequestParmas) -> FlightDetailsViewModel? {
        guard let response = response else { return nil }
        guard let flight = flight else { return nil }

        let flightInfo = SelectedFlightInfo(
            adult: searchParams.adult,
            child: searchParams.child,
            infant: searchParams.infanct,
            searchId: response.searchId,
            sessionId: response.sessionId,
            flight: flight,
            flightClass: response.flightClass,
            searchDepartDate: searchParams.depurtureDate,
            flightRouteType: response.flightRouteType,
            firstAirportIata: searchParams.firstAirportIata,
            lastAirportIata: searchParams.lastAirportIata
        )
        
        return FlightDetailsViewModel(flightInfo: flightInfo)
    }
    
    func flightFilterViewModelOld(flightClass: FlightClass, flightRouteType: FlightRouteType) -> FlightFilterViewModelOld? {
        guard let flightFilter = flightFilter else { return nil }
        let data = filteredData ?? FlightFilterData()
        return FlightFilterViewModelOld(filter: flightFilter, filteredData: data, flightClass: flightClass, flightRouteType: flightRouteType)
    }
    
    func flightFilterViewModel(flightClass: FlightClass, flightRouteType: FlightRouteType) -> FlightFilterViewModel? {
        guard let flightFilter = flightFilter else { return nil }
        let data = filteredData ?? FlightFilterData()
        return FlightFilterViewModel(filter: flightFilter, filteredData: data, flightClass: flightClass, flightRouteType: flightRouteType, flightCount: total)
    }

    //MARK: Fetch Flights
    private var firstSearch: Bool = true
    func fetchInitialFlights() {
        firstSearch = true
        fetchFlights() { [weak self] _ in
            self?.firstSearch = false
        }
    }

    func reloadData() {
        response = nil
        resetRequestModel()
        fetchFlights() { [weak self] _ in
            self?.firstSearch = false
        }
    }
    
    func fetchNextFlights() {
         fetchFlights()
    }
    
    func onSarchRequestChange() {
        response = nil
        filteredData = nil
        resetRequestModel()
        fetchInitialFlights()
    }
    
    func onFilterSearch(for data: FlightFilterData) {
        self.filteredData = data
        resetRequestModel()
        fetchInitialFlights()
    }
    
    func onFilterReset() {
        filteredData = nil
        resetRequestModel()
        fetchInitialFlights()
    }

    private func fetchFlights(onComplete: ((Bool)->Void)? = nil) {

        guard fetchDataRequest == nil else { return }
        
        currentPage += 1
        var parameters: Parameters!

        if response == nil {
            parameters = request.getParameters()
        } else {
            //next Search
            let flightSearchFilter = FlightSearchFilter(page: currentPage, searchId: response!.searchId, filter: filteredData)
            if let encodedData = try? JSONEncoder().encode(flightSearchFilter) {
                parameters = try! JSONSerialization.jsonObject(with: encodedData, options: []) as! Parameters
            } else {
                parameters = [
                    Constants.APIParameterKey.searchId: response!.searchId,
                    Constants.APIParameterKey.page: currentPage
                ]
            }
        }
        
        fetchDataRequest = FlightAPIClient().flightSearch(params: parameters, hasFilter: response != nil) { [weak self] (result) in
            
            guard let strongSelf = self else { return }
            strongSelf.fetchDataRequest = nil
            
            switch result {
            case .success(let response):
                if response.code == APIResponseCode.success, let flightSearchResponse = response.response {
                    onComplete?(true)
                    strongSelf.flights.append(contentsOf: flightSearchResponse.flights)
                    strongSelf.response = flightSearchResponse
                    strongSelf.delegate?.onFetchCompleted(with: .none)
                } else {
                    onComplete?(false)
                    strongSelf.delegate?.onFetchFailed(with: response.message)
                }
            case .failure(let error):
                onComplete?(false)
                if !error.isExplicitlyCancelledError {
                    strongSelf.delegate?.onFetchFailed(with: error.localizedDescription)
                }
            }
        }
    }
    
    private func calculateIndexPathsToReload(from newFlightCount: Int) -> [IndexPath] {
        let startIndex = flights.count - newFlightCount
        let endIndex = startIndex + newFlightCount
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}

