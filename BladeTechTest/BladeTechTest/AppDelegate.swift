//
//  AppDelegate.swift
//  BladeTechTest
//
//  Created by Vladyslav Savonik on 12.09.2024.
//

import UIKit
import AppsFlyerLib
import AppTrackingTransparency

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        AppsFlyerLib.shared().appsFlyerDevKey = "<YOUR_DEV_KEY>"
        AppsFlyerLib.shared().appleAppID = "<APPLE_APP_ID>"
        AppsFlyerLib.shared().isDebug = false   //To Check if needed
        AppsFlyerLib.shared().waitForATTUserAuthorization(timeoutInterval: 60)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActiveNotification), name: UIApplication.didBecomeActiveNotification, object: nil)

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    @objc func didBecomeActiveNotification() {
        AppsFlyerLib.shared().start()
        ATTrackingManager.requestTrackingAuthorization { status in
            switch status {
            case .authorized:
                print("Authorized 200 ok")
            case .denied:
                print("Denied")
            case .notDetermined:
                print("Not Determined")
            case .restricted:
                print("Restricted")
            @unknown default:
                print("Unknown")
            }
        }

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
}
