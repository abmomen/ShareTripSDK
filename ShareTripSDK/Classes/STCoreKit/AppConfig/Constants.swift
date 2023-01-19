//
//  Constants.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/20/22.
//

import UIKit

public struct Constants {
    public struct DevelopmentServer {
        public static let baseURL = App.infoForKey("BaseURL") ?? "https://api.sharetrip.net/api/v1"
        public static let stAccess = "362AC8ED9FABC0EFFEA1B8494DC6AC0D5E24CFA7"
    }
    
    public struct ProductionServer {
        public static let baseURL = App.infoForKey("BaseURL") ?? "https://api.sharetrip.net/api/v1"
        public static let stAccess = "362AC8ED9FABC0EFFEA1B8494DC6AC0D5E24CFA7"
    }
    
    public struct App {
        public static let appId = "1469335892"
        
        public static let minLoadingAnimationTime = 1.5
        public static let totalStars = 5
        public static let minCostForPlayingWheel = 50
        
        public static let hasLaunchedOnce = "HasLaunchedOnce"
        public static let updateAppAlertDate = "UpdateAppAlertDate"
        public static let treasureBoxWaitTime = "TreasureBoxWaitTime"
        public static let treasureBoxEarnTime = "TreasureBoxEarnTime"
        
        public static let dateFormat = "dd-MM-yyyy"
        public static let timeFormat = "hh:mm a"
        public static let dateTimeFormat = "dd-MM-yyyy hh:mm a"
    
        public static let supportMail = "ask@sharetrip.net"
        public static let supportPhone = "+8809617617617"
        
        public static let officeName = "ShareTrip Ltd"
        public static let officialSlogan = "ShareTrip - Travel App for All!"
        public static let officeLat = 23.79325
        public static let officeLong = 90.40905
        
        public static let edgeConstant: CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 32 : 16
        public static let alertWidthMaxConstant: CGFloat = 400.0
        
        public static let appStoreURL = "itms-apps://itunes.apple.com/app/bars/id" + appId
        public static let loyaltyTabIndex = 4
        public static let accountTabIndex = 4
        
        public static let appShortURL = "http://bit.ly/stappinc"
        public static let appStoreShortURL = "https://apple.co/2Y0DdLx"
        public static let playStoreShortURL = "http://bit.ly/2y60Wun"
        
        public static let bundleShortVersionString = "CFBundleShortVersionString"
        
        public static let ciriumAppID = "6b242e30"
        public static let ciriumAppKey = "51417b79b58762acfcd3cebc4cc082e1"
        public static let crispWebsiteID = "14009585-79af-47ed-ab9a-4b2d8133a3bd"
        
        public static let googleClientID = "346164418203-favej5b952470iif88o4qkf4o2p2741c.apps.googleusercontent.com"
        
        public static func getReferralMessage(referralCode: String) -> String {
            //return "Hi, check out the ShareTrip App! The easiest way to book all your travel services! Use my referral code '\(referralCode)' and also win air tickets and many more. Click to download Android \(playStoreShortURL) or iOS \(appStoreShortURL) app now"
            return "Hello, check out the ShareTrip App! The easiest way to book all your travel services! Use my referral code '\(referralCode)' and you will have the chance to  win free air tickets and many more. Click to download ShareTrip app now \(appShortURL)"
        }
        
        public static func getShareMessage() -> String {
            return "Hi, check out the new ShareTrip App! The easiest way to book all your travel services! You can also win air tickets and many more. Click to download ShareTrip app now \(appShortURL)"
        }
        
        public static func getQuizScoreShareMessage(score: Double) -> String {
            return "Hey, I have scored \(score) points on the new Travel Trivia quiz on ShareTrip App. Score more and win exciting gifts every week. Click to download ShareTrip app now \(appShortURL)"
        }
        
        public static func infoForKey(_ key: String) -> String? {
            return (Bundle.main.infoDictionary?[key] as? String)?
                .replacingOccurrences(of: "\\", with: "")
        }
        
        public static let bankDiscountPromoGenericText = "*Instant discount for our partner banks' card holders"
        
    }
    
    public struct RemoteConfigKey {
        public static let plist_file_name = "RemoteConfigDefaults"
        public static let ios_force_update_enabled = "ios_force_update_enabled"
        public static let ios_app_version = "ios_app_version"
        public static let app_update_alert_hour = "app_update_alert_hour"
        public static let app_loyalty = "app_loyalty"
        public static let flight_discount_offer_bank_list = "flight_discount_offer_bank_list"
        public static let flight_discount_options = "flight_discount_options"
        public static let hotel_discount_options = "hotel_discount_options"
        public static let flight_search_threshold_time = "flight_search_threshold_time"
        public static let hotel_discount_offer_bank_list = "hotel_discount_offer_bank_list"
        public static let quiz_homepage_promotion_text = "quiz_homepage_promotion_text"
        public static let quiz_termAndConditions = "quiz_term_and_condition"
        public static let cirium_appId = "cirium_appId"
        public static let cirium_appKey = "cirium_appKey"
        public static let travelAdvice_termAndConditions = "travel_advice_term_and_condition"
        public static let dealsUrlFromRemoteConfig = "notification_url"
        public static let success_urls = "success_urls"
        public static let crisp_websiteID = "crisp_website_id"
    }
    
    public struct APIParameterKey {
        public static let keyword = "keyword"
        public static let name = "name"
        public static let limit = "limit"
        public static let offset = "offset"
        public static let currency = "currency"
        public static let nationality = "nationality"
        public static let cityCodes = "cityCodes"
        public static let filterBy = "filterBy"
        public static let userID = "userId"
        
        public static let city = "city"
        
        public static let checkin = "checkin"
        public static let checkout = "checkout"
        public static let rooms = "rooms"
        public static let propertyCode = "propertyCode"
        public static let searchCode = "searchCode"
        public static let roomSearchCode = "roomSearchCode"
        public static let propertyRoomId = "propertyRoomId"
        
        public static let sort = "sort"
        public static let hotelName = "hotelName"
        public static let location = "location"
        public static let distance = "distance"
        
        public static let priceRange = "priceRange"
        public static let rating = "rating"
        public static let starRating = "starRating"
        public static let propertyType = "propertyType"
        public static let meals = "meals"
        public static let amenities = "amenities"
        public static let neighborhood = "neighborhood"
        public static let pointOfInterest = "point_of_interest"
        
        public static let hotelId = "hotelId"
        public static let roomIds = "roomIds"
        
        public static let token = "token"
        public static let facebookToken = "facebookToken"
        public static let appleToken = "token"
        public static let password = "password"
        public static let oldPassword = "oldPassword"
        public static let newPassword = "newPassword"
        public static let email = "email"
        public static let mobileNumber = "mobileNumber"
        public static let referralCode = "referralCode"
        
        public static let titleName = "titleName"
        public static let givenName = "givenName"
        public static let surName = "surName"
        public static let address1 = "address1"
        public static let postCode = "postCode"
        public static let gender = "gender"
        public static let dateOfBirth = "dateOfBirth"
        public static let passportExpireDate = "passportExpireDate"
        public static let passportNumber = "passportNumber"
        public static let country = "country"
        
        public static let passportCopy = "passportCopy"
        public static let visaCopy = "visaCopy"
        public static let frequentFlyerNumber = "frequentFlyerNumber"
        public static let mealPreference = "mealPreference"
        public static let wheelChair = "wheelChair"
        
        public static let quickPick = "quickPick"
        
        public static let uploadFile = "uploadFile"
        
        public static let cityCode = "cityCode"
        public static let wantToVisit = "wantToVisit"
        public static let bookingCode = "bookingCode"
        public static let type = "type"
        public static let value = "value"
        
        public static let code = "code"
        public static let voucherId = "voucherId"
        
        //Flight
        public static let tripType = "tripType"
        public static let adult = "adult"
        public static let child = "child"
        public static let infant = "infant"
        public static let flightClass = "class"
        public static let origin = "origin"
        public static let destination = "destination"
        public static let depart = "depart"
        public static let query = "query"
        
        public static let filter = "filter"
        public static let page = "page"
        public static let searchId = "searchId"
        public static let sequenceCode = "sequenceCode"
        public static let extraParams = "extraParams"
        public static let providerCode = "providerCode"
        public static let coupon = "coupon"
        public static let serviceType = "serviceType"
        public static let deviceType = "deviceType"
        public static let service = "service"
        public static let productCode = "productCode"
        
        public static let ciriumAppIDParameter = "appId"
        public static let ciriumAppKeyParameter = "appKey"
        public static let maxPositionParameter = "maxPositions"
        
    }
    
    public struct APIConstants {
        public static let adult = "Adult"
        public static let limit = "limit"
        public static let offset = "offset"
        
    }
    
    public struct FlightConstants {
        public static let flightSearchingDateOffset = 0 // changed the value to 0 from 1 enabling current date flight search.
        public static let thresholdTimeInMinute = 22*60
    }
    
    public struct HotelRoom {
        public static let maxRoom = 4
        
        public static let maxPersonPerRoom = 6
        public static let maxAdultPerRoom = 4
        public static let maxChildrenPerRoom = 2
        
        public static let minPersonPerRoom = 1
        public static let minAdultPerRoom = 1
        public static let minChildrenPerRoom = 0
    }
    
    public struct PaymentConstants {
        public static let successUrl = "https://sharetrip.net/profile?route=bookings"
        public static let failedUrl = "https://sharetrip.net/?type=failed"
    }
    
    public struct UserDefaultKey {
        public static let lastQuizOpeningTime = "sharetrip.quiz.last_open_time"
    }
}

public enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case accessToken = "accesstoken"
    case userAgent = "User-Agent"
    case stAccess = "st-access"
    case travelAdviceAPIAccessToken = "X-Access-Token"
}

public enum ContentType: String {
    case json = "application/json"
    case multipartFormData = "multipart/form-data"
}

public enum APIResponseCode: String, Codable {
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
    
    public init(from decoder: Decoder) throws {
        let stringValue = try decoder.singleValueContainer().decode(String.self)
        //let uppercasedValue = stringValue.uppercased()
        self = APIResponseCode(rawValue: stringValue.uppercased()) ?? .unknown
    }
    
    public init(stringValue: String) {
        self = APIResponseCode(rawValue: stringValue) ?? .unknown
    }
}

public enum AppError: Error {
    case validationError(String)
}
