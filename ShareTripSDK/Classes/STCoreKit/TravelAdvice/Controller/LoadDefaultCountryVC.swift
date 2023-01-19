//
//  LoadDefaultCountryVC.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 15/11/2020.
//  Copyright © 2020 ShareTrip. All rights reserved.
//

import UIKit

public protocol SelectedCountryVCDelegate: AnyObject {
    func userSelectedCountry(selectedCountry: Country)
}

public class LoadDefaultCountryVC: UIViewController {
    @IBOutlet weak private var searchBar: SearchBar!
    @IBOutlet weak private var countryListTV: UITableView!

    private var countryList = [Country]()
    private var searchCountry = [Country]()
    private var searching = false
    weak var delegate: SelectedCountryVCDelegate?

    //MARK: - View Controller life cycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        setupTV()
    }

    public override func viewDidAppear(_ animated: Bool) {
        let attributes =  [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.7)]
        searchBar.searchField?.attributedPlaceholder = NSAttributedString(string: "Search Country", attributes: attributes)
        super.viewDidAppear(animated)
    }

    //MARK: - Utils
    private func initialSetup(){
        setupNavigationItems(withTitle: "Select Destination")
        searchBar.delegate = self
        searchBar.returnKeyType = .done
        countryList = STAppManager.getCountryList()
        checkCountryListLoaded()

    }

    private func checkCountryListLoaded() {
        if countryList.count == 0 {
            let alertVC = UIAlertController(title: "Warning!", message: "Unable to fetch country list right now!", preferredStyle: .alert)
            let okBtn = UIAlertAction(title: "Go Back", style: .destructive, handler: { [weak self] (action) in
                self?.navigationController?.popViewController(animated: true)
            })
            alertVC.addAction(okBtn)
            alertVC.modalPresentationStyle = .fullScreen
            present(alertVC, animated: true, completion: nil)
        }
    }
}

//MARK: - UITableView Delegate and Datasource
extension LoadDefaultCountryVC: UITableViewDelegate, UITableViewDataSource {
    private func setupTV(){
        countryListTV.delegate = self
        countryListTV.dataSource = self
        countryListTV.separatorStyle = .none
        countryListTV.backgroundColor = .offWhite
        countryListTV.registerNibCell(SearchCountryTVCell.self)

    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchCountry.count
        } else {
            return countryList.count
        }
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SearchCountryTVCell
        searching ? ( cell.configureCell(with: searchCountry[indexPath.row].name, "", and: indexPath.row)) : (cell.configureCell(with: countryList[indexPath.row].name, "", and: indexPath.row))
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searching ? ( delegate?.userSelectedCountry(selectedCountry: searchCountry[indexPath.row])) : ( delegate?.userSelectedCountry(selectedCountry: countryList[indexPath.row]))
        self.navigationController?.popViewController(animated: true)
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}

//MARK: - Searchbar Delegates
extension LoadDefaultCountryVC: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count >= 1 {
            searchCountry = countryList.filter({$0.name.prefix(searchText.count) == searchText})
            searching = true
        } else {
            searching =  false
        }
        countryListTV.reloadData()
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

//MARK: - Storyboard Extension
extension LoadDefaultCountryVC: StoryboardBased {
    public static var storyboardName: String {
        return "TravelAdvice"
    }
}
