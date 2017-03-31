## SmartAds with Swift
So you want to use SmartAds with Swift?  SmartAds is built on top of CocoaPods, and in order to use CocoaPods with Swift the `use_frameworks!` directive must be used.  This tells CocoaPods to build it's dependencies as dynamic frameworks, which are frameworks loaded at runtime.  This feature has been available since iOS 8 for Swift and ObjC projects.

If you follow our CocoaPods installation guide and then uncomment `use_frameworks!` the `pod update` (or `pod install`) process will fail complaining about 'transitive dependencies'.  This is because our `DeltaDNAAds` pod has dependencies on 3rd party pods which aren't built as dynamic frameworks.  For open source projects this isn't a problem since we can recompile the code, but many ad networks provide what is called a 'static framework', which is just the headers and object code.  The problem is improving as the ad networks move their code over to the new format, but often they have been slow because they want to main backwards compatability with iOS 7.  There is a table at the end of our SDK [README](https://github.com/deltaDNA/ios-smartads-sdk/blob/master/README.md#ios-10) which lists network feature support.

A workaround is to create a new dynamic framework that contains all our DeltaDNA code plus the ad network dependencies, known as an umbrella framework.  [Apparently](http://stackoverflow.com/questions/34681435/how-to-add-a-framework-inside-another-framework-umbrella-framework) these are discouraged by Apple so best look out for dragons!  I suspect the most likely problem would be accidently importing the same dependencies indirectly by different frameworks and the project not linking.

Below is a step by step guide, it assumes some basic familiarity with Xcode and CocoaPods.

1.  Open Xcode and create a new Cocoa Touch Framework.  Call it 'DeltaDNA' and set the language to Objective-C.

2.  From a terminal cd to the location of the new xcodeproj file and run `pod init`.

3.  Edit the Podfile as explained in the README to include the ad networks you require.  For example to only include AdMob and MoPub:

    ```ruby
    source 'https://github.com/deltaDNA/CocoaPods.git'
    source 'https://github.com/CocoaPods/Specs.git'

    platform :ios, '8.0'

    target 'DeltaDNA' do
      pod 'DeltaDNAAds', '~> 1.3.0', :subspecs => ['AdMob','MoPub']
    end
    ```

    Don't uncomment the `use_frameworks!` directive, we need CocoaPods to statically link the code into our new framework.  But set the platform to at least iOS 8 as ultimately we will use frameworks.

4.  Optionally add post install hooks to enable debug logging and disable bitcode.

    ```ruby
    post_install do |installer|
        installer.pods_project.targets.each do |target|
    	target.build_configurations.each do |config|
    	    # Enable extra logging
    	    if target.name == 'DeltaDNA' || target.name == 'DeltaDNAAds'
                config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)']
                config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] << 'DDNA_DEBUG=1'
            end
            # Disable bitcode
    	    config.build_settings['ENABLE_BITCODE'] = 'NO'
            end
        end
    end
    ```

5.  Run `pod update` and open the xcworkspace file in Xcode.

6.  Add the following header files from the DeltaDNA SDKs which CocoaPods downloaded.  Select the DeltaDNA target, then Build Phases -> Headers, click the + button followed by Add Other...:
    *   Pods/DeltaDNA/DeltaDNA/DDNASDK.h
    *   Pods/DeltaDNA/DeltaDNA/DDNASettings.h
    *   Pods/DeltaDNA/DeltaDNA/DDNAParams.h
    *   Pods/DeltaDNA/DeltaDNA/DDNAEvent.h
    *   Pods/DeltaDNA/DeltaDNA/DDNAProduct.h
    *   Pods/DeltaDNA/DeltaDNA/DDNATransaction.h
    *   Pods/DeltaDNA/DeltaDNA/DDNAEngagement.h
    *   Pods/DeltaDNA/DeltaDNA/DDNAImageMessage.h
    *   Pods/DeltaDNAAds/DeltaDNAAds/SmartAds/DDNASmartAds.h
    *   Pods/DeltaDNAAds/DeltaDNAAds/SmartAds/DDNAInterstitialAd.h
    *   Pods/DeltaDNAAds/DeltaDNAAds/SmartAds/DDNARewardedAd.h

7.  Select each of the added header files in the project pane, then in the right hand pane under Target Membership change the file visibilty from 'Project' to 'Public'.

8.  Next add those files as import statements into the framework header file DeltaDNA.h.  You should end up with:

    ```objc
    #import <UIKit/UIKit.h>

    //! Project version number for DeltaDNA.
    FOUNDATION_EXPORT double DeltaDNAVersionNumber;

    //! Project version string for DeltaDNA.
    FOUNDATION_EXPORT const unsigned char DeltaDNAVersionString[];

    // In this header, you should import all the public headers of your framework using statements like #import <DeltaDNA/PublicHeader.h>

    #ifndef _DELTADNA_
    #define _DELTADNA_

    #import <DeltaDNA/DDNASDK.h>
    #import <DeltaDNA/DDNASettings.h>
    #import <DeltaDNA/DDNAParams.h>
    #import <DeltaDNA/DDNAEvent.h>
    #import <DeltaDNA/DDNAProduct.h>
    #import <DeltaDNA/DDNATransaction.h>
    #import <DeltaDNA/DDNAEngagement.h>
    #import <DeltaDNA/DDNAImageMessage.h>
    #import <DeltaDNA/DDNASmartAds.h>
    #import <DeltaDNA/DDNAInterstitialAd.h>
    #import <DeltaDNA/DDNARewardedAd.h>

    #endif /* _DELTADNA_ */
    ```

9.  Add a new empty file called 'module.modulemap' to the framework project.  Put the following in it:

    ```ruby
    framework module DeltaDNA {
        umbrella header "DeltaDNA.h"

        export *
        module * { export * }

    }
    ```
    Under the target's Build Settings -> Module Map File enter the path to the module map: `DeltaDNA/module.modulemap`.

10. If you've disabled Bitcode for your CocoaPod dependencies you'll also want to disabled for the framework.  Disable it from the framework under Build Settings -> Enable Bitcode and set the value to 'NO'.

11. At this point the framework can be added as an _embedded binary_ in your swift project, or you could archive the framework for more complex builds.  If archiving, this [article](https://eladnava.com/publish-a-universal-binary-ios-framework-in-swift-using-cocoapods/) explains how to make a fat binary that supports both device and simulator architectures.  When adding the framework to a swift project you have to create a bridging header since the framework is in Objective-C.  To do this add a new header file called 'Bridging-Header.h', then an import startment for DeltaDNA framework's umbrella header:

    ```objc
    #ifndef Bridging_Header_h
    #define Bridging_Header_h

    #import <DeltaDNAAds/DeltaDNAAds.h>

    #endif /* Bridging_Header_h */
    ```

    Afterward you can add `import DeltaDNA` to your swift file and continue to integrate the SDK.
