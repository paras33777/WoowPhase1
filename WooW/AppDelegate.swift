//
//  AppDelegate.swift
//  WooW
//
//  Created by Rahul Chopra on 28/04/21.
// background color : #191919
// header color         : #343434

import UIKit
import IQKeyboardManagerSwift
import GoogleMobileAds
import OneSignal
import JioAdsFramework

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var orientationLock = UIInterfaceOrientationMask.portrait
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)
        OneSignal.initWithLaunchOptions(launchOptions)
        OneSignal.setAppId("")
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
//        JioAdSdk.setLogLevel(logLevel: .DEBUG)

        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
            return self.orientationLock
    }
}

//func applicationDidBecomeActive(_ application: UIApplication){
//    if #available(iOS 14, *) {
//        JioAdSdk.requestAppTrackingPermission { (status) in
//            if status != .authorized, let vendorStr = UIDevice.current.identifierForVendor?.uuidString {
//                JioAdSdk.setDeviceVendorId(vendorStr)
//            }
//            //..Publishere can use below line of code if authorization is denied
//            if status == .denied {
//                DispatchQueue.main.async {
//                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
//                }
//            }
//        }
//    } else {
//        // Fallback on earlier versions
//    }
//}
