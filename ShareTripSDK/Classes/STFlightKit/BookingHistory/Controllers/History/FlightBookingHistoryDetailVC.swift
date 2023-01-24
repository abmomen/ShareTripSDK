//
//  FlightBookingHistoryDetailVC.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 20/02/2020.
//  Copyright © 2020 TBBD IOS. All rights reserved.
//

import UIKit
import PKHUD
import MessageUI


class FlightBookingHistoryDetailVC: ViewController {
    private var cancellationAlertView: CancellationAlertView?
    private let viewModel: FlightBookingHistoryDetailViewModel
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.registerNibCell(FlightBookingCell.self)
        tableView.registerNibCell(RetryInfoCardCell.self)
        tableView.registerNibCell(SingleButtonCardCell.self)
        tableView.registerCell(WeightInfoCell.self)
        tableView.registerNibCell(SingleLineInfoCardCell.self)
        tableView.backgroundColor = UIColor.offWhite
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var headerView: UIView = {
        let view = UIView()
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        let attributedString = NSMutableAttributedString(string: "Details Information")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: 1.88, range: NSRange(location: 0, length: attributedString.length - 1))
        attributedString.addAttributes(
            [
                NSAttributedString.Key.kern: 1.88,
                NSAttributedString.Key.foregroundColor: UIColor.darkGray,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .medium)
            ],
            range: NSRange(location: 0, length: attributedString.length))
        label.attributedText = attributedString
        
        view.backgroundColor = .clear
        
        return view
    }()
    
    init(viewModel: FlightBookingHistoryDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
        handleNetworkResponse()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if viewModel.sections.count > 1 && viewModel.sections[1].contains(.cancelBooking) {
            cancellationAlertView = CancellationAlertView(frame: UIScreen.main.bounds)
        }
    }
    
    private func setupScene() {
        title = "Booking Details"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        if let totalPoints = STAppManager.shared.userAccount?.totalPoints {
            navigationItem.rightBarButtonItem = TripCoinBarButtonItem.createWithText(totalPoints.withCommas())
        }
        view.backgroundColor = .offWhite
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func handleNetworkResponse() {
        viewModel.callback.didRetryBooking = {[weak self] paymentUrls in
            self?.openFlightPaymentScene(paymentUrls: paymentUrls)
            HUD.hide(animated: false)
        }
        
        viewModel.callback.didResendVoucher = {[weak self] in
            self?.showAlert(message: "We’ve send the voucher to your email. Check your inbox.", withTitle: nil)
            HUD.hide(animated: false)
        }
        
        viewModel.callback.didCancelFlight = {[weak self] in
            HUD.hide(animated: false)
            self?.showAlert(message: "Your cancellation request has been accepted. We’ll notify shortly.", withTitle: nil, handler: { (alert) in
                self?.navigationController?.popViewController(animated: true)
            })
        }
        
        viewModel.callback.didFailed = {[weak self] error in
            self?.showAlert(message: error, withTitle: "Error")
            HUD.hide(animated: false)
        }
    }
    
    
    // MARK: - Actions
    private func handleUserAction(cellType: FlightBookingHistoryCellTypes){
        switch cellType {
        case .retryBooking:
            retryBookingButtonDidTap()
        case .cancelBooking:
            cancelBookingButtonDidTap()
        case .resendVoucher:
            resendVoucherButtonDidTap()
        case .refund:
            refundButtonTapped()
        case .void:
            voidButtonTapped()
        default:
            break
        }
    }
    
    private func openDetailInfoScene() {
        let flightInfoVC = FlightInfoVC(history: viewModel.history)
        navigationController?.pushViewController(flightInfoVC, animated: true)
    }
    
    private func openTravellersInfoScene(title: String) {
        let travellerInfoVC = FlightTravellerInfoVC(travellerInfo: viewModel.getTravellerInfo())
        self.navigationController?.pushViewController(travellerInfoVC, animated: true)
    }
    
    private func openPriceInfoScene() {
        let priceInfoViewModel = viewModel.getPriceInfoViewModel()
        let princeInfoVC = BookingHistoryPriceTableVC(viewModel: priceInfoViewModel)
        self.navigationController?.pushViewController(princeInfoVC, animated: true)
    }
    
    private func openCancelationScene() {
        let webVC = WebViewController()
        webVC.sourceType = .htmlString
        webVC.htmlString = viewModel.getAirFareRulesHtmlString()
        webVC.title = "Cancelation Policy"
        self.navigationController?.pushViewController(webVC, animated: true)
    }
    
    private func openFlightPaymentScene(paymentUrls: PaymentUrls){
        if !paymentUrls.paymentURL.isReallyEmpty {
            let paymentVC = PaymentWebVC(
                paymentUrl: URL(string: paymentUrls.paymentURL)!,
                successUrl: paymentUrls.successUrl,
                failureUrl: paymentUrls.failureUrl,
                serviceType: .flight,
                tripCoinInfo: viewModel.getTripcoinInfo()
            )
            navigationController?.pushViewController(paymentVC, animated: true)
        } else {
            showAlert(message: "Could not process payment.", withTitle: "Error")
        }
        
    }
    
    private func retryBookingButtonDidTap() {
        HUD.show(.progress)
        viewModel.retryFlightBooking()
    }
    
    private func cancelBookingButtonDidTap() {
        if cancellationAlertView == nil {
            cancellationAlertView = CancellationAlertView(frame: UIScreen.main.bounds)
        }
        
        cancellationAlertView?.callbackClosure = { [weak self] (yes) in
            DispatchQueue.main.async {
                guard let yes = yes else {
                    self?.openCancelationScene()
                    return
                }
                if yes {
                    self?.callCancelBookingAPI()
                }
            }
        }
        
        self.view.addSubview(cancellationAlertView!)
    }
    
    private func callCancelBookingAPI() {
        HUD.show(.labeledProgress(title: nil, subtitle: "Canceling ..."))
        viewModel.callFlightCancelBookingAPI()
    }
    
    private func resendVoucherButtonDidTap() {
        HUD.show(.labeledProgress(title: nil, subtitle: "Resending ..."))
        viewModel.resendFlightVoucherButtonDidTap()
    }
    
    private func refundButtonTapped() {
        let refundViewModel = RefundVoidViewModel(searchId: viewModel.searchId,
                                                  bookingCode: viewModel.bookingCode)
        let passengerSelectionVC = RefundablePassengersSelectionVC.instantiate()
        passengerSelectionVC.viewModel = refundViewModel
        navigationController?.pushViewController(passengerSelectionVC, animated: true)
    }
    
    private func voidButtonTapped() {
        let voidQuotationViewModel = FlightVoidQuotationViewModel()
        voidQuotationViewModel.searchId = viewModel.searchId
        voidQuotationViewModel.bookingCode = viewModel.bookingCode
        let voidQuotationVC = VoidQuotationDetailsVC.instantiate()
        voidQuotationVC.viewModel = voidQuotationViewModel
        navigationController?.pushViewController(voidQuotationVC, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension FlightBookingHistoryDetailVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellInfo = viewModel.sections[indexPath.section][indexPath.row]
        
        switch cellInfo {
        case .detail:
            var cellHeight: CGFloat?
            if viewModel.bookingStatus == .booked && viewModel.paymentStatus == .unpaid {
                cellHeight = 151.0
            }
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as FlightBookingCell
            cell.configure(historyOption: .flight, history: viewModel.history, showHighlightAnimation: false, cellHeight: cellHeight)
            cell.hideSeparator()
            cell.selectionStyle = .none
            cell.backgroundColor = cellInfo.backgroundColor
            cell.contentView.backgroundColor = cellInfo.backgroundColor
            cell.containerView.backgroundColor = cellInfo.backgroundColor
            cell.isUserInteractionEnabled = false
            return cell
            
        case .retryInfo:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as RetryInfoCardCell
            cell.configure(title: "Please retry before booking canceled")
            return cell
            
        case .retryBooking, .cancelBooking, .resendVoucher, .refund, .void:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SingleButtonCardCell
            cell.configure(title: cellInfo.title, titleColor: cellInfo.titleColor, backgroundColor: cellInfo.backgroundColor)
            cell.callBack = {[weak self] in
                self?.handleUserAction(cellType: cellInfo)
                
            }
            return cell
            
        case .weight:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as WeightInfoCell
            cell.configure(history: viewModel.history)
            cell.selectionStyle = .none
            cell.contentView.backgroundColor = .clear
            cell.backgroundColor = .clear
            return cell
            
        case .info, .traveler, .price, .airFareRule, .baggage, .fareDetail, .supportCenter, .cancelationPolicy:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SingleLineInfoCardCell
            cell.configure(title: cellInfo.title)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cellInfo = viewModel.sections[indexPath.section][indexPath.row]
        
        switch cellInfo {
        case .info:
            openDetailInfoScene()
        case .traveler:
            openTravellersInfoScene(title: cellInfo.title)
        case .price:
            openPriceInfoScene()
        case .cancelationPolicy:
            openCancelationScene()
        case .baggage:
            let vc = BaggageHistoryDetailsVC()
            vc.baggageInfo = viewModel.baggage
            vc.luggageAmount = viewModel.luggageAmount
            navigationController?.pushViewController(vc, animated: true)
        case .fareDetail:
            do {
                let webVC = WebViewController()
                webVC.sourceType = .staticHtmlFile
                
                if let filePath = Bundle.main.path(forResource: "FareDetails", ofType: "html") {
                    
                    let contents =  try String(contentsOfFile: filePath, encoding: .utf8)
                    let baseUrl = URL(fileURLWithPath: filePath)
                    
                    webVC.htmlString = contents
                    webVC.baseURL = baseUrl
                    webVC.title = cellInfo.title
                    self.navigationController?.pushViewController(webVC, animated: true)
                }
            }
            catch {
                STLog.error("File HTML error")
            }
        case .supportCenter:
            openSupportCenterMail()
        default:
            break
        }
    }
}

// MARK: UITableView delegate methods
extension FlightBookingHistoryDetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 1 else { return UIView() }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section == 1 else { return .leastNonzeroMagnitude }
        return 44
    }
}

extension FlightBookingHistoryDetailVC {
    func openSupportCenterMail() {
        let email = Constants.App.supportMail
        
        let subject = "Flight Support Center: \(viewModel.pnrCode)"
        let bodyText = "Please provide information that will help us to serve you better"
        
        if MFMailComposeViewController.canSendMail() {
            
            let mailComposerVC = MFMailComposeViewController()
            mailComposerVC.mailComposeDelegate = self
            mailComposerVC.setToRecipients([email])
            mailComposerVC.setSubject(subject)
            mailComposerVC.setMessageBody(bodyText, isHTML: true)
            mailComposerVC.modalPresentationStyle = .fullScreen
            self.present(mailComposerVC, animated: true, completion: nil)
            
        } else {
            let coded = "mailto:\(email)?subject=\(subject)&body=\(bodyText)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            if let emailURL = URL(string: coded!) {
                if UIApplication.shared.canOpenURL(emailURL) {
                    UIApplication.shared.open(emailURL)
                }
            }
        }
    }
}

extension FlightBookingHistoryDetailVC: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
