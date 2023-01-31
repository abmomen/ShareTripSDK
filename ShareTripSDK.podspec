Pod::Spec.new do |spec|

  spec.name         = "ShareTripSDK"
  spec.version      = "1.0.0"
  spec.summary      = "Project holds the sharetrip sdk for distribution."
  spec.homepage     = "https://sharetrip.net"

  spec.author             = { "Abdul Momen" => "abdulmomen130@gmail.com" }
  
  spec.platform     = :ios
  spec.swift_version = "5.0"
  spec.ios.deployment_target = "11.0"

  spec.source       = { :http => "https://github.com/abmomen/ShareTripSDK/releases/download/1.0.0/ShareTripSDK.xcframework.zip"}
  
  spec.vendored_frameworks = "ShareTripSDK.xcframework"
  
  spec.dependency 'JWT'
  spec.dependency 'PKHUD'
  spec.dependency 'Base64'
  spec.dependency 'Koloda'
  spec.dependency 'BlueECC'
  spec.dependency 'BlueRSA'
  spec.dependency 'Alamofire'
  spec.dependency 'lottie-ios'
  spec.dependency 'SwiftyJSON'
  spec.dependency 'Kingfisher'
  spec.dependency 'Bolts-Swift'
  spec.dependency 'BlueCryptor'
  spec.dependency 'FloatingPanel'
  spec.dependency 'GoogleSignIn'
  spec.dependency 'ImageSlideshow'
  spec.dependency 'JTAppleCalendar'
  spec.dependency 'SwiftKeychainWrapper'
  spec.dependency 'Socket.IO-Client-Swift'
  spec.dependency 'FBSDKCoreKit'
  spec.dependency 'FBSDKLoginKit'
  spec.dependency 'FBSDKShareKit'
  spec.dependency 'FirebaseAuth'
  spec.dependency 'FirebaseFirestore'
  spec.dependency 'FirebaseAnalytics'
  spec.dependency 'FirebaseMessaging'
  spec.dependency 'FirebaseCrashlytics'
  spec.dependency 'FirebaseRemoteConfig'
  spec.dependency 'FirebaseDynamicLinks'
  spec.dependency 'IQKeyboardManagerSwift'
  spec.dependency 'FirebaseCoreDiagnostics'
  

end
