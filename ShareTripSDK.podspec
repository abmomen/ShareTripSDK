Pod::Spec.new do |spec|

  spec.name         = "ShareTripSDK"
  spec.version      = "1.0.0"
  spec.summary      = "Project holds the sharetrip sdk for distribution."
  spec.homepage     = "https://sharetrip.net"

  spec.author             = { "Abdul Momen" => "abdulmomen130@gmail.com" }
  
  spec.platform     = :ios
  spec.swift_version = "5.0"
  spec.ios.deployment_target = "11.0"

  spec.source       = { :git => "http://EXAMPLE/ShareTripSDK.git", :tag => "#{spec.version}" }

  spec.dependency "JSONKit", "~> 1.4"

end
