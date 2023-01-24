//
//  Deals.swift
//  ShareTripSDK
//
//  Created by ST-iOS on 1/24/23.
//

import Foundation

struct DealResponse: Codable {
    let data: [NotifierDeal]
}

struct NotifierDeal: Codable {
    let comment, description, imageUrl: String?
    let platform: [Platform]?
    let publishDate, trigerBy, title: String?
    let timeStamp: TimeInterval?
}

enum Platform: String, Codable {
    case common = "COMMON"
    case ios = "iOS"
    case android = "ANDROID"
    
    case iosNotifier = "ios"
    case webNotifier = "web"
    case androidNotifier = "android"
    
    case iosDebug = "ios-debug"
    case androidDebug = "android-debug"
    case webDebug = "web-debug"
}


