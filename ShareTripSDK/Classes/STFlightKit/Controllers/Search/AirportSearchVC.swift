//
//  AirportSearchVC.swift
//  ShareTrip
//
//  Created by Mac on 9/4/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit
import Alamofire


//MARK: - Airport Search Delegate
protocol AirportSearchDelegate: AnyObject {
    func userDidSelectedAirport(_ airport: Airport, cellIndex: IndexPath)
}

class AirportSearchVC: UIViewController {
    
    @IBOutlet weak var searchBarContainerView: UIView!
    @IBOutlet weak private var placeSearchBar: SearchBar!
    @IBOutlet weak private var searchPlaceTableView: UITableView!
    
    //MARK: - Private properties
    private var lastSearchedKeyword: String?
    private var lastDataRequest: DataRequest?
    private var searchedAirports: [Airport] = []
    
    //MARK: - Public properties
    weak var delegate: AirportSearchDelegate?
    var cellIndex: IndexPath!
    
    //MARK:- ViewController's Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureAirportsData()
    }
    
    deinit {
        lastSearchedKeyword = nil
        lastDataRequest = nil
        STLog.info("AirportSearchVC: deinit")
    }
    
    // MARK: - SetupView
    private func setupView(){
        placeSearchBar.delegate = self
        placeSearchBar.returnKeyType = .done
        searchPlaceTableView.delegate = self
        searchPlaceTableView.dataSource = self
        searchBarContainerView.backgroundColor = .appPrimary

        searchPlaceTableView.registerNibCell(AirportCell.self)
        searchPlaceTableView.registerHeaderFooter(CustomHeaderView.self)
        searchPlaceTableView.tableFooterView = UIView()
        
        searchPlaceTableView.separatorStyle = .singleLine
        searchPlaceTableView.separatorInset = .zero
        
        let tapGesture = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    private func configureAirportsData() {
        let airports = STAppManager.shared.popularAirports
        
        if airports.count <= 0 {
            searchAirport()
        } else {
            searchedAirports = airports
        }
    }
    
    //MARK: - API Calls
    private func searchAirport(keyword: String = "top") {
        if lastSearchedKeyword == keyword { return }
        
        lastDataRequest?.cancel()
        lastSearchedKeyword = keyword
        
        lastDataRequest = FlightAPIClient().airportSearch(name: keyword) { [weak self] (result) in
            switch result {
            case .success(let response):
                guard let strongSelf = self else { return }
                
                switch response.code {
                case .success:
                    if let searchedCities = response.response {
                        strongSelf.searchedAirports = searchedCities
                        strongSelf.searchPlaceTableView.reloadData()
                    } else {
                        STLog.error("Error: \(response.code) -> \(response.message)")
                    }
                default:
                    break
                }
            case .failure(let error):
                STLog.error(error.localizedDescription)
            }
        }
    }
}

//MARK:- TableView DataSource, Delegate
extension AirportSearchVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedAirports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as AirportCell
        let airport = searchedAirports[indexPath.row]
        
        var airportLabel: String
        if let city = airport.city {
            airportLabel = city + ", " + airport.name
        } else {
            airportLabel = airport.name
        }
        
        cell.codeLabel.text = airport.iata
        cell.airportLabel.text = airportLabel
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = lastSearchedKeyword == nil ? "Popular Airports" : "Searched Airports"
        let font = UIFont.systemFont(ofSize: 14, weight: .medium)
        let header = tableView.dequeueReusableHeaderFooterView() as CustomHeaderView
        header.config(title: title, textFont: font, textColor: UIColor.charcoalGray)
        header.customLabel.addCharacterSpacing(kernValue: 1.88)
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let airport = searchedAirports[indexPath.row]
        delegate?.userDidSelectedAirport(airport, cellIndex: cellIndex)
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - UISerachBar Delegate
extension AirportSearchVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.returnKeyType = searchText.isReallyEmpty ? .done : .search
        searchBar.reloadInputViews()
        
        if searchText.count > 1 {
            searchAirport(keyword: searchText)
        } else if searchText.count == 0 {
            searchedAirports.removeAll()
            searchedAirports = STAppManager.shared.popularAirports
            lastSearchedKeyword = nil
            searchPlaceTableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, searchText.count > 0 {
            searchAirport(keyword: searchText)
        }
        searchBar.resignFirstResponder()
    }
}


