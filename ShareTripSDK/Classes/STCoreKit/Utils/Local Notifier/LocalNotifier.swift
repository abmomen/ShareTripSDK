//
//  LocalNotifier.swift
//  ShareTrip
//
//  Created by ST-iOS on 11/24/21.
//  Copyright © 2021 ShareTrip. All rights reserved.
//

import UserNotifications

public class LocalNotifier {
    public func scheduleNotification(title: String, subtitle: String, dateComponent: DateComponents, repeats: Bool = false) {
        if STAppManager.shared.isNotificationEnabled {
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = subtitle
            content.sound = UNNotificationSound.default
            
            let userInfo = ["alert" : ["title" : title, "body": subtitle, "isLocal": true]]
            content.userInfo = ["aps": userInfo]
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: repeats)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.add(request)
        } else {
            STLog.info("Notification Disabled")
        }
    }
    
    public func scheduleNotification(title: String, subtitle: String, timeInterval: TimeInterval, repeats: Bool = false) {
        if STAppManager.shared.isNotificationEnabled {
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = subtitle
            content.sound = UNNotificationSound.default
            
            let userInfo = ["alert" : ["title" : title, "body": subtitle, "isLocal": true]]
            content.userInfo = ["aps": userInfo]

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: repeats)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.add(request)
        } else {
            STLog.info("Notification Disabled")
        }
    }
}
