//
//  AppStoreReviewManager.swift
//  ShareTrip
//
//  Created by Mehedi Hasan on 27/4/20.
//  Copyright © 2020 ShareTrip. All rights reserved.
//

import StoreKit

public enum AppStoreReviewManager {
    
    public static let productURL = URL(string: "https://itunes.apple.com/app/id\(Constants.App.appId)")!
    public static let minimumReviewWorthyActionCount = 5
    
    public static func requestReviewIfAppropriate(host: UIViewController?, force: Bool = false) {
        let defaults = UserDefaults.standard
        let bundle = Bundle.main
        
        var actionCount = defaults.integer(forKey: .reviewWorthyActionCount)
        actionCount += 1
        defaults.set(actionCount, forKey: .reviewWorthyActionCount)
        
        if !force {
            guard actionCount >= minimumReviewWorthyActionCount else {
                return
            }
        }
        
        let bundleVersionKey = kCFBundleVersionKey as String
        let currentVersion = bundle.object(forInfoDictionaryKey: bundleVersionKey) as? String
        let lastVersion = defaults.string(forKey: .lastReviewRequestAppVersion)
        
        guard lastVersion == nil || lastVersion != currentVersion else {
            return
        }
        
        var shownCount = defaults.integer(forKey: .reviewRequestShownCount)
        if shownCount == 0 {
            defaults.set(Date(), forKey: .reviewRequestFirstShown)
        } else if let firstShownDate = defaults.date(forKey: .reviewRequestFirstShown) {
            //check if it has passed 365 days
            ///No matter how many times you request the review prompt, the system will show the prompt a maximum of three times in a 365-day period.
            let date = Date().since(firstShownDate, in: .day)
            if date > 365 {
                shownCount = 0
                defaults.set(Date(), forKey: .reviewRequestFirstShown)
            }
        }
        
        if #available(iOS 10.3, *), shownCount < 3 {
            if force {
                SKStoreReviewController.requestReview()
            } else {
                let alertController = getRatingAlert { action in
                    SKStoreReviewController.requestReview()
                }
                host?.present(alertController, animated: true, completion: nil)
            }
        } else {
            let alertController = getRatingAlert { action in
                rateAppWithAppStore()
            }
            host?.present(alertController, animated: true, completion: nil)
        }
        
        defaults.set(shownCount+1, forKey: .reviewRequestShownCount)
        defaults.set(0, forKey: .reviewWorthyActionCount)
        defaults.set(currentVersion, forKey: .lastReviewRequestAppVersion)
    }
    
    private static func getRatingAlert(rateActionHandler: ((UIAlertAction) -> Void)?) -> UIAlertController {
        let message = "How was your experience with the ShareTrip App? Please take a moment to send your thoughts."
        let alertController = UIAlertController(title: "Share Your Experience", message: message, preferredStyle: .alert)
        
        let rateAction = UIAlertAction(title: "Rate ShareTrip", style: .default, handler: rateActionHandler)
        let laterAction = UIAlertAction(title: "Remind me later", style: .default) { action in
            //UsageDataManager.shared.saveReminderRequestDate()
        }
        
        let cancelAction = UIAlertAction(title: "No, thanks", style: .cancel, handler: nil)
        
        alertController.addAction(rateAction)
        alertController.addAction(laterAction)
        alertController.addAction(cancelAction)
        alertController.preferredAction = rateAction
        
        return alertController
    }
    
    public static func rateAppWithAppStore() {
        var components = URLComponents(url: AppStoreReviewManager.productURL, resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "action", value: "write-review")
        ]
        guard let writeReviewURL = components?.url else { return }
        UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
    }
    
    private func share(host: UIViewController?) {
        let activityViewController = UIActivityViewController(activityItems: [AppStoreReviewManager.productURL],
                                                              applicationActivities: nil)
        host?.present(activityViewController, animated: true, completion: nil)
    }
}
