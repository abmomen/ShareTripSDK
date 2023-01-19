#
# Be sure to run `pod lib lint ShareTripSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'ShareTripSDK'
    s.version          = '0.1.0'
    s.summary          = 'A Title name of ShareTripSDK.'
    
    # This description is used to generate tags and improve search results.
    #   * Think: What does it do? Why did you write it? What is the focus?
    #   * Try to keep it short, snappy and to the point.
    #   * Write the description between the DESC delimiters below.
    #   * Finally, don't worry about the indent, CocoaPods strips it!
    
    s.description      = <<-DESC
    
    TODO: will add long description.
    
    DESC
    
    s.homepage         = 'https://github.com/sharetrip-ios/ShareTripSDK'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'sharetrip-ios' => 'abdulmomen130@gmail.com' }
    s.source           = { :git => 'https://github.com/sharetrip-ios/ShareTripSDK.git', :tag => s.version.to_s }
    # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
    
    s.swift_version = '5.0'
    s.static_framework = true
    s.ios.deployment_target = '11.0'
    
    s.source_files = 'ShareTripSDK/Classes/**/*.{swift}'
    s.resource_bundles = { 'Resources' => ['ShareTripSDK/**/*.{storyboard,xib,xcassets}'] }
    
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
