#!/bin/bash

xcodebuild archive\
    -workspace Example/ShareTripSDK.xcworkspace\
    -scheme ShareTripSDK\
    -destination "generic/platform=iOS"\
    -archivePath "archives/ShareTripSDK"\
    SKIP_INSTALL=NO\
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES

xcodebuild archive\
    -workspace Example/ShareTripSDK.xcworkspace\
    -scheme ShareTripSDK\
    -destination "generic/platform=iOS Simulator"\
    -archivePath "archives/ShareTripSDK-Sim"\
    SKIP_INSTALL=NO\
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES\

xcodebuild -create-xcframework\
        -framework "archives/ShareTripSDK-Sim.xcarchive/Products/Library/Frameworks/ShareTripSDK.framework"\
        -framework "archives/ShareTripSDK.xcarchive/Products/Library/Frameworks/ShareTripSDK.framework"\
        -output "xcframeworks/ShareTripSDK.xcframework"
