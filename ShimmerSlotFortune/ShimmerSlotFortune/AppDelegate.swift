//
//  AppDelegate.swift
//  ShimmerSlotFortune
//
//  Created by ShimmerSlot Fortune on 2025/3/11.
//

import UIKit
import FirebaseCore
import FirebaseMessaging
import AppsFlyerLib
import FBSDKCoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, AppsFlyerLibDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        configureFirebase()
        configureFacebook(with: application, launchOptions: launchOptions)
        configureAppsFlyer()
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

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // 将 APNs 设备 Token 传递给 Firebase Messaging
        Messaging.messaging().apnsToken = deviceToken
    }
    
    // MARK: - SDK Configuration Methods
    
    private func configureFirebase() {
        FirebaseApp.configure()
    }
    
    private func configureFacebook(with application: UIApplication,
                                   launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func configureAppsFlyer() {
        let appsFlyer = AppsFlyerLib.shared()
        appsFlyer.appsFlyerDevKey = UIViewController.shimmerGetAppsFlyerDevKey()
        appsFlyer.appleAppID = "6743111327"
        appsFlyer.waitForATTUserAuthorization(timeoutInterval: 51)
        appsFlyer.delegate = self
    }
    
    // MARK: - AppsFlyerLibDelegate Methods
    
    func onConversionDataSuccess(_ conversionInfo: [AnyHashable: Any]) {
        print("AppsFlyer conversion data success: \(conversionInfo)")
    }
    
    func onConversionDataFail(_ error: Error) {
        print("AppsFlyer conversion data error: \(error)")
    }
}

