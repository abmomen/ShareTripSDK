//
//  STAppManager.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/29/22.
//

import UIKit
import FirebaseRemoteConfig

public class STAppManager {
    public static let shared = STAppManager()

    //declare this property where it won't go out of scope relative to your listener
    public let reachability: Reachability!
    public var offlineVC: OfflineVC?

    //MARK: Stored Property
    public var userAccount: STUserAccount?
    public var popularCity: CityProperty?
    public var popularCities: [STCity] = []
    public var popularAirports: [Airport] = []
    public var isNotificationEnabled = false

    //MARK: Firebase Remote Config
    //let remoteConfig = RemoteConfig.remoteConfig()

    private init() {
        //Do some initialization
        self.reachability = try! Reachability()
    }

    // MARK:- App Version
    private var updateAppAlertDiplayedOnce: Bool = false
    private var updateAppAlertDate: Date? {
        get {
            return UserDefaults.standard.object(forKey: Constants.App.updateAppAlertDate) as? Date
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: Constants.App.updateAppAlertDate)
            defaults.synchronize()
        }
    }


    public func setupRemoteConfigDefaults() {
        RemoteConfig.remoteConfig().setDefaults(fromPlist: "RemoteConfigDefaults")
    }

    private func fetchAppVersionFromRemoteConfig(onCompletion: @escaping (String, Int64, Bool) -> Void) {
        let remoteConfig = RemoteConfig.remoteConfig()
        setupRemoteConfigDefaults()

        remoteConfig.fetch { (status, error) -> Void in
            if status == .success {
                remoteConfig.activate { (_, error) in
                    if let error = error {
                        STLog.error(error.localizedDescription)
                    }
                }

                let ios_app_version = remoteConfig[Constants.RemoteConfigKey.ios_app_version].stringValue ?? ""
                let app_update_alert_hour = RemoteConfig.remoteConfig()[Constants.RemoteConfigKey.app_update_alert_hour].numberValue
                let ios_force_update_enabled = remoteConfig[Constants.RemoteConfigKey.ios_force_update_enabled].boolValue
                onCompletion(ios_app_version, app_update_alert_hour.int64Value , ios_force_update_enabled)
            } else if let error = error {
                STLog.error(error.localizedDescription)
            }
        }
    }

    private func isCurrentVersionOutdated(currentVersionString: String, latestVersionString: String) -> Bool {
        var currentVersionComponents = currentVersionString.components(separatedBy: ".").map {Int($0) ?? 0}
        var latestversionComponents = latestVersionString.components(separatedBy: ".").map {Int($0) ?? 0}

        // Make equal length
        while currentVersionComponents.count < latestversionComponents.count { currentVersionComponents.append(0) }
        while latestversionComponents.count < currentVersionComponents.count { latestversionComponents.append(0) }

        var currentVersion = 0
        var latestVersion = 0
        for i in 0..<currentVersionComponents.count {
            currentVersion = currentVersion * 10 + currentVersionComponents[i]
            latestVersion = latestVersion * 10 + latestversionComponents[i]
        }

        return currentVersion < latestVersion
    }

    private var remoteConfigAppVersion: String?
    private var minimumWaitHourThreshold: Int64?
    private var forceUpdateEnabled: Bool = false
    public func checkAppVersion() {
        guard let currentVersionString = Bundle.main.infoDictionary?[Constants.App.bundleShortVersionString] as? String else { return }
        if let latestVersion = remoteConfigAppVersion,
           let waitThreshold = minimumWaitHourThreshold {
            if let lastAlertDisplayTime = updateAppAlertDate {
                let passedHour = Date().since(lastAlertDisplayTime, in: .hour)
                if passedHour < waitThreshold && !forceUpdateEnabled {
                    return
                }
            }
            guard forceUpdateEnabled || !updateAppAlertDiplayedOnce else { return }
            guard isCurrentVersionOutdated(currentVersionString: currentVersionString, latestVersionString: latestVersion) else { return }
            showAppUpdateAlert()
        } else {
            fetchAppVersionFromRemoteConfig() { [weak self] remoteConfigAppVersion, minimumWaitHourThreshold, forceUpdateEnabled in
                self?.remoteConfigAppVersion = remoteConfigAppVersion
                self?.minimumWaitHourThreshold = minimumWaitHourThreshold
                self?.forceUpdateEnabled = forceUpdateEnabled
                self?.checkAppVersion()
            }
        }
    }

    private var appUpdateAlert: UIAlertController?
    private func showAppUpdateAlert() {
        guard appUpdateAlert == nil else { return }
        appUpdateAlert = {
            let alert = UIAlertController(title: "Update App", message: "You are using an older version of this app. Please update else some options may not work properly!", preferredStyle: .alert)

            let updateAction = UIAlertAction(title: "Update", style: .default, handler: { [weak self] _ in
                self?.appUpdateAlert = nil
                guard let url = URL(string: Constants.App.appStoreURL) else { return }
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak self] _ in
                self?.appUpdateAlert = nil
            })

            alert.addAction(updateAction)
            if !forceUpdateEnabled {
                alert.addAction(cancelAction)
            }

            alert.modalPresentationStyle = .fullScreen

            return alert
        }()

        updateAppAlertDiplayedOnce = true
        updateAppAlertDate = Date()
        UIApplication.topViewController?.present(appUpdateAlert!, animated: true, completion: nil)
    }

    public func fetchFlightSearchDayOffset() {
        let remoteConfig = RemoteConfig.remoteConfig()
        STAppManager.shared.setupRemoteConfigDefaults()
        remoteConfig.fetch { (status, error) -> Void in
            if status == .success {
                remoteConfig.activate { (_, error) in
                    if let error = error {
                        STLog.error(error.localizedDescription)
                    }
                }

                if let thresholdTimeStr = remoteConfig[Constants.RemoteConfigKey.flight_search_threshold_time].stringValue {
                    if let date = Date(fromString: thresholdTimeStr, format: DateFormatType.custom("HH:mm")) {
                        let hour = date.component(.hour) ?? 0
                        let minute = date.component(.minute) ?? 0
                        let thresholdTimeInMinute = hour*60 + minute
                        let userDefault = UserDefaults.standard
                        userDefault.set(thresholdTimeInMinute, forKey: Constants.RemoteConfigKey.flight_search_threshold_time)
                        userDefault.synchronize()
                    }
                }
            } else {
                STLog.error("Remote config error: \(error?.localizedDescription ?? "No error available.")")
            }
        }
    }

    //MARK: - User
    public var isUserLoggedIn : Bool {
        return STUserSession.current.isUserLoggedIn()
    }

    public func getUserInfo(completion:@escaping (Response<STUserAccount>?) -> Void) {
        DefaultAPIClient().getUserInfo { (result) in
            switch result {
            case .success(let response):
                if response.code == APIResponseCode.success, let user = response.response {
                    STAppManager.shared.userAccount = user
                } else {
                    STLog.error("Error: \(response.code) -> \(response.message)")
                }
                completion(response)
            case .failure(let error):
                STLog.error(error.localizedDescription)
                completion(nil)
            }
        }
    }

    public func updateUserInfoBy(adding tripCoin: Int, completion:((STUserAccount?) -> Void)? = nil) {
        guard let user = userAccount else {
            completion?(nil)
            return
        }
        user.totalPoints += Int64(tripCoin)
        user.redeemablePoints += Int64(tripCoin)
        completion?(user)
    }

    public var shareTripCoin: Int {
        return userAccount?.coinSettings?.referCoin ?? 50
    }

    //MARK: - Reachability
    public func startNotifyingReachability() {
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                STLog.info("Reachable via WiFi")
            } else {
                STLog.info("Reachable via Cellular")
            }

            //Hide if it presenting
            if let offlineVC = self.offlineVC {
                self.offlineVC = nil
                offlineVC.dismiss(animated: true, completion: nil)
            }
        }

        reachability.whenUnreachable = { _ in
            STLog.warn("Not reachable")
            let offlineVC = OfflineVC()
            offlineVC.modalPresentationStyle = .fullScreen
            UIApplication.topViewController?.present(offlineVC, animated: false, completion: nil)
            self.offlineVC = offlineVC
        }

        do {
            try reachability.startNotifier()
        } catch {
            STLog.warn("Unable to start notifier")
        }
    }

    func stopNotifyingReachability() {
        reachability.stopNotifier()
    }

    //MARK: - Others
    public func hasAppAlreadyLaunchedOnce() -> Bool {
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: Constants.App.hasLaunchedOnce) {
            STLog.info("App already launched")
            return true
        } else {
            defaults.set(true, forKey: Constants.App.hasLaunchedOnce)
            STLog.info("App launched first time")
            return false
        }
    }

    public class func getCountryList() -> [Country] {
        if let url = Bundle.main.url(forResource:  "Countries", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(ResponseList<Country>.self, from: data)

                if let countries = jsonData.response {
                    return countries
                }
            } catch {
                STLog.error(error.localizedDescription)
                return []
            }
        }
        return []
    }
}

