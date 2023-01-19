//
//  PaymentWebVC.swift
//  TBBD
//
//  Created by Mac on 5/20/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit
import WebKit
import PKHUD
import FirebaseRemoteConfig

public extension PaymentWebVC {
    struct TripCoinInfo {
        let earn: Int
        let redeem: Int
        let share: Int
        
        public init(earn: Int, redeem: Int, share: Int) {
            self.earn = earn
            self.redeem = redeem
            self.share = share
        }
    }
}

public class PaymentWebVC: UIViewController {
    // The observation object for the progress of the web view (we only receive notifications until it is deallocated).
    private var estimatedProgressObserver: NSKeyValueObservation?
    private var notificationScedules = [DateComponents]()
    private var tripCoinInfo: TripCoinInfo?
    private let serviceType: ServiceType
    
    private let paymentUrl: URL
    private var successUrl: String
    private var failureUrl: String
    
    var isNavigateToRootVC = false
    
    private(set) var urlOptions = [UrlOption]()

    private lazy var webView: WKWebView = {
        let view = WKWebView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let progressView: UIProgressView = {
        let view = UIProgressView(progressViewStyle: .default)
        view.tintColor = UIColor.appPrimary
        view.setProgress(0.0, animated: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public init(
        paymentUrl: URL,
        successUrl: String? = nil,
        failureUrl: String? = nil,
        serviceType: ServiceType,
        tripCoinInfo: TripCoinInfo?,
        notificationScedules: [DateComponents] = []
    ) {
        self.paymentUrl = paymentUrl
        self.successUrl = successUrl ?? ""
        self.failureUrl = failureUrl ?? ""
        self.serviceType = serviceType
        self.tripCoinInfo = tripCoinInfo
        self.notificationScedules = notificationScedules
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupEstimatedProgressObserver()
        
        if successUrl.isReallyEmpty || failureUrl.isReallyEmpty {
            fetchUrlFromRemoteConfig()
        }
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        progressView.removeFromSuperview()
    }
    
    deinit {
        estimatedProgressObserver = nil
    }
    
    //MARK:- IBActions
    @objc
    private func backButtonTapped(_ sender: UIBarButtonItem){
        let alertVC = UIAlertController(title: "Warning!", message: "If you go back, payment process will be hampered!", preferredStyle: .alert)
        let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okBtn = UIAlertAction(title: "Go Back", style: .destructive, handler: { [weak self] (action) in
            if self?.isNavigateToRootVC == true {
                self?.navigationController?.popToRootViewController(animated: true)
                self?.isNavigateToRootVC = false
            } else {
                self?.navigationController?.popViewController(animated: true)
            }
        })
        
        alertVC.addAction(cancelBtn)
        alertVC.addAction(okBtn)
        alertVC.modalPresentationStyle = .fullScreen
        present(alertVC, animated: true, completion: nil)
    }
    
    //MARK:- Helpers
    private func setupViews() {
        
        title = "Payment Process"
        weak var weakSelf = self
        navigationItem.leftBarButtonItems = BackButton.createWithText("Back", color: UIColor.white, target: weakSelf, action: #selector(backButtonTapped(_:)))
        if let totalPoints = STAppManager.shared.userAccount?.totalPoints {
            navigationItem.rightBarButtonItem = TripCoinBarButtonItem.createWithText(totalPoints.withCommas())
        }
        let message = "Payment process will be processed in app browser. Please don't close the app or go back until payment is successful"
        showAlert(message: message, withTitle: "Warning!")
        
        webView.navigationDelegate = self
        
        view.backgroundColor = .white
        view.addSubview(webView)
        view.addSubview(progressView)
        
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                webView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
                webView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor),
                webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
        }
        
        //setup Progress View
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.addSubview(progressView)
        progressView.isHidden = true
        
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor),
            progressView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 2.0)
        ])
        
        loadWebView(with: paymentUrl)
    }
    
    private func loadWebView(with url: URL?) {
        if let url = url {
            let urlRequest = URLRequest(url: url)
            URLCache.shared.removeCachedResponse(for: urlRequest)
            webView.load(urlRequest)
        }
    }
    
    private func setupEstimatedProgressObserver() {
        estimatedProgressObserver = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] webView, _ in
            self?.progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    private func fetchUrlFromRemoteConfig() {
        let remoteConfig = RemoteConfig.remoteConfig()
        STAppManager.shared.setupRemoteConfigDefaults()
        
        remoteConfig.fetch { [weak self] (status, error) -> Void in
            if status == .success {
                remoteConfig.activate { (_, error) in
                    if let error = error {
                        STLog.error(error.localizedDescription)
                    }
                }
                if let urlOptionsJSONStr = remoteConfig[Constants.RemoteConfigKey.success_urls].stringValue,
                   let jsonData = urlOptionsJSONStr.data(using: .utf8) {
                    let urlOptions = try? JSONDecoder().decode([UrlOption].self, from: jsonData)
                    self?.urlOptions = urlOptions ?? []
                }
                if let urlOption = self?.urlOptions {
                    for url in urlOption {
                        if url.service_type == self?.serviceType {
                            if url.status == .success {
                                self?.successUrl = url.url
                            }
                            self?.failureUrl = url.url
                        }
                    }
                }
            } else {
                self?.fetchURLFromBundle()
            }
        }
    }
    
    private func fetchURLFromBundle() {
        if let path = Bundle.main.path(forResource: "PaymentConfirmationURL", ofType: "json"){
            guard let jsonData = try? String(contentsOfFile: path).data(using: .utf8) else { return }
            do{
                urlOptions = try JSONDecoder().decode([UrlOption].self, from: jsonData)
            }catch {
                STLog.info("Could not decode!")
            }
        }
        
        for url in urlOptions {
            if url.service_type == self.serviceType {
                if url.status == .success {
                    self.successUrl = url.url
                }
                self.failureUrl = url.url
            }
        }
    }
}

// MARK: - WKNavigationDelegate
extension PaymentWebVC: WKNavigationDelegate {
    public func webView(_: WKWebView, didStartProvisionalNavigation _: WKNavigation!) {
        if progressView.isHidden {
            progressView.isHidden = false
        }
        
        UIView.animate(withDuration: 0.33,
                       animations: {self.progressView.alpha = 1.0})
    }
    
    public func webView(_: WKWebView, didFinish _: WKNavigation!) {
        UIView.animate(withDuration: 0.33,
                       animations: {self.progressView.alpha = 0.0},
                       completion: { isFinished in
                        self.progressView.isHidden = isFinished})
    }
    
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        /// Sometimes this  NSURLErrorDomain -999 occurs becasue of multiple times calling a single api.
        let domainError = error as NSError
        if domainError.code == -999 {
            showAlert(message: "Error Message", withTitle:"Please avoid multiple click on buttons.", handler: nil)
            webView.reload()
        }
        
        showAlert(message: "Error", withTitle: error.localizedDescription, handler: nil)
        STLog.error(error)
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let urlStr = navigationAction.request.url?.absoluteString {
            if urlStr == successUrl || urlStr == Constants.PaymentConstants.successUrl {
                let paymentConfirmationVC = PaymentConfirmationVC(nibName: "PaymentConfirmationVC", bundle: nil)
                let data = PaymentConfirmationData(
                    confirmationType: .success,
                    serviceType: serviceType,
                    notifierSchedules: notificationScedules,
                    earnTripCoin: tripCoinInfo?.earn ?? 0,
                    redeemTripCoin: tripCoinInfo?.redeem ?? 0,
                    shareTripCoin: tripCoinInfo?.share ?? 0
                )
                paymentConfirmationVC.paymentConfirmationData = data
                navigationController?.pushViewController(paymentConfirmationVC, animated: true)
                
            } else if urlStr == failureUrl || urlStr == Constants.PaymentConstants.failedUrl {
                let paymentConfirmationVC = PaymentConfirmationVC(nibName: "PaymentConfirmationVC", bundle: nil)
                let data = PaymentConfirmationData(
                    confirmationType: .failed,
                    serviceType: serviceType,
                    notifierSchedules: [],
                    earnTripCoin: tripCoinInfo?.earn ?? 0,
                    redeemTripCoin: tripCoinInfo?.redeem ?? 0,
                    shareTripCoin: tripCoinInfo?.share ?? 0
                )
                paymentConfirmationVC.paymentConfirmationData = data
                navigationController?.pushViewController(paymentConfirmationVC, animated: true)
            }
        }
        decisionHandler(.allow)
    }
}
