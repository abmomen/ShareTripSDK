//
//  FlightPassengerListVC.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 16/10/2019.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit


protocol FlightPassengerListCoordinatorDelegate: AnyObject {
    func onSelectPassenger(at index: Int)
    func continueToBooking()
}

class FlightPassengerListVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var continueButton: UIButton!
    
    // MARK: - Dependencies
    var useCouponView: UseCouponView!
    var baggageViewModel: BaggageViewModel?
    var flightDetailsViewModel: FlightDetailsViewModel!
    var passengerListViewModel: FlightPassengerListViewModel!

    var priceInfoTableData: PriceInfoTableData!
    var availableDiscountOptions = [DiscountOption]()    
    
    // MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presentPassengerInfoInput(forPassengerAt: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setContinueButtonStatus()
        tableView.reloadData()
    }
    
    //MARK: - Utils
    private func setupUI() {
        title = "Checkout"
        tableView.tableFooterView = UIView()
        continueButton.backgroundColor = .appPrimary
        tableView.registerConfigurableCellDataContainer(SingleInfoCell.self)
    }
    
    private func setContinueButtonStatus(){
        if let enabled = passengerListViewModel?.isSubmittable {
            continueButton.isEnabled = enabled
            continueButton.alpha = enabled ? 1.0 : 0.6
        }
    }
    
    private func passengerInfoInptTitle(forPassengerAt index: Int) -> String {
        let adultCount = passengerListViewModel.flightBookingData.passengersInfos.filter { $0.travellerType == .adult }.count
        let childCount = passengerListViewModel.flightBookingData.passengersInfos.filter { $0.travellerType == .child }.count
        
        var title = ""
        switch passengerListViewModel.flightBookingData.passengersInfos[index].travellerType {
        case .adult:
            title = "Adult \(index + 1)"
        case .child:
            title = "Child \(index - adultCount + 1)"
        case .infant:
            title = "Infant \(index - adultCount - childCount + 1)"
        }
        
        return title
    }
    
    private var passengerInfoPresentedModally = false
    
    private var isSaudiAirlines: Bool {
        for flightLeg in flightDetailsViewModel.flightLegs {
            if flightLeg.airlinesCode.lowercased() == "sv" {
                return true
            }
        }
        return false
    }
    
    private func presentPassengerInfoInput(forPassengerAt index: Int) {
        let flightBookingData = self.passengerListViewModel.flightBookingData
        let viewModel = FlightPassengerInfoViewModel(
            passengerInfo: flightBookingData.passengersInfos[index],
            accountService: AccountServiceDefault(),
            isDomesticFlight: flightBookingData.isDomestic,
            passengerIndex: index,
            attachment: flightDetailsViewModel.isAttachmentAvalilable,
            isSoudiAirline: isSaudiAirlines,
            departureDate: flightDetailsViewModel.departureDate
        )
        
        let baggageList = baggageViewModel?.getbaggegesCode(using: index) ?? []
        viewModel.passengerInfo.luggageCode = baggageList
        
        let vc = FlightPassengerInfoVC()
        vc.viewModel = viewModel
        vc.title = passengerInfoInptTitle(forPassengerAt: index)
        vc.attachment = flightDetailsViewModel.isAttachmentAvalilable
        vc.delegate = self
        viewModel.viewDelegate = vc
        
        let navController = NavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true)
        passengerInfoPresentedModally = true
    }
    
    private func showPassengerInfoInput(forPassengerAt index: Int) {
        let flightBookingData = passengerListViewModel.flightBookingData
        let passengerInfoViewModel = FlightPassengerInfoViewModel(
            passengerInfo: flightBookingData.passengersInfos[index],
            accountService: AccountServiceDefault(),
            isDomesticFlight: flightBookingData.isDomestic,
            passengerIndex: index,
            attachment: flightDetailsViewModel.isAttachmentAvalilable,
            isSoudiAirline: isSaudiAirlines,
            departureDate: flightDetailsViewModel.departureDate
        )
        
        let baggageList = baggageViewModel?.getbaggegesCode(using: index) ?? []
        passengerListViewModel.flightBookingData.passengersInfos[index].luggageCode = baggageList
        
        let vc = FlightPassengerInfoVC()
        vc.viewModel = passengerInfoViewModel
        vc.title = passengerInfoInptTitle(forPassengerAt: index)
        vc.delegate = self
        passengerInfoViewModel.viewDelegate = vc
        
        navigationController?.pushViewController(vc, animated: true)
        passengerInfoPresentedModally = false
    }
    
    deinit {
        STLog.info("\(String(describing: self)) deinit")
    }
    
    // MARK: - IBActions
    @IBAction func continueButtonTapped(_ sender: Any) {
        let flightVerifyInfoVC = FlightVerifyInfoVC(flightBookingData: passengerListViewModel.flightBookingData)
        flightVerifyInfoVC.priceInfoTableData = priceInfoTableData
        flightVerifyInfoVC.totalDiscount = priceInfoTableData.discount
        flightVerifyInfoVC.flightDetailsViewModel = flightDetailsViewModel
        flightVerifyInfoVC.availableDiscountOptions = availableDiscountOptions
        flightVerifyInfoVC.useCouponView = useCouponView
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(flightVerifyInfoVC, animated: true)
    }
}
//MARK: - UITableView Datasource
extension FlightPassengerListVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return passengerListViewModel?.numberOfSection ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passengerListViewModel?.numberOfRows(in: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let rowViewModel = passengerListViewModel?.dataForRow(at: indexPath),
              let cell = tableView.dequeueReusableCell(withIdentifier: type(of: rowViewModel).reuseableIDForContainer, for: indexPath) as? ConfigurableTableViewCell else {
                  return tableView.dequeueReusableCell(forIndexPath: indexPath)
              }
        
        cell.configure(viewModel: rowViewModel)
        
        return cell
    }
}

//MARK: - UITableView Delegate
extension FlightPassengerListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showPassengerInfoInput(forPassengerAt: indexPath.row)
    }
}

//MARK: - Flight Passenger InfoVC Delegate
extension FlightPassengerListVC: FlightPassengerInfoVCDelegate {
    func passengerInfoFilled(viewController: FlightPassengerInfoVC, passengerInfo: PassengerInfo, additionalReq: PassengersAdditionalReq, for index: Int) {
        passengerListViewModel.flightBookingData.passengersInfos[index] = passengerInfo
        passengerListViewModel.flightBookingData.passengersAdditionalRequirementInfos[index] = additionalReq
        
        if passengerInfoPresentedModally {
            viewController.dismiss(animated: false, completion: { [weak self] in
                guard let strongSelf = self else { return }
                if index + 1 < strongSelf.passengerListViewModel.flightBookingData.passengersInfos.count {
                    strongSelf.presentPassengerInfoInput(forPassengerAt: index + 1)
                }
            })
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func passengerInfoInputDidFinish(viewController: FlightPassengerInfoVC) {
        if passengerInfoPresentedModally {
            viewController.dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}

//MARK: - StoryBoard Extension
extension FlightPassengerListVC: StoryboardBased {
    static var storyboardName: String {
        return "Flight"
    }
}
