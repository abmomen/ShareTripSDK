//
//  Constants.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/20/22.
//

import UIKit

struct Constants {
    
    static var sdkColorTheme: SDKColorThemes = .sharetrip
    
    static var primaryColor: UIColor {
        return sdkColorTheme == .sharetrip ? stPrimaryColor : blPrimaryColor
    }
    
    private static var stPrimaryColor: UIColor {
        return UIColor(red: 24.0 / 255.0, green: 130.0 / 255.0, blue: 1.0, alpha: 1.0)
    }
    
    private static var blPrimaryColor: UIColor {
        return UIColor(red: 28/255.0, green: 175/255.0, blue: 104/255.0, alpha: 1.0)
    }
    
    struct DevelopmentServer {
        static let baseURL = App.infoForKey("BaseURL") ?? "https://api.sharetrip.net/api/v1"
        static let stAccess = "362AC8ED9FABC0EFFEA1B8494DC6AC0D5E24CFA7"
    }
    
    struct ProductionServer {
        static let baseURL = App.infoForKey("BaseURL") ?? "https://api.sharetrip.net/api/v1"
        static let stAccess = "362AC8ED9FABC0EFFEA1B8494DC6AC0D5E24CFA7"
    }
    
    struct App {
        static let appId = "1469335892"
        
        static let minLoadingAnimationTime = 1.5
        static let totalStars = 5
        static let minCostForPlayingWheel = 50
        
        static let hasLaunchedOnce = "HasLaunchedOnce"
        static let updateAppAlertDate = "UpdateAppAlertDate"
        static let treasureBoxWaitTime = "TreasureBoxWaitTime"
        static let treasureBoxEarnTime = "TreasureBoxEarnTime"
        
        static let dateFormat = "dd-MM-yyyy"
        static let timeFormat = "hh:mm a"
        static let dateTimeFormat = "dd-MM-yyyy hh:mm a"
    
        static let supportMail = "ask@sharetrip.net"
        static let supportPhone = "+8809617617617"
        
        static let officeName = "ShareTrip Ltd"
        static let officialSlogan = "ShareTrip - Travel App for All!"
        static let officeLat = 23.79325
        static let officeLong = 90.40905
        
        static let edgeConstant: CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 32 : 16
        static let alertWidthMaxConstant: CGFloat = 400.0
        
        static let appStoreURL = "itms-apps://itunes.apple.com/app/bars/id" + appId
        static let loyaltyTabIndex = 4
        static let accountTabIndex = 4
        
        static let appShortURL = "http://bit.ly/stappinc"
        static let appStoreShortURL = "https://apple.co/2Y0DdLx"
        static let playStoreShortURL = "http://bit.ly/2y60Wun"
        
        static let bundleShortVersionString = "CFBundleShortVersionString"
        
        static let ciriumAppID = "6b242e30"
        static let ciriumAppKey = "51417b79b58762acfcd3cebc4cc082e1"
        static let crispWebsiteID = "14009585-79af-47ed-ab9a-4b2d8133a3bd"
        
        static let googleClientID = "346164418203-favej5b952470iif88o4qkf4o2p2741c.apps.googleusercontent.com"
        
        static func getReferralMessage(referralCode: String) -> String {
            //return "Hi, check out the ShareTrip App! The easiest way to book all your travel services! Use my referral code '\(referralCode)' and also win air tickets and many more. Click to download Android \(playStoreShortURL) or iOS \(appStoreShortURL) app now"
            return "Hello, check out the ShareTrip App! The easiest way to book all your travel services! Use my referral code '\(referralCode)' and you will have the chance to  win free air tickets and many more. Click to download ShareTrip app now \(appShortURL)"
        }
        
        static func getShareMessage() -> String {
            return "Hi, check out the new ShareTrip App! The easiest way to book all your travel services! You can also win air tickets and many more. Click to download ShareTrip app now \(appShortURL)"
        }
        
        static func getQuizScoreShareMessage(score: Double) -> String {
            return "Hey, I have scored \(score) points on the new Travel Trivia quiz on ShareTrip App. Score more and win exciting gifts every week. Click to download ShareTrip app now \(appShortURL)"
        }
        
        static func infoForKey(_ key: String) -> String? {
            return (Bundle.main.infoDictionary?[key] as? String)?
                .replacingOccurrences(of: "\\", with: "")
        }
        
        static let bankDiscountPromoGenericText = "*Instant discount for our partner banks' card holders"
        
    }
    
    struct RemoteConfigKey {
        static let plist_file_name = "RemoteConfigDefaults"
        static let ios_force_update_enabled = "ios_force_update_enabled"
        static let ios_app_version = "ios_app_version"
        static let app_update_alert_hour = "app_update_alert_hour"
        static let app_loyalty = "app_loyalty"
        static let flight_discount_offer_bank_list = "flight_discount_offer_bank_list"
        static let flight_discount_options = "flight_discount_options"
        static let hotel_discount_options = "hotel_discount_options"
        static let flight_search_threshold_time = "flight_search_threshold_time"
        static let hotel_discount_offer_bank_list = "hotel_discount_offer_bank_list"
        static let quiz_homepage_promotion_text = "quiz_homepage_promotion_text"
        static let quiz_termAndConditions = "quiz_term_and_condition"
        static let cirium_appId = "cirium_appId"
        static let cirium_appKey = "cirium_appKey"
        static let travelAdvice_termAndConditions = "travel_advice_term_and_condition"
        static let dealsUrlFromRemoteConfig = "notification_url"
        static let success_urls = "success_urls"
        static let crisp_websiteID = "crisp_website_id"
    }
    
    struct APIParameterKey {
        static let keyword = "keyword"
        static let name = "name"
        static let limit = "limit"
        static let offset = "offset"
        static let currency = "currency"
        static let nationality = "nationality"
        static let cityCodes = "cityCodes"
        static let filterBy = "filterBy"
        static let userID = "userId"
        
        static let city = "city"
        
        static let checkin = "checkin"
        static let checkout = "checkout"
        static let rooms = "rooms"
        static let propertyCode = "propertyCode"
        static let searchCode = "searchCode"
        static let roomSearchCode = "roomSearchCode"
        static let propertyRoomId = "propertyRoomId"
        
        static let sort = "sort"
        static let hotelName = "hotelName"
        static let location = "location"
        static let distance = "distance"
        
        static let priceRange = "priceRange"
        static let rating = "rating"
        static let starRating = "starRating"
        static let propertyType = "propertyType"
        static let meals = "meals"
        static let amenities = "amenities"
        static let neighborhood = "neighborhood"
        static let pointOfInterest = "point_of_interest"
        
        static let hotelId = "hotelId"
        static let roomIds = "roomIds"
        
        static let token = "token"
        static let facebookToken = "facebookToken"
        static let appleToken = "token"
        static let password = "password"
        static let oldPassword = "oldPassword"
        static let newPassword = "newPassword"
        static let email = "email"
        static let mobileNumber = "mobileNumber"
        static let referralCode = "referralCode"
        
        static let titleName = "titleName"
        static let givenName = "givenName"
        static let surName = "surName"
        static let address1 = "address1"
        static let postCode = "postCode"
        static let gender = "gender"
        static let dateOfBirth = "dateOfBirth"
        static let passportExpireDate = "passportExpireDate"
        static let passportNumber = "passportNumber"
        static let country = "country"
        
        static let passportCopy = "passportCopy"
        static let visaCopy = "visaCopy"
        static let frequentFlyerNumber = "frequentFlyerNumber"
        static let mealPreference = "mealPreference"
        static let wheelChair = "wheelChair"
        
        static let quickPick = "quickPick"
        
        static let uploadFile = "uploadFile"
        
        static let cityCode = "cityCode"
        static let wantToVisit = "wantToVisit"
        static let bookingCode = "bookingCode"
        static let type = "type"
        static let value = "value"
        
        static let code = "code"
        static let voucherId = "voucherId"
        
        //Flight
        static let tripType = "tripType"
        static let adult = "adult"
        static let child = "child"
        static let infant = "infant"
        static let flightClass = "class"
        static let origin = "origin"
        static let destination = "destination"
        static let depart = "depart"
        static let query = "query"
        
        static let filter = "filter"
        static let page = "page"
        static let searchId = "searchId"
        static let sequenceCode = "sequenceCode"
        static let extraParams = "extraParams"
        static let providerCode = "providerCode"
        static let coupon = "coupon"
        static let serviceType = "serviceType"
        static let deviceType = "deviceType"
        static let service = "service"
        static let productCode = "productCode"
        
        static let ciriumAppIDParameter = "appId"
        static let ciriumAppKeyParameter = "appKey"
        static let maxPositionParameter = "maxPositions"
        
    }
    
    struct APIConstants {
        static let adult = "Adult"
        static let limit = "limit"
        static let offset = "offset"
        
    }
    
    struct FlightConstants {
        static let flightSearchingDateOffset = 0 // changed the value to 0 from 1 enabling current date flight search.
        static let thresholdTimeInMinute = 22*60
    }
    
    struct HotelRoom {
        static let maxRoom = 4
        
        static let maxPersonPerRoom = 6
        static let maxAdultPerRoom = 4
        static let maxChildrenPerRoom = 2
        
        static let minPersonPerRoom = 1
        static let minAdultPerRoom = 1
        static let minChildrenPerRoom = 0
    }
    
    struct PaymentConstants {
        static let successUrl = "https://sharetrip.net/profile?route=bookings"
        static let failedUrl = "https://sharetrip.net/?type=failed"
    }
    
    struct UserDefaultKey {
        static let lastQuizOpeningTime = "sharetrip.quiz.last_open_time"
    }
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case accessToken = "accesstoken"
    case userAgent = "User-Agent"
    case stAccess = "st-access"
    case travelAdviceAPIAccessToken = "X-Access-Token"
}

enum ContentType: String {
    case json = "application/json"
    case multipartFormData = "multipart/form-data"
}

enum APIResponseCode: String, Codable {
    case success = "SUCCESS"
    
    case emptyToken = "E_ACCESS_TOKEN_EMPTY"
    case invalidToken = "E_INVALID_TOKEN"
    case expiredToken = "E_TOKEN_EXPIRED"
    case error_validation = "E_VALIDATION_ERROR"
    case not_found = "E_NOT_FOUND"
    case coin_not_available = "E_COIN_NOT_AVAILABLE"
    
    case unknown = "E_UNKNOWN"
    
    // Flight price validation, this is a wrong way of sending price cange information, it should be a property in the json like "isPriceChanged": Bool, but it is done the way it is done, what can we do! : \;/
    case FLIGHT_PRICE_CHANGE = "PRICE_CHANGE"
    case FLIGHT_ITINERARY_CHANGE = "ITINERARY_CHANGE"
    case FLIGHT_RE_ITINERARY_CHANGE = "RE-ITINERARY_CHANGE"
    case FLIGHT_RE_VALIDATION_CHANGE = "RE-VALIDATION_CHANGE"
    
    init(from decoder: Decoder) throws {
        let stringValue = try decoder.singleValueContainer().decode(String.self)
        //let uppercasedValue = stringValue.uppercased()
        self = APIResponseCode(rawValue: stringValue.uppercased()) ?? .unknown
    }
    
    init(stringValue: String) {
        self = APIResponseCode(rawValue: stringValue) ?? .unknown
    }
}

enum AppError: Error {
    case validationError(String)
}
