//
//  FlightSummaryVC.swift
//  ShareTrip
//
//  Created by Mac on 7/11/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit
import FloatingPanel
import PKHUD


class FlightSummaryVC: UIViewController {
    @IBOutlet weak var legViewTitleLabel: UILabel!
    @IBOutlet weak var legViewDateLabel: UILabel!
    @IBOutlet weak var legViewPersonLabel: UILabel!
    @IBOutlet weak var legViewContainer: UIStackView!
    @IBOutlet weak var legViewArrow: UIImageView!
    @IBOutlet weak var discountViewHeaderLabel: UILabel!
    @IBOutlet weak var discountHeaderLabelContainter: UIStackView!
    @IBOutlet weak var discountViewContainer: UIStackView!
    @IBOutlet weak var discountViewArrow: UIImageView!
    @IBOutlet weak var paymentGatewayViewHolder: UIStackView!
    
    //Terms and conditions
    @IBOutlet weak var checkbox: GDCheckbox!
    @IBOutlet weak var termsAndConditionsLabel: UILabel!
    
    //IconImageViews
    @IBOutlet weak var planeRightImageView: UIImageView!
    @IBOutlet weak var discountImageView: UIImageView!
    
    
    private var discountOptionViews = [DiscountOptionCollapsibleView]()
    
    // MARK: - Private Properties
    private var floatingPanelVC: FloatingPanelController!
    private var flightPriceInfoVC: FlightPriceBreakdownVC!
    private var discountOptionView: DiscountOptionsContainer!
    private var earnTripcoinView: EarnTripcoinView!
    private var redeemTripcoinView: RedeemTripcoinView!
    private var paymentGatewaysView: PaymentGatewaysView!
    private var selectedGateway: PaymentGateway?
    private var selectedGatewaySeries: GatewaySeries?
    private var defaultSelectedGateway: PaymentGateway?
    private var allPaymentGateways: [PaymentGateway]?
    
    private weak var popupView: USDPaymentPopupView?
    
    private var isUSDPayment = false
    private var isCheckboxChecked = false
    
    // MARK: - Dependency
    var useCouponView: UseCouponView!
    var travellers = [PassengerInfo]()
    var flightDetailsViewModel: FlightDetailsViewModel!
    var discountOptions = [DiscountOption]()
    var priceInfoTableData = PriceInfoTableData()
    var passengerAdditionalRequirementInfos = [PassengersAdditionalReq]()
    
    // MARK: - Analytics Engine
    private let analytics: AnalyticsManager = {
        let fae = FirebaseAnalyticsEngine()
        let manager = AnalyticsManager([fae])
        return manager
    }()
    
    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
        handleUseCouponViewCallbacks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showFloatingPannel()
    }
    
    //check toggling while start
    override func viewDidAppear(_ animated: Bool) {
        updatePayNowButtonStatus()
    }
    
    // MARK: - IBActions
    @IBAction func checkboxValueChanged(_ sender: GDCheckbox) {
        isCheckboxChecked = sender.isOn
    }
    
    @IBAction func onFlightLegViewTapped(_ sender: Any) {
        toggleLegView()
    }
    
    @IBAction func onDiscountViewTapped(_ sender: Any) {
        discountViewContainer.isHidden.toggle()
        toggleDiscountView()
    }
    
    // MARK: - SetupUI
    private func setupScene() {
        setupLegViews()
        setupFloatingPanel()
        setupDiscountOptions()
        setupPaymentGateways()
        setupCheckbox()
        setupTermsAndConditons()
        updatePriceTableView()
        analytics.log(FlightEvent.initalCheckoutFlight())
        setupNavigationItems(withTitle: "Booking Summary")
        
        planeRightImageView.image = UIImage(named: "plane-right")
        discountImageView.image = UIImage(named: "discount-mono")
    }
    
    private func setupCheckbox() {
        checkbox.checkColor = .white
        checkbox.checkWidth = 3.0
        checkbox.isSquare = false
        checkbox.isCircular = false
        checkbox.isRadiobox = false
        checkbox.shouldAnimate = true
        checkbox.containerWidth = 2.0
        checkbox.shouldFillContainer = true
        checkbox.isOn = isCheckboxChecked
        checkbox.containerColor = UIColor.blueGray
        checkbox.containerFillColor = UIColor.appPrimary
    }
    
    //MARK: - View toggling
    private func toggleLegView() {
        legViewContainer.isHidden = !legViewContainer.isHidden
        if legViewContainer.isHidden {
            legViewArrow.image = UIImage(named: "arrow-down-mono")
        } else {
            legViewArrow.image = UIImage(named: "arrow-up-mono")
        }
    }
    
    private func toggleDiscountView() {
        discountHeaderLabelContainter.isHidden = discountViewContainer.isHidden
        discountViewHeaderLabel.isHidden = !discountViewContainer.isHidden
        if discountViewContainer.isHidden {
            discountViewArrow.image = UIImage(named: "arrow-down-mono")
            discountViewHeaderLabel.text = flightDetailsViewModel.selectedDiscountOption.title
        } else {
            discountViewArrow.image = UIImage(named: "arrow-up-mono")
            discountViewHeaderLabel.text = ""
        }
    }
    
    private func handleUseCouponViewCallbacks() {
        func performCouponUpdates() {
            let message = "Coupon Applied Successfully"
            showMessage(message, type: .success)
            updatePriceTableView()
            updatePayNowButtonStatus()
            filterPaymentGateway()
            setupPaymentGateways()
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
            self?.updatePriceTableView()
            self?.updatePayNowButtonStatus()
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
            self?.updatePriceTableView()
        }
        
        useCouponView.callback.didVerifyOTP = {[] in
            HUD.hide()
            performCouponUpdates()
        }
        
        useCouponView.callback.didFailedGPStar = {[weak self] error in
            HUD.hide()
            self?.showMessage(error, type: .error)
        }
        
        useCouponView.callback.needsReload = {[weak self] in
            self?.updatePayNowButtonStatus()
        }
    }
    
    //MARK: - IBAction
    private func initPhoneVerification(_ sender: UIAlertAction) {
        useCouponView.initPhoneVerification()
    }
    
    //MARK: - Handle price change
    private func reloadPriceInfoTable(with priceBreakDown: FlightPriceBreakdown, discount: Double) {
        var rowDatas =  [PriceInfoFareCellData]()
        for detail in priceBreakDown.details {
            if detail.numberPaxes > 0 {
                let title = "Traveler: \(detail.type.rawValue.capitalized) * \(detail.numberPaxes)"
                let fareTitle = "Base Fare * \(detail.numberPaxes)"
                let taxTitle = "Taxes & Fees * \(detail.numberPaxes)"
                let baseFare =  detail.baseFare * Double(detail.numberPaxes)
                let tax = detail.tax * Double(detail.numberPaxes)
                let cellData = PriceInfoFareCellData(title: title, fareTitle: fareTitle, fareAmount: baseFare, taxTitle: taxTitle, taxAmount: tax)
                rowDatas.append(cellData)
            }
        }
        priceInfoTableData = PriceInfoTableData(
            totalPrice: priceBreakDown.originPrice,
            discount: discount,
            rowDatas: rowDatas,
            stCharge: selectedGateway?.charge ?? 0.0
        )
        flightPriceInfoVC.relaodPriceTable(with: priceInfoTableData)
    }
    
    private func handlePriceChange(revalidateResponse: FlightRevalidationResponse) {
        
        flightDetailsViewModel.revalidateResponse = revalidateResponse
        var selectedOptionsDiscount: Double = 0.0
        switch flightDetailsViewModel.selectedDiscountOption {
        case .earnTC:
            selectedOptionsDiscount = flightDetailsViewModel.earnTCDiscount
        case .redeemTC:
            selectedOptionsDiscount = flightDetailsViewModel.redeemDiscountAmount
        case .useCoupon:
            selectedOptionsDiscount = useCouponView.useCouponViewModel?.couponDiscount ?? 0.0
        case .unknown:
            selectedOptionsDiscount = 0
        }
        
        let prevTotal = priceInfoTableData.totalPrice
        let prevDiscount = priceInfoTableData.discount
        let newTotal = flightDetailsViewModel.priceBreakdown.originPrice
        let newDiscount = selectedOptionsDiscount
        let prevPayable = prevTotal - prevDiscount
        let newPayable = newTotal - newDiscount
        showPriceChangePopup(prevPrice: prevPayable, newPrice: newPayable)
        reloadPriceInfoTable(with: flightDetailsViewModel.priceBreakdown, discount: newDiscount)
    }
    
    //MARK: - Utils
    private func continueButtontapped() {
        guard let couponViewModel = useCouponView.useCouponViewModel else {
            return
        }
        
        if flightDetailsViewModel.selectedDiscountOption == .useCoupon && !couponViewModel.isCouponApplied {
            let message = "Please apply a coupon or use a diffrent discount option"
            let options: [GSMessageOption] = [.textNumberOfLines(2), .autoHide(true), .hideOnTap(true), .autoHideDelay(3)]
            self.showMessage(message, type: .error, options: options)
            return
        }
        
        if isCheckboxChecked {
            isUSDPayment ? showPopupView() : revalidateFlightPriceAndBookFlight()
        } else {
            let message = "Please agree to the T&C and Privacy Policy"
            self.showMessage(message, type: .error)
        }
    }
    
    private func showFlightSearchAlert(with message: String) {
        let alertVC = UIAlertController(title: "Search flight again", message: message, preferredStyle: .alert)
        let searchBtn = UIAlertAction(title: "Search flight", style: .destructive, handler: { [weak self] (action) in
            self?.navigationController?.popToViewController(ofClass: FlightSearchVC.self)
        })
        alertVC.addAction(searchBtn)
        present(alertVC, animated: true, completion: nil)
    }
    
    private func showPopupView() {
        let totalFareAfterDiscount = (priceInfoTableData.totalPrice + (priceInfoTableData.baggagePrice) + (priceInfoTableData.covid19TestPrice)) - priceInfoTableData.discount
        let totalFareInUSD = (totalFareAfterDiscount / (selectedGateway?.currency.conversion.rate ?? 1)).withCommas()
        let viewData = USDPaymentPopupViewData(
            imageName: "payment-USD-mono",
            title: "The payment will be charged in USD ($)",
            subtitle: "Tap on CONTINUE to processed with the payment",
            moneyInUSD: "\(totalFareInUSD)",
            buttonTitle: "CONTINUE"
        )
        
        let popupView = USDPaymentPopupView(frame: UIScreen.main.bounds, viewData: viewData) { [weak self] (continueButtonTapped) in
            self?.popupView?.removeFromSuperview()
            self?.popupView = nil
            if continueButtonTapped {
                self?.revalidateFlightPriceAndBookFlight()
            }
        }
        
        popupView.imageView.tintColor = UIColor.appPrimaryDark
        view.addSubview(popupView)
        if let window = UIApplication.shared.windows.first(where: { (window) -> Bool in window.isKeyWindow}) {
            window.addSubview(popupView)
        }
        self.popupView = popupView
    }
    
    private func checkAnotherFlight() {
        guard let viewControllers = navigationController?.viewControllers else { return }
        guard let flightListVC = viewControllers
            .filter({ $0 is FlightListVC })
            .first  as? FlightListVC else { return }
        
        flightListVC.reloadData()
        navigationController?.popToViewController(flightListVC, animated: true)
    }
    
    private weak var priceChangeView: UIView?
    private func showPriceChangePopup(prevPrice: Double, newPrice: Double) {
        let popupView = PriceChangeView.instantiate()
        priceChangeView = popupView
        
        let priceChangeViewModel = PriceChangeView.ViewModel(previousPrice: prevPrice, updatedPrice: newPrice)
        popupView.configure(with: priceChangeViewModel)
        
        popupView.checkAnotherFlightCallback = { [weak self] in
            self?.priceChangeView?.removeFromSuperview()
            self?.navigationItem.setHidesBackButton(false, animated: false)
            self?.checkAnotherFlight()
        }
        
        popupView.continueButtonCallBack = { [weak self] in
            self?.priceChangeView?.removeFromSuperview()
            self?.navigationItem.setHidesBackButton(false, animated: false)
            self?.postFlightBooking()
        }
        popupView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(popupView)
        
        let constraints = [
            popupView.topAnchor.constraint(equalTo: view.topAnchor),
            popupView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            popupView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            popupView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        navigationItem.setHidesBackButton(true, animated: false)
        NSLayoutConstraint.activate(constraints)
    }
    
    private func showFloatingPannel() {
        floatingPanelVC.addPanel(toParent: self)
        floatingPanelVC.view.frame = self.view.bounds
        addChild(floatingPanelVC)
        
        flightPriceInfoVC.relaodPriceTable(with: priceInfoTableData)
        flightPriceInfoVC.setButtonStatus(enabled: false)
    }
    
    private func setContinueButtonStatus() {
        guard let gateway = selectedGateway else {
            flightPriceInfoVC.setButtonStatus(enabled: false)
            return
        }
        
        if gateway.series.count > 0 {
            flightPriceInfoVC.setButtonStatus(enabled: selectedGatewaySeries != nil)
        } else {
            flightPriceInfoVC.setButtonStatus(enabled: true)
        }
    }
    
    // Toggling for button status
    func updatePayNowButtonStatus() {
        flightPriceInfoVC.bookingButton.setTitle("Pay Now", for: .normal)
        
        switch flightDetailsViewModel.selectedDiscountOption {
        case .useCoupon:
            if flightPriceInfoVC.getTotalPayble() == 0 {
                flightPriceInfoVC.setButtonStatus(enabled: false)
                return
            }
            
            //Added Checks for gpstar verification
            guard let couponViewModel = useCouponView.useCouponViewModel else {
                flightPriceInfoVC.setButtonStatus(enabled: false)
                return
            }
            
            guard couponViewModel.isCouponApplied else {
                flightPriceInfoVC.setButtonStatus(enabled: false)
                return
            }
            
            guard couponViewModel.phoneVerificationRequired else {
                setContinueButtonStatus()
                return
            }
            
            guard (couponViewModel.isGPStar && couponViewModel.isOTPVerified) else {
                flightPriceInfoVC.setButtonStatus(enabled: false)
                return
            }
            //Check ends
            
            setContinueButtonStatus()
        default:
            setContinueButtonStatus()
        }
    }
}

//MARK: - API calls
extension FlightSummaryVC {
    fileprivate func revalidateFlightPriceAndBookFlight() {
        let flightData = flightDetailsViewModel.flightRequiedData
        let req = FlightRevalidationRequest(
            searchId: flightData.searchId,
            sequenceCode: flightData.sequenceCode,
            sessionId: flightData.sessionId
        )
        HUD.show(.progress)
        FlightAPIClient().revalidateFlightPrice(request: req) {
            [weak self] result in
            HUD.hide()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if let revalidateResponse = response.response {
                    if response.code == .FLIGHT_PRICE_CHANGE || response.code == .FLIGHT_ITINERARY_CHANGE{
                        self.handlePriceChange(revalidateResponse: revalidateResponse)
                    } else if response.code == .FLIGHT_RE_ITINERARY_CHANGE || response.code == .FLIGHT_RE_VALIDATION_CHANGE{
                        self.showFlightSearchAlert(with: response.message)
                    }else {
                        self.postFlightBooking()
                    }
                }
            case .failure(let error):
                if let error = error.errorDescription {
                    STLog.error(error)
                    self.showMessage(error, type: .error)
                }
            }
        }
    }
    
    private func postFlightBooking() {
        
        analytics.log(FlightEvent.bookingButtonTapped())
        
        let parameters = createParametersForAPIRequest()
        var dictionary = [String:Any]()
        parameters.forEach { // create dictionary from array of tuples
            dictionary[$0.0] = $0.1
        }
        
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: [])
        
        guard let bodyData = data else {
            self.showAlert(message: "Something went wrong. Try again later", withTitle: "Error")
            return
        }
        
        HUD.show(.progress)
        FlightAPIClient().bookFlight(bodyData: bodyData) { [weak self] (result) in
            HUD.hide(animated: false)
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let response):
                if response.code == APIResponseCode.success {
                    DispatchQueue.main.async {
                        if let responseURL = response.response {
                            strongSelf.processPayment(paymentUrl: responseURL, newResponse: nil)
                        } else {
                            if let newResp = response.newResponse {
                                strongSelf.processPayment(paymentUrl: newResp.paymentUrl, newResponse: newResp)
                            } else {
                                strongSelf.showAlert(message: "Sorry we are unable to process your payment.", withTitle: "Error")
                                STLog.error("Unable to process payment.")
                            }
                        }
                    }
                }
                else {
                    strongSelf.showAlert(message: response.message, withTitle: "Error")
                    STLog.error(response.message)
                }
                
            case .failure(let error):
                if strongSelf.flightPriceInfoVC.getTotalPayble() == 0 {
                    strongSelf.showPaymentConfirmationView(confirmationType: .failed, statusTitle: "Booking Declined!", statusDetail: "Don't worry. Please enter all your\nvalid data and try again.")
                } else {
                    strongSelf.showAlert(message: "Flight booking failed", withTitle: "Try again later")
                    STLog.error(error.localizedDescription)
                }
            }
        }
    }
    
    private func processPayment(paymentUrl: String?, newResponse: BookingUrlResponse?) {
        guard flightPriceInfoVC.getTotalPayble() > 0 else {
            showPaymentConfirmationView(
                confirmationType: .success,
                statusTitle: "Booking Successfull!",
                statusDetail: "Congratulations. Thank you for\n booking Sharetrip"
            )
            return
        }
        let flightData = flightDetailsViewModel.flightRequiedData
        let tripCoinInfo = PaymentWebVC.TripCoinInfo(
            earn: flightData.earningTripCoin,
            redeem: flightData.earningTripCoin,
            share: flightData.shareTripCoin
        )
        
        var paymentUrlString = ""
        
        if let oldUrl = paymentUrl {
            paymentUrlString = oldUrl
        } else {
            if let newResp = newResponse {
                paymentUrlString = newResp.paymentUrl ?? ""
            }
        }
        
        if !paymentUrlString.isReallyEmpty {
            let paymentVC = PaymentWebVC(
                paymentUrl: URL(string: paymentUrlString)!,
                successUrl: newResponse?.successUrl,
                failureUrl: newResponse?.cancelUrl,
                serviceType: .flight,
                tripCoinInfo: tripCoinInfo,
                notificationScedules: flightDetailsViewModel.dateComponents
            )
            navigationController?.pushViewController(paymentVC, animated: true)
        } else {
            showAlert(message: "Sorry we are unable to process payment, internal error occured.", withTitle: "Error")
        }
    }
    
    private func showPaymentConfirmationView(confirmationType: PaymentConfirmationType, statusTitle: String, statusDetail: String ) {
        let bundle = Bundle(for: PaymentConfirmationVC.self)
        let paymentConfirmationVC = PaymentConfirmationVC(nibName: "PaymentConfirmationVC", bundle: bundle)
        let flightData = flightDetailsViewModel.flightRequiedData
        let data = PaymentConfirmationData(
            confirmationType: confirmationType,
            serviceType: .flight,
            notifierSchedules: flightDetailsViewModel.dateComponents,
            earnTripCoin: flightData.earningTripCoin,
            redeemTripCoin: flightData.earningTripCoin,
            shareTripCoin: flightData.shareTripCoin
        )
        
        paymentConfirmationVC.paymentConfirmationData = data
        navigationController?.pushViewController(paymentConfirmationVC, animated: true)
    }
    
    private func createParametersForAPIRequest() -> [(String, Any)] {
        var parameters: [(String, Any)] = []
        
        var passengers: [String : Any] = [:]
        var adult: [[String : Any]] = []
        var child: [[String : Any]] = []
        var infant: [[String : Any]] = []
        
        travellers.forEach { flightPassengerInfoData in
            switch flightPassengerInfoData.travellerType {
            case .adult:
                adult.append(flightPassengerInfoData.passengerDictionary)
            case .child:
                child.append(flightPassengerInfoData.passengerDictionary)
            case .infant:
                infant.append(flightPassengerInfoData.passengerDictionary)
                
            }
        }
        
        passengers["adult"] = adult
        passengers["child"] = child
        passengers["infant"] = infant
        parameters.append(("passengers", passengers))
        
        parameters.append(("searchId", flightDetailsViewModel.searchId))
        parameters.append(("sequenceCode", flightDetailsViewModel.sequenceCode))
        parameters.append(("sessionId", flightDetailsViewModel.sessionId))
        parameters.append(("specialNote", "")) // omit now, because api is not contained this info
        
        switch flightDetailsViewModel.selectedDiscountOption {
        case .useCoupon:
            if let couponViewModel = useCouponView.useCouponViewModel {
                parameters.append(("otp", couponViewModel.gpstarParams.otp ?? ""))
                parameters.append(("coupon", couponViewModel.appliedCoupon))
                parameters.append(("verifiedMobileNumber", couponViewModel.gpstarParams.verifiedMobileNumber ?? ""))
            }
            
        case .redeemTC:
            let amount = Int(flightDetailsViewModel.redeemDiscountAmount)
            parameters.append(("tripCoin",  amount))
        default:
            break
        }
        
        var gateway: PaymentGateway?
        if selectedGateway != nil {
            gateway = selectedGateway
        } else {
            gateway = defaultSelectedGateway
        }
        
        parameters.append(("gateWay", gateway?.id ?? 0))
        
        
        if gateway?.series.count ?? 0 > 0 {
            parameters.append(("cardSeries", selectedGatewaySeries?.id ?? ""))
        } else {
            parameters.append(("cardSeries", ""))
        }
        
        return  parameters
    }
}

extension FlightSummaryVC: RedeemTripcoinViewDelegate {
    func didChangeRedeemAmount(dicount: Double) {
        flightDetailsViewModel.redeemDiscountAmount = dicount
        updatePriceTableView()
    }
}

// MARK: - Setup views
extension FlightSummaryVC {
    
    private func setupFloatingPanel() {
        
        floatingPanelVC = FloatingPanelController()
        floatingPanelVC.delegate = self
        
        let flightPriceInfoVC = FlightPriceBreakdownVC.instantiate()
        flightPriceInfoVC.buttonTitle = "Pay Now"
        flightPriceInfoVC.buttonFunction = { [weak self] in
            self?.continueButtontapped()
        }
        
        flightPriceInfoVC.viewModel = FlightPriceBreakdownViewModel(priceInfoTableData: priceInfoTableData)
        
        floatingPanelVC.set(contentViewController: flightPriceInfoVC)
        self.flightPriceInfoVC = flightPriceInfoVC
        
        // Initialize FloatingPanelController and add the view
        floatingPanelVC.surfaceView.appearance.cornerRadius = 10.0
        floatingPanelVC.surfaceView.grabberHandleSize = CGSize(width: 72.0, height: 6.0)
        
        // Track a scroll view(or the siblings) in the content view controller.
        floatingPanelVC.track(scrollView: flightPriceInfoVC.pricaTableView)
        
    }
    
    
    private func setupLegViews() {
        legViewTitleLabel.text = "\(flightDetailsViewModel.firstAirportIata) - \(flightDetailsViewModel.lastAirportIata)"
        
        if let firstLeg = flightDetailsViewModel.flightLegs.first,
           let lastLeg = flightDetailsViewModel.flightLegs.last {
            
            let firstDateStr = Date(fromString: firstLeg.departureDateTime.date, format: .isoDate)?
                .toString(format: .custom("MMM dd yyyy"))
            let firstStr = firstDateStr ?? firstLeg.departureDateTime.date
            
            let lastDateStr = Date(fromString: lastLeg.departureDateTime.date, format: .isoDate)?
                .toString(format: .custom("MMM dd yyyy"))
            let lastStr = lastDateStr ?? lastLeg.departureDateTime.date
            
            legViewDateLabel.text = "\(firstStr) - \(lastStr)"
            
        } else {
            legViewDateLabel.text = ""
        }
        
        let totalTravellers = flightDetailsViewModel.getPassengers().count
        legViewPersonLabel.text = "\(totalTravellers) " + "Traveller".getPlural(totalTravellers > 1)
        
        for leg in flightDetailsViewModel.flightLegs {
            let view = FlightLegView.instantiate()
            let data = FlightLegData(
                originName: leg.originName.code,
                destinationName: leg.destinationName.code,
                airplaneName: leg.airlines.short,
                airplaneLogo: leg.logo,
                departureTime: leg.departureDateTime.time,
                arrivalTime: leg.arrivalDateTime.time,
                stop: leg.stop,
                dayCount: leg.dayCount,
                duration: leg.duration
            )
            view.config(with: data)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.heightAnchor.constraint(equalToConstant: 56).isActive = true
            view.backgroundColor = .white
            legViewContainer.addArrangedSubview(view)
        }
        legViewContainer.isHidden = true
    }
    
    private func setupDiscountOptions() {
        discountOptionViews.removeAll()
        
        for discountOption in discountOptions {
            switch discountOption.type {
            case .earnTC:
                setupEarnTripcoinView(title: discountOption.title, subTitle: discountOption.subtitle)
                
            case .redeemTC:
                setupRedeemTripcoinView(title: discountOption.title, subTitle: discountOption.subtitle)
                
            case .useCoupon:
                setupUseCouponView(title: discountOption.title, subTitle: discountOption.subtitle)
                
            case .unknown:
                break
            }
        }
        
        discountOptionView = DiscountOptionsContainer()
        discountOptionView.discountOptionViews = discountOptionViews
        discountOptionView.delegate = self
        discountViewContainer.addArrangedSubview(discountOptionView)
        discountViewContainer.isHidden = true
        discountOptionView.translatesAutoresizingMaskIntoConstraints = false
        toggleDiscountView()
    }
    
    private func setupEarnTripcoinView(title: String, subTitle: String) {
        earnTripcoinView = EarnTripcoinView.instantiate()
        earnTripcoinView.discountAmount = flightDetailsViewModel.earnTCDiscount
        earnTripcoinView.discountOptionTitle = title
        earnTripcoinView.subTitle = subTitle
        discountOptionViews.append(earnTripcoinView)
        if flightDetailsViewModel.selectedDiscountOption == .earnTC {
            earnTripcoinView.expand()
        } else {
            earnTripcoinView.collapse()
        }
        discountOptionViews.append(earnTripcoinView)
    }
    
    private func setupRedeemTripcoinView(title: String, subTitle: String) {
        redeemTripcoinView = RedeemTripcoinView.instantiate()
        redeemTripcoinView.redeemDelegate = self
        let userTripCoin = Double(STAppManager.shared.userAccount?.redeemablePoints ?? 0)
        let maxValue = min(userTripCoin, Double(flightDetailsViewModel.earnTC))
        let adjustedMaxValue = max(0, maxValue)
        redeemTripcoinView.configure(minValue: 0, maxValue: adjustedMaxValue, selectedValue: flightDetailsViewModel.selectedDiscountOption == .redeemTC ? priceInfoTableData.discount : nil, title: title, subtitle: subTitle)
        discountOptionViews.append(redeemTripcoinView)
        if flightDetailsViewModel.selectedDiscountOption == .redeemTC {
            redeemTripcoinView.expand()
        } else {
            redeemTripcoinView.collapse()
        }
        discountOptionViews.append(redeemTripcoinView)
    }
    
    private func setupUseCouponView(title: String, subTitle: String) {
        useCouponView.subTitleText = subTitle
        discountOptionViews.append(useCouponView)
        if flightDetailsViewModel.selectedDiscountOption == .useCoupon {
            useCouponView.expand()
        } else {
            useCouponView.collapse()
        }
        discountOptionViews.append(useCouponView)
    }
    
    private func setupPaymentGateways() {
        for view in paymentGatewayViewHolder.subviews {
            view.removeFromSuperview()
        }
        
        paymentGatewaysView = PaymentGatewaysView.instantiate()
        paymentGatewaysView.delegate = self
        paymentGatewaysView.configure(.flight, flightDetailsViewModel.currency)
        paymentGatewaysView.paymentGatewayLoading.bindAndFire { isLoading in
            isLoading ? HUD.show(.progress) : HUD.hide()
        }
        filterPaymentGateway()
        
        paymentGatewayViewHolder.addArrangedSubview(paymentGatewaysView)
    }
    
    //MARK: - Term and conditions & Privacy policy
    private func setupTermsAndConditons() {
        let condisionStr = "I Agree to the ShareTrip Terms & Conditions and Privacy Policy"
        
        termsAndConditionsLabel.text = condisionStr
        termsAndConditionsLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        let underlineAttriString = NSMutableAttributedString(string: condisionStr)
        
        let attributes = [
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.foregroundColor: UIColor.blueBlue
        ] as [NSAttributedString.Key: Any]
        
        let range1 = (condisionStr as NSString).range(of: "Terms & Conditions")
        underlineAttriString.addAttributes(attributes, range: range1)
        
        let range2 = (condisionStr as NSString).range(of: "Privacy Policy")
        underlineAttriString.addAttributes(attributes, range: range2)
        self.termsAndConditionsLabel.attributedText = underlineAttriString
        
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(self.agreementLabelTapped(gesture:)))
        self.termsAndConditionsLabel.isUserInteractionEnabled = true
        self.termsAndConditionsLabel.addGestureRecognizer(tapAction)
    }
    
    @objc private func agreementLabelTapped(gesture: UITapGestureRecognizer) {
        guard let text = self.termsAndConditionsLabel.text else { return }
        let termsRange = (text as NSString).range(of: "Terms & Conditions")
        let privacyRange = (text as NSString).range(of: "Privacy Policy")
        
        if gesture.didTapAttributedTextInLabel(label: self.termsAndConditionsLabel, inRange: termsRange) {
            openTermsAndConditions()
        } else if gesture.didTapAttributedTextInLabel(label: self.termsAndConditionsLabel, inRange: privacyRange) {
            openPrivacyPolicy()
        } else {
            STLog.warn("Tapped none")
        }
    }
    
    private func openTermsAndConditions() {
        STLog.info("Tapped terms")
        HUD.show(.progress)
        let tncService = DefaultAPIClient()
        tncService.getTNC(completion: { [weak self] (result) in
            HUD.hide()
            switch result {
            case .success(let tnc):
                let htmlStr = Helpers.generateHtml(content: tnc.common.body, header: tnc.common.title)
                let webVC = WebViewController()
                webVC.sourceType = .staticHtmlFile
                webVC.htmlString = htmlStr
                webVC.title = AccountCellInfo.terms.title
                let navController = NavigationController(rootViewController: webVC)
                self?.present(navController, animated: true, completion: nil)
            case .failure:
                HUD.flash(.labeledError(title: "Failed to load Terms & Conditions", subtitle: ""))
            }
        })
    }
    
    private func showPrivacyPolicyAlert() {
        let message = "Please agree to the T&C and Privacy Policy"
        self.showMessage(message, type: .error)
    }
    
    private func openPrivacyPolicy() {
        STLog.info("Tapped privacy")
        
        do {
            let webVC = WebViewController()
            webVC.sourceType = .staticHtmlFile
            
            if let filePath = Bundle.main.path(forResource: "privacy", ofType: "html") {
                let contents =  try String(contentsOfFile: filePath, encoding: .utf8)
                let baseUrl = URL(fileURLWithPath: filePath)
                webVC.htmlString = contents
                webVC.baseURL = baseUrl
                webVC.title = "Privacy Policy"
                let navController = NavigationController(rootViewController: webVC)
                self.present(navController, animated: true, completion: nil)
            }
        }
        catch {
            STLog.error("Could Not load Privacy Policy")
        }
    }
    
    private func filterPaymentGateway() {
        switch flightDetailsViewModel.selectedDiscountOption {
        case .useCoupon:
            let couponGateways = useCouponView.useCouponViewModel?.selectedCouponGateways ?? []
            if couponGateways.count > 0 {
                paymentGatewaysView.filterPaymentGateways(
                    filter: flightDetailsViewModel.paymentGateWayfilter(gatewayIds: couponGateways))
            } else {
                paymentGatewaysView.filterPaymentGateways(filter: flightDetailsViewModel.paymentGateWayfilter())
            }
        default:
            paymentGatewaysView.filterPaymentGateways(filter: flightDetailsViewModel.paymentGateWayfilter())
        }
    }
    
    private func updatePriceTableView() {
        switch flightDetailsViewModel.selectedDiscountOption {
        case .earnTC:
            priceInfoTableData.discount = flightDetailsViewModel.earnTCDiscount
            priceInfoTableData.withDiscount = true
            priceInfoTableData.couponsDiscount = 0
            
        case .redeemTC:
            priceInfoTableData.discount = flightDetailsViewModel.redeemDiscountAmount
            priceInfoTableData.withDiscount = true
            priceInfoTableData.couponsDiscount = 0
            
        case .useCoupon:
            priceInfoTableData.discount = flightDetailsViewModel.earnTCDiscount
            priceInfoTableData.withDiscount = useCouponView.useCouponViewModel?.isWithDiscount ?? false
            priceInfoTableData.couponsDiscount = useCouponView.useCouponViewModel?.couponDiscount ?? 0.0
        case .unknown:
            break
        }
        flightPriceInfoVC?.selectedDiscountOption = flightDetailsViewModel.selectedDiscountOption
        flightPriceInfoVC?.relaodPriceTable(with: priceInfoTableData)
        updatePayNowButtonStatus()
    }
}

//MARK: - Floating Panel controller Delegates
extension FlightSummaryVC: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
        return CustomFloatingLayout()
    }
    
    func floatingPanelDidRemove(_ vc: FloatingPanel.FloatingPanelController){
        STLog.info("floatingPanelDidEndRemove")
    }
}

//MARK: - Discount Option view Delegates
extension FlightSummaryVC: DiscountOptionViewDelegate {
    func selectedOptionChanged(_ selectedOptionView: DiscountOptionCollapsibleView) {
        flightDetailsViewModel.selectedDiscountOption = selectedOptionView.discountOptionType
        
        if selectedOptionView.discountOptionType == .redeemTC {
            analytics.log(FlightEvent.clickOnRedeemTripcoin())
        }
        
        filterPaymentGateway()
        updatePriceTableView()
    }
    
    func discountAmountChanged(_ discount: Double) {
        updatePriceTableView()
    }
}

//MARK: - Payment getway view Delegates
extension FlightSummaryVC: PaymentGatewaysViewDelegate {
    func onFilterPaymentGateway(allPaymentGateways: [PaymentGateway], dafultPaymentGateway: PaymentGateway?) {
        if dafultPaymentGateway != nil {
            self.defaultSelectedGateway = dafultPaymentGateway
        }
        self.allPaymentGateways = allPaymentGateways
    }
    
    func onPaymentGatewayFetchingFailed(with error: String) {
        showMessage("Can't fetch payment gateways", type: .success, options: [.hideOnTap(true), .autoHide(true), .autoHideDelay(2)])
    }
    
    func onSelectGateway(paymentGateway: PaymentGateway?, selectedGatewaySeries: GatewaySeries?) {
        selectedGateway = paymentGateway
        self.selectedGatewaySeries = selectedGatewaySeries
        self.priceInfoTableData.stCharge = selectedGateway?.charge ?? 0.0
        isUSDPayment = selectedGateway?.isUSDPayment ?? false
        let convertionRate = paymentGateway?.currency.conversion.rate ?? 1.0
        flightPriceInfoVC.relaodTableViewWith(with: priceInfoTableData, convertionRate, and: isUSDPayment)
        updatePayNowButtonStatus()
    }
}

extension FlightSummaryVC: StoryboardBased {
    static var storyboardName: String {
        return "Flight"
    }
}
