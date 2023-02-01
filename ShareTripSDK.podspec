Pod::Spec.new do |s|
    s.name              = 'ShareTripSDK'
    s.version           = '1.0.0'
    s.summary           = 'ShareTripSDK'
    s.homepage          = 'https://github.com/abmomen/ShareTripSDK.git'
    s.source            = { :git => 'https://github.com/abmomen/ShareTripSDK.git', :tag => '1.0.0' }
    s.author            = { 'Abdul Momen' => 'abdulmomenict@gmail.com' }
    s.license           = { :type => "MIT", :text => "MIT License" }

    s.swift_version     = "5.0"
    s.license           = 'MIT'
    s.requires_arc      = true
    s.platform          = :ios, "11.0"
    s.vendored_frameworks = 'ShareTripSDK.xcframework'
    
    s.dependency 'JWT'
    s.dependency 'PKHUD'
    s.dependency 'Base64'
    s.dependency 'Koloda'
    s.dependency 'BlueECC'
    s.dependency 'BlueRSA'
    s.dependency 'Alamofire'
    s.dependency 'lottie-ios'
    s.dependency 'SwiftyJSON'
    s.dependency 'Kingfisher'
    s.dependency 'Bolts-Swift'
    s.dependency 'BlueCryptor'
    s.dependency 'FloatingPanel'
    s.dependency 'GoogleSignIn'
    s.dependency 'ImageSlideshow'
    s.dependency 'JTAppleCalendar'
    s.dependency 'SwiftKeychainWrapper'
    s.dependency 'Socket.IO-Client-Swift'
    s.dependency 'FBSDKCoreKit'
    s.dependency 'FBSDKLoginKit'
    s.dependency 'FBSDKShareKit'
    s.dependency 'FirebaseAuth'
    s.dependency 'FirebaseFirestore'
    s.dependency 'FirebaseAnalytics'
    s.dependency 'FirebaseMessaging'
    s.dependency 'FirebaseCrashlytics'
    s.dependency 'FirebaseRemoteConfig'
    s.dependency 'FirebaseDynamicLinks'
    s.dependency 'IQKeyboardManagerSwift'
    s.dependency 'FirebaseCoreDiagnostics'
end
