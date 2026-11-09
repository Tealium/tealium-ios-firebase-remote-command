# Tealium Firebase

[![License](https://img.shields.io/badge/license-Proprietary-blue.svg?style=flat
           )](https://github.com/Tealium/tealium-swift/blob/master/LICENSE.txt)
[![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg?style=flat
             )](https://developer.apple.com/resources/)

## Documentation
For full documentation, please see the Tealium Learning Community: 

[https://docs.tealium.com/platforms/remote-commands/integrations/firebase/](https://docs.tealium.com/platforms/remote-commands/integrations/firebase/)

## Installation

TealiumFirebase 5.0.0 and later depends on Firebase 13, which is no longer distributed through CocoaPods. It is available through Swift Package Manager and Carthage only, and requires Xcode 26.2 or later.

**Swift Package Manager**

Add `https://github.com/Tealium/tealium-ios-firebase-remote-command` as a package dependency and select the `TealiumFirebase` product.

**XCFramework / Carthage**

Download `tealium.xcframework.zip` from the GitHub release. It must be used alongside the Firebase 13 and `tealium-swift` frameworks, which this repo's `Cartfile` resolves:

```
github "tealium/tealium-swift" ~> 2.18
binary "https://dl.google.com/dl/firebase/ios/carthage/FirebaseAnalyticsBinary.json" ~> 13.0
```

> **CocoaPods users:** versions 4.x continue to work with Firebase 12 (`~> 12.0`), but are not updated with Firebase 13. See the Firebase [CocoaPods deprecation guide](https://firebase.google.com/docs/ios/cocoapods-deprecation) for details.

## Example

Navigate to TealiumFirebaseExample project and delete the file titled _REPLACE-ME.md_. Replace this file with the _GoogleService-Info.plist_ from your Firebase Console. Information about how to retrieve this file is located [here](https://firebase.google.com/docs/ios/setup#add-config-file).

## License

Use of this software is subject to the terms and conditions of the license agreement contained in the file titled [LICENSE.txt](LICENSE.txt). Please read the license before downloading or using any of the files contained in this repository. By downloading or using any of these files, you are agreeing to be bound by and comply with the license agreement.

___

Copyright (C) 2012-2019, Tealium Inc.

