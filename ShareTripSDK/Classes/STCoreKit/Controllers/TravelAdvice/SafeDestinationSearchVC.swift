//
//  SafeDestinationSearchVC.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 10/11/2020.
//  Copyright © 2020 ShareTrip. All rights reserved.
//

import UIKit
import PKHUD
import FirebaseRemoteConfig

public class SafeDestinationSearchVC: UIViewController {

    @IBOutlet weak var travelAdviceTV: UITableView!
    private let row: [SearchDestinationCellInfo] = [.destination, .searchButton, .advice]
    private let searchResultRow: [SearchDestinationResultCellInfo] = [.destination, .searchButton, .travelAdvisory, .permissionInfo, .destinationDetails]

    private var isDetailsShown: Bool = false
    private var travelAdviceVM = TravelAdviceViewModel()
    private var countryName = "Select Country"
    private var countryCode = ""
    private var tappedCell = IndexPath()
    private var termsAndConditionText = ""

    private var analytics: AnalyticsManager = {
        //let mpe = MixpanelAnalyticsEngine()
        let fae = FirebaseAnalyticsEngine()
        let manager = AnalyticsManager([fae])
        return manager
    }()


    //MARK: - View controller Lifecycle's
    public override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        setupTV()
    }

    public override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
        travelAdviceTV.reloadData()
    }

    //MARK: - Utils
    private func initialSetup() {
        setupNavigationItems(withTitle: "Can I travel to")

        navigationItem.leftBarButtonItems = BackButton.createWithText("Back", color: UIColor.white, target: self, action: #selector(backButtonTapped(_:)))
        view.backgroundColor = .offWhite
    }

    @objc func backButtonTapped(_ sender: UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
    }

    private func fetchTravelAdviceData() {
        HUD.show(.progress)
        travelAdviceVM.loadTravelAdviceData(withCountryCode: countryCode) {
            [weak self] success, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.showMessage(error, type: .error, options: [.autoHide(true),.autoHideDelay(2.0), .hideOnTap(true)])
                }
            }
            DispatchQueue.main.async {
                HUD.hide()
                self?.isDetailsShown = success
                self?.travelAdviceTV.reloadData()
            }
        }
    }

    private func loadPromotionTextFromRemoteConfig(onCompletion: @escaping ()->Void) {
        let remoteConfig = RemoteConfig.remoteConfig()
        STAppManager.shared.setupRemoteConfigDefaults()
        remoteConfig.fetch { [weak self] (status, error) -> Void in
            if status == .success {
                remoteConfig.activate { (_, error) in
                    if let error = error {
                        STLog.error(error.localizedDescription)
                    }
                }
                if let tAndC = remoteConfig[Constants.RemoteConfigKey.travelAdvice_termAndConditions].stringValue {
                    self?.termsAndConditionText = tAndC
                }

            } else {
                STLog.error("Remote config error: \(error?.localizedDescription ?? "No error available.")")
            }
            onCompletion()
        }
    }

    //MARK: - IBActions
    private func cellInputButtonTapped(indexPath: IndexPath){
        self.tappedCell = indexPath
        let vc = LoadDefaultCountryVC.instantiate()
        vc.delegate = self
        self.navigationController!.pushViewController(vc, animated: true)
    }

    private func cellSearchButtonTapped(indexPath: IndexPath) {
        if countryCode == "" {
            self.showMessage("Please select a country", type: .error, options: [.autoHide(true),.autoHideDelay(2.0), .hideOnTap(true)])
        } else {
            fetchTravelAdviceData()
        }
    }

    private func cellShowMoreButtonTap(indexPath: IndexPath) {
        travelAdviceTV.reloadData()
    }

    private func cellTravelAdvisoryLevelButtontap(indexPath: IndexPath) {
        loadPromotionTextFromRemoteConfig {
            let webVC = WebViewController()
            webVC.sourceType = .htmlString
            webVC.htmlString = Helpers.generateHtml(content: self.termsAndConditionText)
            webVC.title = "Terms & Conditions"
            self.navigationController?.pushViewController(webVC, animated: true)
        }
    }
}

//MARK: - UITableView Delegate and Datasource
extension SafeDestinationSearchVC: UITableViewDelegate, UITableViewDataSource {
    private func setupTV(){
        travelAdviceTV.estimatedRowHeight = 44.0
        travelAdviceTV.tableFooterView = UIView()
        travelAdviceTV.separatorStyle = .none
        travelAdviceTV.addTopBackgroundView(viewColor: .clearBlue)
        travelAdviceTV.registerNibCell(SingleInputTitleCell.self)
        travelAdviceTV.registerCell(SingleButtonCell.self)
        travelAdviceTV.registerNibCell(PermissionInfoTVCell.self)
        travelAdviceTV.registerNibCell(TravelDetailsInfoTVCell.self)
        travelAdviceTV.registerNibCell(SharePostTVCell.self)
        travelAdviceTV.registerNibCell(TravelAdviceTVCell.self)
        travelAdviceTV.registerNibCell(TravelAdvisoryLevelTVCell.self)
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !isDetailsShown {
            return row.count
        }
        return searchResultRow.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if !isDetailsShown {
            let rowType = row[indexPath.row]
            switch rowType {
                case .destination:
                    let inputValue = self.countryName
                    let inputData = SingleInputTitleData(titleLabel: rowType.title, inputTypeImage: rowType.imageName, placeholder: rowType.placeholder, inputValue: inputValue)
                    let callBackClosure: ((IndexPath) -> Void) = { [weak self] (cellIndex) in
                        self?.cellInputButtonTapped(indexPath: cellIndex)
                    }

                    let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SingleInputTitleCell
                    cell.configure(indexPath: indexPath, singleInputData: inputData, callbackClosure:callBackClosure)
                    cell.selectionStyle = .none
                    cell.contentView.backgroundColor = UIColor.appPrimary
                    return cell
                case .searchButton:
                    let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SingleButtonCell
                    cell.configure(indexPath: indexPath, buttonTitle: "SEARCH", buttonType: .searchButton, enabled: true) {
                        [weak self] (cellIndex) in
                        self?.cellSearchButtonTapped(indexPath: cellIndex)
                    }
                    cell.selectionStyle = .none
                    cell.contentView.backgroundColor = UIColor.appPrimary
                    cell.contentView.roundBottomCorners(radius: 12.0, frame: UIScreen.main.bounds)
                    return cell
                case .advice:
                    let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as TravelAdviceTVCell
                    cell.selectionStyle = .none
                    return cell
            }
        } else {
            let rowType = searchResultRow[indexPath.row]
            switch rowType {
                case .destination:
                    let inputValue = self.countryName
                    let inputData = SingleInputTitleData(titleLabel: rowType.title, inputTypeImage: rowType.imageName, placeholder: rowType.placeholder, inputValue: inputValue)
                    let callBackClosure: ((IndexPath) -> Void) = { [weak self] (cellIndex) in
                        self?.cellInputButtonTapped(indexPath: cellIndex)
                    }

                    let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SingleInputTitleCell
                    cell.configure(indexPath: indexPath, singleInputData: inputData, callbackClosure:callBackClosure)
                    cell.selectionStyle = .none
                    cell.contentView.backgroundColor = UIColor.appPrimary
                    return cell
                case .searchButton:
                    let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SingleButtonCell
                    cell.configure(indexPath: indexPath, buttonTitle: "SEARCH", buttonType: .searchButton, enabled: true) {
                        [weak self] (cellIndex) in
                        self?.cellSearchButtonTapped(indexPath: cellIndex)
                    }
                    cell.selectionStyle = .none
                    cell.contentView.backgroundColor = UIColor.appPrimary
                    cell.contentView.roundBottomCorners(radius: 12.0, frame: UIScreen.main.bounds)
                    return cell
                case .travelAdvisory:
                    let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as TravelAdvisoryLevelTVCell
                    let callBackClosure: ((IndexPath) -> Void) = { [weak self] (cellIndex) in
                        self?.cellTravelAdvisoryLevelButtontap(indexPath: cellIndex)
                    }
                    cell.configure(indexPath: indexPath, callbackClosure:callBackClosure)
                    cell.selectionStyle = .none
                    return cell
                case .permissionInfo:
                    let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as PermissionInfoTVCell
                    cell.configureCell(indexPath: indexPath, travelAdviceVM: travelAdviceVM)
                    cell.selectionStyle = .none
                    return cell
                case .destinationDetails:
                    let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as TravelDetailsInfoTVCell
                    cell.configureCell(indexPath: indexPath, travelAdviceVM: travelAdviceVM) {  [weak self] (cellIndex) in
                        self?.cellShowMoreButtonTap(indexPath: cellIndex)
                    }
                    cell.selectionStyle = .none
                    return cell
            }
        }
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if !isDetailsShown {
            let rowType = row[indexPath.row]
            switch rowType {
                case .destination:
                    return 64.0
                case .searchButton:
                    return 88.0
                case .advice:
                    return UITableView.automaticDimension
            }
        } else {
            let rowType = searchResultRow[indexPath.row]
            switch rowType {
                case .travelAdvisory:
                    return 152.0
                case .destination:
                    return 64.0
                case .searchButton:
                    return 88.0
                case .permissionInfo:
                    return UITableView.automaticDimension
                case .destinationDetails:
                    return UITableView.automaticDimension
            }
        }

    }
}

//MARK: - SelectedCountryVCDelegate
extension SafeDestinationSearchVC: SelectedCountryVCDelegate {
    public func userSelectedCountry(selectedCountry: Country) {
        self.countryName = selectedCountry.name
        self.countryCode = selectedCountry.code
        if tappedCell.row == 0 {
            let indexPath = IndexPath(item: tappedCell.row, section: 0)
            travelAdviceTV.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}

//MARK: - Storyboard Extension
extension SafeDestinationSearchVC: StoryboardBased {
    public static var storyboardName: String {
        return "TravelAdvice"
    }
}



