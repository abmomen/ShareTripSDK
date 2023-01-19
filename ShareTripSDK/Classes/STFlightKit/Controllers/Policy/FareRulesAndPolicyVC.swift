//
//  RulesAndPolicyVC.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 4/16/20.
//  Copyright © 2020 ShareTrip. All rights reserved.
//

import UIKit
import WebKit


class FareRulesAndPolicyVC: UIViewController {

    //MARK: - Instance variables
    private var readRulesHeight: CGFloat = 0.0
    private let flightInfoProvider: FlightInfoProvider
    private var refundPolicyText = """
                                 <p style="font-size: 18px">
                                    Refund and Date Change are done as per the following policies. <br><br>
                                    Refund Amount= Refund Charge (as per airline policy + ShareTrip Convenience Fee). <br><br>
                                    Date Change Amount= Date Change Fee (as per Airline Policy + ShareTrip Convenience Fee).
                                 </p>
                               """

    private let segmentedControl: UISegmentedControl = {
        let items = ["Baggage", "Fare Details", "Refund Policy"]
        var topSegment = UISegmentedControl(items: items)
        topSegment.addTarget(FareRulesAndPolicyVC.self, action: #selector(indexChanged(_:)), for: .valueChanged)
        topSegment.layer.cornerRadius = 5.0
        topSegment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.appPrimary], for: UIControl.State.selected)
        let font = UIFont.systemFont(ofSize: 15, weight: .medium)
        topSegment.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        topSegment.translatesAutoresizingMaskIntoConstraints = false
        return topSegment
    }()

    private let webView: WKWebView = {
        let wkWebView = WKWebView()
        wkWebView.backgroundColor = .clear
        wkWebView.translatesAutoresizingMaskIntoConstraints = false
        return wkWebView
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 44.0, height: 44.0)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .white
        activityIndicator.color = .gray
        return activityIndicator
    }()

    //MARK: - Initializers
    init(flightInfoProvider: FlightInfoProvider) {
        self.flightInfoProvider = flightInfoProvider
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - View controller life cycle
    override func viewDidLoad() {
        view.backgroundColor = .white
        setupView()
        setupRightNavBar()
        loadWebView()

        switch flightInfoProvider.getDetailInfoType() {
        case .bagageInfo:
            title = "Baggage Details"
            segmentedControl.selectedSegmentIndex = 0
        case .fareDetail:
            title = "Fare Details"
            segmentedControl.selectedSegmentIndex = 1
        case .refundPolicy:
            title = "Refund Policy"
            segmentedControl.selectedSegmentIndex = 2
        }
    }

    private func setupView() {
        view.addSubview(segmentedControl)
        segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8.0).isActive = true
        segmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 8.0).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8.0).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 44.0).isActive = true

        view.addSubview(webView)
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 18.0).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        if #available(iOS 11.0, *) {
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 16.0).isActive = true
        } else {
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 16.0).isActive = true
        }
        

        // add activity indicator
        webView.navigationDelegate = self
        activityIndicator.center = view.center
        webView.addSubview(activityIndicator)
        showActivityIndicator(show: true)
    }

    //MARK: - Helpers
    private func setupRightNavBar() {
        if let user = STAppManager.shared.userAccount {
            navigationItem.rightBarButtonItem = TripCoinBarButtonItem.createWithText(user.totalPoints.withCommas())
        }
    }

    @objc func indexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            title = "Baggage Details"
            flightInfoProvider.setDetailInfoType(.bagageInfo)
        case 1:
            title = "Fare Details"
            flightInfoProvider.setDetailInfoType(.fareDetail)
        case 2:
            title = "Refund Policy"
            flightInfoProvider.setDetailInfoType(.refundPolicy)
        default:
            break
        }
        loadWebView()
    }

    private func showActivityIndicator(show: Bool) {
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }

    private func loadWebView() {
        flightInfoProvider.fetchWebData(completionHandler: { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let htmlContent):
                switch self.flightInfoProvider.getDetailInfoType() {
                case .refundPolicy:
                    self.refundPolicyText += htmlContent
                    self.webView.loadHTMLString(self.refundPolicyText, baseURL: nil)
                    
                default:
                    self.webView.loadHTMLString(htmlContent, baseURL: nil)
                }
            case .failure:
                let errorMessageHtml = Helpers.generateHtml(content: "\(self.title ?? "Information") not found!")
                self.webView.loadHTMLString(errorMessageHtml, baseURL: nil)
            }
        })
    }
}

//MARK: - Webview delegate
extension FareRulesAndPolicyVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showActivityIndicator(show: false)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        showActivityIndicator(show: false)
    }
}
