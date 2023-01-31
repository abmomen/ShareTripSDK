Pod::Spec.new do |spec|
    s.name              = 'ShareTripSDK'
    s.version           = '1.0.0'
    s.summary           = 'ST Spec'
    s.homepage          = 'https://www.sharetrip.net'

    s.author            = { 'Abdul Momen' => 'abdulmomenict@gmail.com' }
    s.license = { :type => "MIT", :text => "MIT License" }

    s.platform = :ios
    s.swift_version = "5.0"
    s.ios.deployment_target = '11.0'
    s.ios.vendored_frameworks = 'ShareTripSDK.xcframework'
    s.source = { :http => 'https://github.com/abmomen/ShareTripSDK/releases/download/1.0.0/ShareTripSDK.xcframework.zip' }
    
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
