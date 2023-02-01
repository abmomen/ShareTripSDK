# ShareTripSDK

Requirements:
 - Cocoapods
 - iOS 11.0 or higher
 - Swift 5.0 or higher
 - ShareTrip AccessToken
 - GoodleService-Info file.
 - Camera Access Descriptions.
 
## How to Install: 

In your ```Podfile``` add following pod

```
pod 'ShareTripSDK', :git => 'https://github.com/abmomen/ShareTripSDK.git', :tag => '1.0.0'

```
Add ```use_frameworks!``` in your ```Podfile``` if not added before.

After all add the following in your ```Podfile```

```
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
    end
  end
end

```

How to use:

After getting the access token provided by ShareTrip auth API. just ```import ShareTripSDK``` from your ViewController File.
And initate the sdk as follows.

```
STSDK.initiate("accestoken")

``` 
After that you can use Create the view controller specifically created for Banglalink like this

```
navigationController?.pushViewController(MyBLHomeVC.instantiate(), animated: true)

```

