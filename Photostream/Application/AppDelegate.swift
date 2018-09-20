//
//  AppDelegate.swift
//  Photostream
//
//  Created by Mounir Ybanez on 02/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit
import Firebase
import Fabric
import Crashlytics
import FBSDKCoreKit
import UserNotifications
import FirebaseMessaging
import DTLocalNotification
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    


    var window: UIWindow?
    var deviceToken: String = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        let dependency = AppDependency()
        dependency.appWireframe.window = window!
        dependency.attachRootViewControllerInWindow(window)

        Fabric.with([Crashlytics.self])
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: [:])
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        let body = ((userInfo["aps"] as! NSDictionary).object(forKey: "alert") as! NSDictionary).object(forKey: "body")
        let title = ((userInfo["aps"] as! NSDictionary).object(forKey: "alert") as! NSDictionary).object(forKey: "title")
        let view = NotificationView()
        view.lblTitle.text = title as? String
        view.lblContent.text = body as? String
        view.lblTime.text = "now"
        
        let notification = DTLocalNotification(view: view)
        
        notification.style.height = 100
        notification.style.leftInset = 10
        notification.style.rightInset = 10
        notification.style.topInset = 10
        
        DTInteractiveLocalNotificationPresenter.shared.showNotification(notification, completion: nil)
        completionHandler(UIBackgroundFetchResult.newData)
    }

}
