//
//  WebViewController.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/23/22.
//

import UIKit
import WebKit

public enum WebSourceType {
    case htmlString
    case url
    case staticHtmlFile
    case dataSource
}

public protocol WebViewDataSource {
    func fetchWebData(completionHandler: @escaping (Result<String, Error>) -> Void)
}

public class StaticHtmlDataProvider: WebViewDataSource {
    
    public let fileName: String
    
    public init(fileName: String) {
        self.fileName = fileName
    }
    
    public func fetchWebData(completionHandler: @escaping (Result<String, Error>) -> Void) {
        do {
            if let filePath = Bundle.main.path(forResource: fileName, ofType: "html") {
                let content = try String(contentsOfFile: filePath, encoding: .utf8)
                completionHandler(.success(content))
            } else {
                completionHandler(.failure(NSError(domain: "HTML file error", code: 0, userInfo: nil)))
            }
        } catch {
            completionHandler(.failure(NSError(domain: "HTML file error", code: 0, userInfo: nil)))
        }
    }
}

public class WebViewController: UIViewController {
    
    public let webView = WKWebView()
    
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 44.0, height: 44.0)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.color = .gray
        return activityIndicator
    }()
    
    public var sourceType: WebSourceType!
    public var htmlString: String?
    public var baseURL: URL?
    public  var dataSource: WebViewDataSource?
    
    public convenience init() {
        self.init(sourceType: .htmlString, url: nil, dataSource: nil)
    }
    
    public convenience init(url: URL) {
        self.init(sourceType: .url, url: url, dataSource: nil)
    }
    
    public convenience init(dataSource: WebViewDataSource) {
        self.init(sourceType: .dataSource, url: nil, dataSource: dataSource)
    }
    
    private init(sourceType: WebSourceType, url: URL?, dataSource: WebViewDataSource?) {
        self.sourceType = sourceType
        self.baseURL = url
        self.dataSource = dataSource
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- ViewController Life Cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
        loadWebView()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isModal {
            let closeItem = UIBarButtonItem(
                image: UIImage(named: "close-mono"),
                style: .done, target: self,
                action: #selector(closedButtonTapped(_:))
            )
            navigationItem.leftBarButtonItem = closeItem
        }
        
        self.tabBarController?.tabBar.isHidden = true
        navigationItem.largeTitleDisplayMode = .never
    }
    
    //MARK:- Helpers
    func setupScene() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
//        if let totalPoints = STAppManager.shared.userAccount?.totalPoints {
//            navigationItem.rightBarButtonItem = TripCoinBarButtonItem.createWithText(totalPoints.withCommas())
//        }
        
        view.backgroundColor = .white
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        // add activity
        webView.navigationDelegate = self
        activityIndicator.center = self.view.center
        webView.addSubview(activityIndicator)
        showActivityIndicator(show: true)
    }
    
    func loadWebView() {
        
        switch sourceType! {
        case .htmlString:
            if let htmlString = htmlString {
                webView.loadHTMLString(htmlString, baseURL: nil)
            }
        case .url:
            if let url = baseURL {
                webView.load(URLRequest(url: url))
            }
        case .staticHtmlFile:
            webView.loadHTMLString(htmlString!, baseURL: baseURL)
        case .dataSource:
            
            dataSource?.fetchWebData(completionHandler: { [weak self] (result) in
                guard let self = self else { return }
                switch result {
                case .success(let htmlContent):
                    self.webView.loadHTMLString(htmlContent, baseURL: nil)
                case .failure:
                    let errorMessageHtml = Helpers.generateHtml(content: "\(self.title ?? "Information") not found!")
                    self.webView.loadHTMLString(errorMessageHtml, baseURL: nil)
                }
            })
        }
    }
    
    // MARK: - Action
    @objc
    private func closedButtonTapped(_ sender: UIBarButtonItem){
        dismiss(animated: true, completion: nil)
    }
    
    func showActivityIndicator(show: Bool) {
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
}
//MARK:- WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showActivityIndicator(show: false)
        showAlert(message: error.localizedDescription)
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        showActivityIndicator(show: false)
    }

}
