//
//  FlightDetailsVC.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 30/11/2019.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit
import PKHUD

import FloatingPanel

class FlightDetailsVC: ViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var bottomSafeAreaView: UIView!
    private weak var popupView: PopupView?
    
    private var rows = [CellType]()
    private var firstTimeCheck = true
    
    private var baggageResponseType: BaggageResponseType = .unknown
    
    private var baggageViewModel: BaggageViewModel?
    private var paymentGatewaysViewModel: PaymentGatewaysViewModel!
    private var selectedGateway: PaymentGateway?
    
    var flightDetailsViewModel: FlightDetailsViewModel!
    weak var whitishNavController: WhitishNavigationController?
    
    private var couponViewModel: UseCouponViewModel?
    
    private let analytics: AnalyticsManager = {
        let fae = FirebaseAnalyticsEngine()
        let manager = AnalyticsManager([fae])
        return manager
    }()
    
    //MARK: - ViewController's Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPaymentGateways()
        handlePaymentGatewayResponse()
    
        setupView()
        handleFlightDetailsResponses()
        handleCouponViewCallbacks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        updatePayNowButtonStatus()
        setupRightNavBar()
        if firstTimeCheck {
            firstTimeCheck = false
            if !flightDetailsViewModel.isLoading.value {
                showFloatingPannel()
            }
        }
        
        setupDiscountOptionsView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updatePayNowButtonStatus()
    }
    
    //MARK:- Setup UI
    private func setupView() {
        rows.append(contentsOf: [.fare, .covidWarning, .tripcoin])
        rows.append(contentsOf: [CellType](repeating: .leg, count: flightDetailsViewModel.flightLegs.count))
        rows.append(contentsOf: [.seatAndBaggage])
        
        self.navigationItem.titleView = FlightNavTitle.flightNavLabel(
            flightRouteType: flightDetailsViewModel.routeType,
            firstText: flightDetailsViewModel.firstAirportIata,
            secondText: flightDetailsViewModel.lastAirportIata,
            font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        )
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        tableView.backgroundColor = .offWhite
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.registerNibCell(FareCardSingleLineCell.self)
        tableView.registerNibCell(TripCoinCardCell.self)
        tableView.registerNibCell(FlightLegCardCell.self)
        tableView.registerNibCell(SeatAndBagageInfoCardCell.self)
        tableView.registerNibCell(DiscountOptionsCell.self)
        tableView.registerNibCell(BaggageSelectionCell.self)
        tableView.registerNibCell(SingleLineInfoCardCell.self)
        tableView.registerNibCell(WarningMessageCell.self)
        
        setupFloatingPanel()
    }
    
    private func setupRows() {
        rows.append(contentsOf: [.discountOptions, .selectBaggage])
        rows.append(contentsOf: [CellType](repeating: .policy, count: FlightDetailInfoType.allCases.count))
        setupBaggages()
    }
    
    private func setupBaggages() {
        flightDetailsViewModel.fetchBaggageOptions(){ [weak self] success in
            if success {
                self?.baggageResponseType = .success
                self?.baggageViewModel = self?.flightDetailsViewModel.baggageViewModel
            } else {
                self?.baggageResponseType = .error
            }
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    private func handlePaymentGatewayResponse() {
        paymentGatewaysViewModel.callBack.didFetchPaymentGateways = {[weak self] paymentGateways in
            self?.selectedGateway = paymentGateways.first
            self?.flightDetailsViewModel.updateSTCharge(self?.selectedGateway?.charge ?? .zero)
            self?.flightPriceBreakdownVC?.relaodPriceTable(with: self?.flightDetailsViewModel.flightPriceTableData)
        }
    }
    
    private func handleFlightDetailsResponses() {
        // Fetch Flight Details
        flightDetailsViewModel.fetchFlightDetails()
        tableView.startActivityIndicator()
        
        flightDetailsViewModel.callback.didFetchFlightDetails = {[weak self] in
            self?.setupCouponViewModel()
            self?.setupDiscountOptionsView()
            self?.tableView.stopActivityIndicator()
            self?.tableView.reloadData()
        }
        
        flightDetailsViewModel.callback.didFailed = {[weak self] error in
            self?.tableView.stopActivityIndicator()
            self?.tableView.reloadData()
            self?.showMessage(error, type: .error)
        }
        
        // Load discount options
        flightDetailsViewModel.loadDiscountOptions() { [weak self] in
            self?.setupDiscountOptionsView()
            self?.showFloatingPannel()
        }
        
        flightDetailsViewModel.isLoading.bindAndFire { [weak self] loading in
            if loading {
                self?.tableView.startActivityIndicator()
            } else {
                self?.setupRows()
                self?.tableView.stopActivityIndicator()
            }
            self?.tableView.reloadData()
        }
    }
    
    private func setupCouponViewModel() {
        let useCouponViewModel = UseCouponViewModel(
            serviceType: .flight,
            availableCoupons: flightDetailsViewModel.promotionalCoupons
        )
        
        let flightCouponsExtraParams = FlightCouponsExtraParameters(
            searchId: flightDetailsViewModel.searchId,
            sequenceCode: flightDetailsViewModel.sequenceCode
        )
        
        useCouponViewModel.couponExtraParams = flightCouponsExtraParams.requestParams
        useCouponViewModel.baseFare = flightDetailsViewModel.flightPriceTableData.baseFare
        self.couponViewModel = useCouponViewModel
    }
    
    private func handleCouponViewCallbacks() {
        func performCouponUpdates() {
            let message = "Coupon Applied Successfully"
            showMessage(message, type: .success)
            flightDetailsViewModel.couponDiscountAmount = couponViewModel?.couponDiscount ?? 0.0
            flightDetailsViewModel.isCouponWithDiscount = couponViewModel?.isWithDiscount ?? false
            setupPaymentGateways()
            tableView.reloadData()
            reloadPriceBreakdown()
            updatePayNowButtonStatus()
        }
        
        useCouponView.callback.didTapApplyCoupon = {[] in
            HUD.show(.progress)
        }
        
        useCouponView.callback.didSuccessApplyCoupon = {[] in
            HUD.hide()
            performCouponUpdates()
        }
        
        useCouponView.callback.didFailedApplyCoupon = {[weak self] error in
            HUD.hide()
            self?.showMessage(error, type: .error)
            self?.updatePayNowButtonStatus()
            self?.reloadPriceBreakdown()
            self?.tableView.reloadData()
        }
        
        //For GPStar
        useCouponView.callback.needPhoneVerification = {[weak self] in
            HUD.hide()
            let title = UseCouponViewModel.gpstarAlertTitle
            let message = UseCouponViewModel.verifyPhoneMessage
            self?.showAlert(message: message, withTitle: title, handler: self?.initPhoneVerification)
        }
        
        useCouponView.callback.didTapVerifyButton = {[] in
            HUD.show(.progress)
        }
        
        useCouponView.callback.didVerifyPhoneNumber = {[weak self] in
            HUD.hide()
            let message = "Please verify OTP"
            self?.showMessage(message, type: .info)
            self?.reloadPriceBreakdown()
            self?.tableView.reloadData()
        }
        
        useCouponView.callback.didVerifyOTP = {[] in
            HUD.hide()
            performCouponUpdates()
        }
        
        useCouponView.callback.didFailedGPStar = {[weak self] error in
            HUD.hide()
            self?.showMessage(error, type: .error)
            self?.tableView.reloadData()
        }
        
        useCouponView.callback.needsReload = {[weak self] in
            self?.updatePayNowButtonStatus()
            self?.flightDetailsViewModel.couponDiscountAmount = .zero
            self?.reloadPriceBreakdown()
            self?.tableView.reloadData()
        }
    }
    
    //MARK: - IBAction
    private func initPhoneVerification(_ sender: UIAlertAction) {
        useCouponView.initPhoneVerification()
    }
    
    private func bookNowButtonAction() {
        if !STAppManager.shared.isUserLoggedIn {
            showLoginAlert()
            return
        }
        openFlightPassengerListVC()
    }
    
    private func setupPaymentGateways() {
        paymentGatewaysViewModel = PaymentGatewaysViewModel(.flight, flightDetailsViewModel.currency)
        paymentGatewaysViewModel.fetchPaymentGateways()
        filterPaymentGateway()
    }
    
    private func filterPaymentGateway() {
        switch flightDetailsViewModel.selectedDiscountOption {
        case .useCoupon:
            let couponGateways = couponViewModel?.selectedCouponGateways ?? []
            if couponGateways.count > 0 {
                paymentGatewaysViewModel.filterPaymentGateways(
                    filter: flightDetailsViewModel.paymentGateWayfilter(gatewayIds: couponGateways))
            } else {
                paymentGatewaysViewModel.filterPaymentGateways(filter: flightDetailsViewModel.paymentGateWayfilter())
            }
        default:
            paymentGatewaysViewModel.filterPaymentGateways(filter: flightDetailsViewModel.paymentGateWayfilter())
        }
    }
    private func setupRightNavBar() {
        if let user = STAppManager.shared.userAccount {
            navigationItem.rightBarButtonItem = TripCoinBarButtonItem.createWithText(user.totalPoints.withCommas())
        }
    }
    
    private let discountOptionView = DiscountOptionsContainer()
    private let useCouponView = UseCouponView.instantiate()
    
    private func setupDiscountOptionsView() {
        var discountOptionViews = [DiscountOptionCollapsibleView]()
        discountOptionView.clearView()
        
        for discountOption in flightDetailsViewModel.discountOptions {
            switch discountOption.type {
            case .earnTC:
                let earnTripcoinView = EarnTripcoinView.instantiate()
                earnTripcoinView.discountAmount = flightDetailsViewModel.earnTCDiscount
                earnTripcoinView.discountOptionTitle = discountOption.title
                earnTripcoinView.subTitle = discountOption.subtitle
                if flightDetailsViewModel.selectedDiscountOption == .earnTC {
                    flightPriceBreakdownVC?.selectedDiscountOption = .earnTC
                    earnTripcoinView.expand()
                } else {
                    earnTripcoinView.collapse()
                }
                discountOptionViews.append(earnTripcoinView)
                
            case .redeemTC:
                let redeemTripcoinView = RedeemTripcoinView.instantiate()
                redeemTripcoinView.redeemDelegate = self
                let userTripCoin = Double(STAppManager.shared.userAccount?.redeemablePoints ?? 0)
                let maxValue = min(userTripCoin, Double(flightDetailsViewModel.earnTC))
                let adjustedMaxValue = max(0, maxValue)
                redeemTripcoinView.configure(
                    minValue: 0, maxValue: adjustedMaxValue,
                    title: discountOption.title,
                    subtitle: discountOption.subtitle
                )
                if flightDetailsViewModel.selectedDiscountOption == .redeemTC {
                    flightPriceBreakdownVC?.selectedDiscountOption = .redeemTC
                    redeemTripcoinView.expand()
                } else {
                    redeemTripcoinView.collapse()
                }
                discountOptionViews.append(redeemTripcoinView)
                
            case .useCoupon:
                useCouponView.useCouponViewModel = couponViewModel
                useCouponView.titleText = discountOption.title
                useCouponView.subTitleText = discountOption.subtitle
                if flightDetailsViewModel.selectedDiscountOption == .useCoupon {
                    flightPriceBreakdownVC?.selectedDiscountOption = .useCoupon
                    useCouponView.expand()
                } else {
                    useCouponView.collapse()
                }
                discountOptionViews.append(useCouponView)
                
            case .unknown:
                break
            }
        }
        discountOptionView.discountOptionViews = discountOptionViews
        discountOptionView.delegate = self
    }
    
    private func updateRedeemTripcoinDiscountOptionsView(){
        if let redeemTripcoinView = (discountOptionView.discountOptionViews.filter { $0 is RedeemTripcoinView }).first as? RedeemTripcoinView {
            let userTripCoin = Double(STAppManager.shared.userAccount?.redeemablePoints ?? 0)
            let maxValue = min(userTripCoin, Double(flightDetailsViewModel.earnTC))
            let adjustedMaxValue = max(0, maxValue)
            redeemTripcoinView.updateSliderValues(minValue: 0, maxValue: adjustedMaxValue)
        }
    }
    
    private var floatingPanelVC: FloatingPanelController!
    private var flightPriceBreakdownVC: FlightPriceBreakdownVC?
    
    private func setupFloatingPanel() {
        floatingPanelVC = FloatingPanelController()
        floatingPanelVC.delegate = self
        let flightPriceInfoVC = FlightPriceBreakdownVC.instantiate()
        flightPriceInfoVC.buttonFunction = { [weak self] in
            self?.bookNowButtonAction()
        }
        
        let priceInfoTableData = flightDetailsViewModel.flightPriceTableData
        flightPriceInfoVC.viewModel = FlightPriceBreakdownViewModel(priceInfoTableData: priceInfoTableData)
        floatingPanelVC.set(contentViewController: flightPriceInfoVC)
        self.flightPriceBreakdownVC = flightPriceInfoVC
        
        floatingPanelVC.surfaceView.appearance.cornerRadius = 10.0
        floatingPanelVC.surfaceView.grabberHandleSize = CGSize(width: 72.0, height: 6.0)
        floatingPanelVC.track(scrollView: flightPriceInfoVC.pricaTableView)
    }
    
    private func showFloatingPannel(){
        floatingPanelVC.addPanel(toParent: self)
        floatingPanelVC.view.frame = self.view.bounds // MUST
        addChild(floatingPanelVC)
        flightPriceBreakdownVC?.setButtonStatus(enabled: false)
        
    }
    
    // Toggling for button status
    func updatePayNowButtonStatus() {
        flightPriceBreakdownVC?.bookingButton.setTitle("Pay Now", for: .normal)
        
        switch flightDetailsViewModel.selectedDiscountOption {
        case .useCoupon:
            flightPriceBreakdownVC?.setButtonStatus(enabled: false)
            
            if flightPriceBreakdownVC?.getTotalPayble() == 0 { return }
            
            guard let couponViewModel = useCouponView.useCouponViewModel else { return }
            
            guard couponViewModel.isCouponApplied else { return }
            
            guard couponViewModel.phoneVerificationRequired else {
                flightPriceBreakdownVC?.setButtonStatus(enabled: true)
                return
            }
            
            guard (couponViewModel.isGPStar && couponViewModel.isOTPVerified) else { return }
            
            flightPriceBreakdownVC?.setButtonStatus(enabled: true)
        default:
            flightPriceBreakdownVC?.setButtonStatus(enabled: true)
        }
    }
    
    //MARK: - Utils
    private func policyIndex(from indexPath: IndexPath) -> Int {
        let offset = rows.firstIndex(of: .policy)!
        return indexPath.row - offset
    }
    
    private func legIndex(from indexPath: IndexPath) -> Int {
        let offset = rows.firstIndex(of: .leg)!
        return indexPath.row - offset
    }
    
    private func legIndexForBaggage(for indexPath: IndexPath) -> Int? {
        if let offset = rows.firstIndex(of: .selectBaggage) {
            return indexPath.row - offset
        }
        return nil
    }
    
    private func flightLegDetailsVC(for flightLegIndex: Int) -> FlightLegDetailsVC {
        
        let vc = FlightLegDetailsVC(style: .plain)
        vc.flightSegmentCellDatas = flightDetailsViewModel.getFlightSegments(for: flightLegIndex)
        let leg = flightDetailsViewModel.flightLegs[flightLegIndex]
        vc.title = "\(leg.originName.code) - \(leg.destinationName.code)"
        vc.legId = flightLegIndex
        if flightLegIndex > 0 {
            let prevLeg = flightDetailsViewModel.flightLegs[flightLegIndex-1]
            vc.prevLegTitle = "\(prevLeg.originName.code) - \(prevLeg.destinationName.code)"
            vc.isFirstLeg = false
        } else {
            vc.isFirstLeg = true
        }
        if flightLegIndex < flightDetailsViewModel.flightLegs.count - 1{
            let nextLeg = flightDetailsViewModel.flightLegs[flightLegIndex+1]
            vc.nextLegTitle = "\(nextLeg.originName.code) - \(nextLeg.destinationName.code)"
            vc.isLastLeg = false
        } else {
            vc.isLastLeg = true
        }
        vc.delegate = self
        return vc
    }
    
    private func presentLegDetailsVC(for flightLegIndex: Int) {
        let navController = WhitishNavigationController(rootViewController: flightLegDetailsVC(for: flightLegIndex))
        whitishNavController = navController
        present(navController, animated: true, completion: nil)
    }
    
    private func openFlightPassengerListVC() {
        if let baggageVM = baggageViewModel {
            baggageVM.prepareBaggageData()
            if baggageVM.getBaggageSelectionStatus() {
                prepareBookingData()
                return
            }
            showMessage("Please select a baggage option", type: .error)
        } else {
            prepareBookingData()
        }
    }
    
    private func prepareBookingData() {
        var passengersInfos = [PassengerInfo]()
        var passengerAdditionalRequirementInfos = [PassengersAdditionalReq]()
        
        let passengers = flightDetailsViewModel.getPassengers()
        let additionalInfo = PassengersAdditionalReq()
        
        for index in 0..<passengers.count {
            let passengerInfo = PassengerInfo(
                flightDate: flightDetailsViewModel.flightDate,
                travellerType: passengers[index],
                luggageCode: baggageViewModel?.getTravelerWiseSelectedBaggageCodes(using: index) ?? []
            )
            
            passengersInfos.append(passengerInfo)
            passengerAdditionalRequirementInfos.append(additionalInfo)
        }
        
        let flightBookingData = FlightBookigData(
            isDomestic: flightDetailsViewModel.isDomestic,
            passengersInfos: passengersInfos,
            passengersAdditionalRequirementInfos: passengerAdditionalRequirementInfos,
            isAttachmentAvailable: flightDetailsViewModel.isAttachmentAvalilable
        )
        
        gotoPassengerListVC(flightBookingData: flightBookingData)
    }
    
    private func gotoPassengerListVC(flightBookingData: FlightBookigData) {
        let passengerListVC = FlightPassengerListVC.instantiate()
        passengerListVC.priceInfoTableData = flightDetailsViewModel.flightPriceTableData
        passengerListVC.useCouponView = useCouponView
        passengerListVC.availableDiscountOptions = flightDetailsViewModel.discountOptions
        passengerListVC.flightDetailsViewModel = flightDetailsViewModel
        passengerListVC.baggageViewModel = baggageViewModel
        passengerListVC.passengerListViewModel = FlightPassengerListViewModelDefault(
            flightBookingData: flightBookingData,
            isAttachmentAvailable: flightDetailsViewModel.isAttachmentAvalilable
        )
        navigationController?.pushViewController(passengerListVC, animated: true)
    }
    
    private func reloadPriceBreakdown() {
        flightPriceBreakdownVC?.relaodPriceTable(with: flightDetailsViewModel.flightPriceTableData)
    }
}

extension FlightDetailsVC: RedeemTripcoinViewDelegate {
    func didChangeRedeemAmount(dicount: Double) {
        flightDetailsViewModel.redeemDiscountAmount = dicount
        reloadPriceBreakdown()
    }
}

//MARK: - FlightDetailsVC Extension
extension FlightDetailsVC {
    private enum CellType {
        case fare, tripcoin, leg, seatAndBaggage, discountOptions, policy, covidWarning, selectBaggage
    }
}

//MARK: - UITableView Delegate & Datasource
extension FlightDetailsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flightDetailsViewModel.isLoading.value ? 0 : rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch rows[indexPath.row] {
        case .fare:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as FareCardSingleLineCell
            cell.configure(
                currency: flightDetailsViewModel.currency,
                orginPrice: flightDetailsViewModel.originalPrice,
                discountPrice: flightDetailsViewModel.discountPrice,
                discount: flightDetailsViewModel.discount,
                refundable: flightDetailsViewModel.refundpolicyText
            )
            return cell
            
        case . covidWarning:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as WarningMessageCell
            cell.configure(with: flightDetailsViewModel.covidWarningMsg)
            cell.selectionStyle = .none
            return cell
            
        case .tripcoin:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as TripCoinCardCell
            cell.configure(earnedTripCoin: flightDetailsViewModel.earnTC, redeemedTripCoin: flightDetailsViewModel.redeemTC)
            return cell
            
        case .leg:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as FlightLegCardCell
            let leg = flightDetailsViewModel.flightLegs[legIndex(from: indexPath)]
            cell.configure(with: leg, hasHiddenStoppage: leg.hiddenStops)
            return cell
            
        case .seatAndBaggage:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SeatAndBagageInfoCardCell
            cell.configure(availableSeats: flightDetailsViewModel.seatsCount, weightStr: flightDetailsViewModel.waight)
            return cell
            
        case .selectBaggage:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as BaggageSelectionCell
            cell.configure(
                viewModel: baggageViewModel,
                flightViewModel: flightDetailsViewModel,
                baggageResponseType: self.baggageResponseType,
                indexPath: indexPath,
                delegate: self
            )
            return cell
            
        case .discountOptions:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as DiscountOptionsCell
            cell.configure(discountOptionsView: discountOptionView)
            cell.callbackClosure = { [weak self] in
                self?.presentLoginView()
            }
            return cell
            
        case .policy:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SingleLineInfoCardCell
            let flightDetailInfo = FlightDetailInfoType.allCases[policyIndex(from: indexPath)]
            cell.configure(title: flightDetailInfo.title)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = rows[indexPath.row]
        switch cellType {
        case .leg:
            let flightLegIndex = legIndex(from: indexPath)
            presentLegDetailsVC(for: flightLegIndex)
            
        case .policy:
            let flightDetailInfoType = FlightDetailInfoType.allCases[policyIndex(from: indexPath)]
            if flightDetailInfoType == .refundPolicy {
                analytics.log(FlightEvent.clickOnRefundPolicy())
            } else if flightDetailInfoType == .bagageInfo {
                analytics.log(FlightEvent.clickOnBaggageInfo())
            } else if flightDetailInfoType == .fareDetail {
                analytics.log(FlightEvent.clickOnAirFareRules())
            }
            let flightInfoProvider = FlightInfoProvider(
                searchId: flightDetailsViewModel.searchId,
                sequenceCode: flightDetailsViewModel.sequenceCode,
                flightDetailInfoType: flightDetailInfoType
            )
            
            let vc = FareRuleAndPolicyVC.instantiate()
            vc.setFlightInfo(flightInfoProvider: flightInfoProvider)
            navigationController?.pushViewController(vc, animated: true)
            
        default:
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 150
    }
}

//MARK: - Baggage Delegate
extension FlightDetailsVC: BaggageSelectionCellDelegate {
    func collapseRoute(indexPath: IndexPath?) {
        guard let index = indexPath else { return }
        tableView.beginUpdates()
        tableView.reloadRows(at: [index], with: .automatic)
        tableView.endUpdates()
    }
    
    func baggageSelectionChanged() {
        flightDetailsViewModel.updateBaggagePrice(baggageViewModel?.getTotalPrice() ?? 0.0)
        reloadPriceBreakdown()
    }
}

//MARK: - Disocunt Option Delegate
extension FlightDetailsVC: DiscountOptionViewDelegate {
    func selectedOptionChanged(_ selectedOptionView: DiscountOptionCollapsibleView) {
        flightDetailsViewModel.selectedDiscountOption = selectedOptionView.discountOptionType
        flightPriceBreakdownVC?.selectedDiscountOption = selectedOptionView.discountOptionType
        tableView.reloadData()
        updatePayNowButtonStatus()
        reloadPriceBreakdown()
        
        // Analytics
        if selectedOptionView.discountOptionType == .redeemTC {
            analytics.log(FlightEvent.clickOnRedeemTripcoin())
        }
    }
}

//MARK: - Floating Panel Delegate
extension FlightDetailsVC: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
        return CustomFloatingLayout()
    }
    
    func floatingPanelDidRemove(_ vc: FloatingPanel.FloatingPanelController){
        STLog.info("floatingPanelDidEndRemove")
    }
}

//MARK: - Flight DetailsVC Delegate
extension FlightDetailsVC: FlightLegDetailsVCDelegate {
    func showNextLeg(legId: Int) {
        let flightLegIndex = legId + 1
        whitishNavController?.pushViewController(flightLegDetailsVC(for: flightLegIndex), animated: true)
    }
    
    func showPrevLeg(legId: Int) {
        guard let navController = whitishNavController else { return }
        if navController.viewControllers.count > 1 {
            whitishNavController?.popViewController(animated: true)
        } else {
            let flightLegIndex = legId - 1
            navController.setViewControllers([flightLegDetailsVC(for: flightLegIndex)], animated: false)
        }
    }
}

//MARK: - Login Helper
extension FlightDetailsVC: MainEntryVCDelegate {
    
    func loginSuccessful() {
        tableView.startActivityIndicator()
        STAppManager.shared.getUserInfo { [weak self] response in
            self?.tableView.stopActivityIndicator()
            if response != nil {
                if let index = self?.rows.firstIndex(of: .discountOptions) {
                    self?.updateRedeemTripcoinDiscountOptionsView()
                    let indexPath = IndexPath(row: index, section: 0)
                    self?.tableView.reloadRows(at: [indexPath], with: .none)
                    self?.setupRightNavBar()
                }
            } else {
                self?.showMessage("User info isn't found", type: .error)
            }
        }
    }
    
    func loginUnsuccessful() {
        showMessage("Login Unsuccessful. Try Again!", type: .error)
    }
    
    private func presentLoginView() {
        let mainEntryVC = AuthVC.instantiate()
        mainEntryVC.delegate = self
        self.present(mainEntryVC, animated: true, completion: nil)
    }
    
    private func showLoginAlert() {
        let viewData = PopupViewData(
            title: "Dear Guest User",
            subtitle: "Please log in or sign up on the app to avail the flight services",
            buttonTitle: "LOGIN",
            imageName: "flight-mono"
        )
        let popupView = PopupView(frame: UIScreen.main.bounds, viewData: viewData) { [weak self] (loginButtonTapped) in
            self?.popupView?.removeFromSuperview()
            self?.popupView = nil
            if loginButtonTapped {
                self?.presentLoginView()
            }
        }
        popupView.imageView.tintColor = UIColor.appPrimaryDark
        view.addSubview(popupView)
        if let window = UIApplication.shared.windows.first(where: { (window) -> Bool in window.isKeyWindow}) {
            window.addSubview(popupView)
        }
        self.popupView = popupView
    }
}

//MARK: - Storyboard Extension
extension FlightDetailsVC: StoryboardBased {
    static var storyboardName: String {
        return "Flight"
    }
    
    enum BaggageResponseType {
        case success
        case error
        case unknown
    }
}
