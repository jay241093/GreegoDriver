//
//  AppDelegate.swift
//  Greegodriverapp
//
//  Created by Harshal Shah on 4/6/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import IQKeyboardManagerSwift
import Firebase
import UserNotifications
import SwiftyUserDefaults
import EVReflection
import Rswift
import SwiftyJSON
import Stripe
import FirebaseMessaging
import Bugsnag

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate, MessagingDelegate {
    
    var window: UIWindow?
    var bgtask = UIBackgroundTaskIdentifier(0)

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")

        Bugsnag.start(withApiKey: "05f4f3a3580c0c58df6c0b721a34b5b6")

        
        if UIApplication.shared.canOpenURL(URL(string: "waze://")!){
            print("found Waze")
            Defaults[.iswazeInstalled] = true
        }else{
            Defaults[.iswazeInstalled] = false
            
        }
        if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!){
            print("Found Maps")
            Defaults[.isGoogleMapsInstalled] = true

        }else{
            Defaults[.isGoogleMapsInstalled] = false

        }
        if launchOptions != nil {
            // opened from a push notification when the app is closed
            var userInfo = launchOptions![.remoteNotification] as? [AnyHashable: Any]
            if userInfo != nil {
                let dic: NSDictionary = userInfo as! NSDictionary

                if let aKey = userInfo?["aps"] {
                    let newdic: String = ((dic.value(forKey:"aps") as! NSDictionary).value(forKey: "alert") as! NSDictionary).value(forKey: "body") as! String
                    
                    if(newdic.contains("approved"))
                    {
                        NotificationCenter.default.post(name: NSNotification.Name.init("Approved"), object: nil, userInfo: dic as? [AnyHashable : Any])
                    }else if(newdic.contains("cancelled")){
                        print("Trip Canceled")
                        NotificationCenter.default.post(name: NSNotification.Name.init("cancelled"), object: nil, userInfo: dic as? [AnyHashable : Any])
                    }
                    else
                    {
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let navigationController:UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
                        let initialViewController = storyboard.instantiateViewController(withIdentifier: "RequestDriverVC") as! RequestDriverVC
                        
                        let jsonObj = JSON(userInfo)
                        
                        //        if jsonObj["request_id"] as Int !=
                        
                        let  requestID = jsonObj["request_id"].intValue
                        initialViewController.requestID = requestID
                        navigationController.pushViewController(initialViewController, animated: true)
                        self.window?.rootViewController = navigationController
                        self.window?.makeKeyAndVisible()
                        
                        
                      //  NotificationCenter.default.post(name: NSNotification.Name.init("Acceptnotification"), object: nil, userInfo: userInfo)
                        
                    }
                    


                }
            }
        } else {
            // opened app without a push notification.
        }

        
        IQKeyboardManager.shared.enable = true
        GMSServices.provideAPIKey("AIzaSyB5piHMK5i-knHurhZKxEP4pSErSHcH1YM")
        GMSPlacesClient.provideAPIKey("AIzaSyB5piHMK5i-knHurhZKxEP4pSErSHcH1YM")
        STPPaymentConfiguration.shared().publishableKey = "pk_test_6pRNASCoBOKtIshFeQd4XMUh"

        FirebaseApp.configure()
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        //        DispatchQueue.main.async {
        //            let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
        //            UIApplication.shared.registerUserNotificationSettings(settings)
        //            UIApplication.shared.registerForRemoteNotifications()
        //
        //        }
        //        return true
        // Override point for customization after application launch.
        return true
    }
    
    
    class noti: EVObject {
        var aps: String = ""
        var request_id: Int = 0
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        completionHandler(.newData)

        print(userInfo)
        let json = JSON(userInfo)
        print("as json")
        print(json)
        print("as Dictionary")
        print(userInfo as NSDictionary)
        
        let state:UIApplicationState = application.applicationState
        
        let dic: NSDictionary = userInfo as NSDictionary
        if(state == .active)
            
        {
            
            let newdic: String = ((dic.value(forKey:"aps") as! NSDictionary).value(forKey: "alert") as! NSDictionary).value(forKey: "body") as! String
            
            if(newdic.contains("approved"))
            {
                NotificationCenter.default.post(name: NSNotification.Name.init("Approved"), object: nil, userInfo: dic as! [AnyHashable : Any])
            }
            else if(newdic.contains("rejected"))
            {
                NotificationCenter.default.post(name: NSNotification.Name.init("Rejected"), object: nil, userInfo: dic as! [AnyHashable : Any])
                
                
            }
                
            else if(newdic.contains("cancelled")){
                print("Trip Canceled")
                NotificationCenter.default.post(name: NSNotification.Name.init("cancelled"), object: nil, userInfo: dic as! [AnyHashable : Any])
            }
            else
            {
                NotificationCenter.default.post(name: NSNotification.Name.init("Acceptnotification"), object: nil, userInfo: userInfo)
            }
            
        }
            
        else if state == .background{
            //PUSH desired view and post notification
            
            
            
//            let newdic: String = ((dic.value(forKey:"aps") as! NSDictionary).value(forKey: "alert") as! NSDictionary).value(forKey: "body") as! String
//
//            if(newdic.contains("approved"))
//            {
//                NotificationCenter.default.post(name: NSNotification.Name.init("Approved"), object: nil, userInfo: dic as! [AnyHashable : Any])
//            }else if(newdic.contains("cancelled")){
//                print("Trip Canceled")
//                NotificationCenter.default.post(name: NSNotification.Name.init("cancelled"), object: nil, userInfo: dic as! [AnyHashable : Any])
//            }
//            else
//            {
//
////                let storyboard = UIStoryboard(name: "Main", bundle: nil)
////                let navigationController:UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
////                let initialViewController = storyboard.instantiateViewController(withIdentifier: "RequestDriverVC") as! RequestDriverVC
////
////                let jsonObj = JSON(userInfo)
////
////                //        if jsonObj["request_id"] as Int !=
////
////                let  requestID = jsonObj["request_id"].intValue
////                initialViewController.requestID = requestID
////                navigationController.pushViewController(initialViewController, animated: true)
////                self.window?.rootViewController = navigationController
////                self.window?.makeKeyAndVisible()
//
//
//                NotificationCenter.default.post(name: NSNotification.Name.init("Acceptnotification"), object: nil, userInfo: userInfo)
//
//            }
//
//
//
//
            
            
        }
        
            
        else if (state == .inactive)
        {
            let newdic: String = ((dic.value(forKey:"aps") as! NSDictionary).value(forKey: "alert") as! NSDictionary).value(forKey: "body") as! String

            if(newdic.contains("approved"))
            {
                NotificationCenter.default.post(name: NSNotification.Name.init("Approved"), object: nil, userInfo: dic as! [AnyHashable : Any])


            }
            else if(newdic.contains("rejected"))
            {
                NotificationCenter.default.post(name: NSNotification.Name.init("Rejected"), object: nil, userInfo: dic as! [AnyHashable : Any])


            }

            else if(newdic.contains("cancelled")){
                print("Trip Canceled")
                NotificationCenter.default.post(name: NSNotification.Name.init("cancelled"), object: nil, userInfo: dic as! [AnyHashable : Any])
            }
            else
            {


//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let navigationController:UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
//                let initialViewController = storyboard.instantiateViewController(withIdentifier: "RequestDriverVC") as! RequestDriverVC
//                let jsonObj = JSON(userInfo)
//
//
//                let  requestID = jsonObj["request_id"].intValue
//                initialViewController.requestID = requestID
//                navigationController.pushViewController(initialViewController, animated: true)
//                self.window?.rootViewController = navigationController
//                self.window?.makeKeyAndVisible()

            NotificationCenter.default.post(name: NSNotification.Name.init("Acceptnotification"), object: nil, userInfo: userInfo)

            }



        }
    }
   

    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        //****************// receiving remote notification
//
//        print(userInfo)
//        let json = JSON(userInfo)
//        print("as json")
//        print(json)
//        print("as Dictionary")
//        print(userInfo as NSDictionary)
//
//        let state:UIApplicationState = application.applicationState
//
//        let dic: NSDictionary = userInfo as NSDictionary
//        if(state == .active)
//
//        {
//
//            let newdic: String = ((dic.value(forKey:"aps") as! NSDictionary).value(forKey: "alert") as! NSDictionary).value(forKey: "body") as! String
//
//            if(newdic.contains("approved"))
//            {
//                NotificationCenter.default.post(name: NSNotification.Name.init("Approved"), object: nil, userInfo: dic as! [AnyHashable : Any])
//            }
//            else if(newdic.contains("rejected"))
//            {
//                NotificationCenter.default.post(name: NSNotification.Name.init("Rejected"), object: nil, userInfo: dic as! [AnyHashable : Any])
//
//
//            }
//
//            else if(newdic.contains("cancelled")){
//                print("Trip Canceled")
//                 NotificationCenter.default.post(name: NSNotification.Name.init("cancelled"), object: nil, userInfo: dic as! [AnyHashable : Any])
//            }
//            else
//            {
//            NotificationCenter.default.post(name: NSNotification.Name.init("Acceptnotification"), object: nil, userInfo: userInfo)
//            }
//
//        }
//
//        else if state == .background{
//            //PUSH desired view and post notification
//
//
//
//            let newdic: String = ((dic.value(forKey:"aps") as! NSDictionary).value(forKey: "alert") as! NSDictionary).value(forKey: "body") as! String
//
//            if(newdic.contains("approved"))
//            {
//                NotificationCenter.default.post(name: NSNotification.Name.init("Approved"), object: nil, userInfo: dic as! [AnyHashable : Any])
//            }else if(newdic.contains("cancelled")){
//                print("Trip Canceled")
//                NotificationCenter.default.post(name: NSNotification.Name.init("cancelled"), object: nil, userInfo: dic as! [AnyHashable : Any])
//            }
//            else
//            {
//
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let navigationController:UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
//                let initialViewController = storyboard.instantiateViewController(withIdentifier: "RequestDriverVC") as! RequestDriverVC
//
//                let jsonObj = JSON(userInfo)
//
//                //        if jsonObj["request_id"] as Int !=
//
//                let  requestID = jsonObj["request_id"].intValue
//                initialViewController.requestID = requestID
//                navigationController.pushViewController(initialViewController, animated: true)
//                self.window?.rootViewController = navigationController
//                self.window?.makeKeyAndVisible()
//
//
//                NotificationCenter.default.post(name: NSNotification.Name.init("Acceptnotification"), object: nil, userInfo: userInfo)
//
//            }
//
//
//
//
//
//
//        }
//        else if state == .background{
//            let newdic: String = ((dic.value(forKey:"aps") as! NSDictionary).value(forKey: "alert") as! NSDictionary).value(forKey: "body") as! String
//
//            if(newdic.contains("approved"))
//            {
//                NotificationCenter.default.post(name: NSNotification.Name.init("Approved"), object: nil, userInfo: dic as! [AnyHashable : Any])
//
//
//            }
//            else if(newdic.contains("rejected"))
//            {
//                NotificationCenter.default.post(name: NSNotification.Name.init("Rejected"), object: nil, userInfo: dic as! [AnyHashable : Any])
//
//
//            }
//
//            else if(newdic.contains("cancelled")){
//                print("Trip Canceled")
//                NotificationCenter.default.post(name: NSNotification.Name.init("cancelled"), object: nil, userInfo: dic as! [AnyHashable : Any])
//            }
//            else
//            {
//
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let navigationController:UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
//                let initialViewController = storyboard.instantiateViewController(withIdentifier: "RequestDriverVC") as! RequestDriverVC
//                let jsonObj = JSON(userInfo)
//
//
//                let  requestID = jsonObj["request_id"].intValue
//                initialViewController.requestID = requestID
//                navigationController.pushViewController(initialViewController, animated: true)
//                self.window?.rootViewController = navigationController
//                self.window?.makeKeyAndVisible()
//
//                NotificationCenter.default.post(name: NSNotification.Name.init("Acceptnotification"), object: nil, userInfo: userInfo)
//
//            }
//        }
//
//        else if (state == .inactive)
//        {
//            let newdic: String = ((dic.value(forKey:"aps") as! NSDictionary).value(forKey: "alert") as! NSDictionary).value(forKey: "body") as! String
//
//            if(newdic.contains("approved"))
//            {
//                NotificationCenter.default.post(name: NSNotification.Name.init("Approved"), object: nil, userInfo: dic as! [AnyHashable : Any])
//
//
//            }
//            else if(newdic.contains("rejected"))
//            {
//                NotificationCenter.default.post(name: NSNotification.Name.init("Rejected"), object: nil, userInfo: dic as! [AnyHashable : Any])
//
//
//            }
//
//            else if(newdic.contains("cancelled")){
//                print("Trip Canceled")
//                NotificationCenter.default.post(name: NSNotification.Name.init("cancelled"), object: nil, userInfo: dic as! [AnyHashable : Any])
//            }
//            else
//            {
//
//
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let navigationController:UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
//                let initialViewController = storyboard.instantiateViewController(withIdentifier: "RequestDriverVC") as! RequestDriverVC
//                let jsonObj = JSON(userInfo)
//
//
//                let  requestID = jsonObj["request_id"].intValue
//                initialViewController.requestID = requestID
//                navigationController.pushViewController(initialViewController, animated: true)
//                self.window?.rootViewController = navigationController
//                self.window?.makeKeyAndVisible()
//
//                NotificationCenter.default.post(name: NSNotification.Name.init("Acceptnotification"), object: nil, userInfo: userInfo)
//
//            }
//
//
//
//        }
//        [AnyHashable("gcm.message_id"): 0:1525692009518307%40e491bb40e491bb, AnyHashable("aps"): {
//            alert =     {
//                body = "Sunny request a trip. want to drive ?";
//                title = "New User Request";
//            };
//            sound = mySound;
//            }, AnyHashable("request_id"): 171]
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //        let characterSet = CharacterSet(charactersIn: "<>")
        //                let deviceTokenString = deviceToken.description.trimmingCharacters(in: characterSet).replacingOccurrences(of: " ", with: "");
        //                print(deviceTokenString)
        //
        //                let user = UserDefaults.standard
        //                user.set(deviceTokenString, forKey: "devicetoken")
        //                user.synchronize()
        
        
        print("APNs token retrieved: \(deviceToken)")
        Messaging.messaging().apnsToken = deviceToken
        
        print("fireToken ==>  \(String(describing: Messaging.messaging().fcmToken))")
        print("ApnsToken ==>   \(String(describing: Messaging.messaging().apnsToken))")
        
//        Defaults[.fcmTokenkey] = Messaging.messaging().fcmToken!
        
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        Defaults[.fcmTokenkey] = fcmToken
//        let user = UserDefaults.standard
//        user.set(fcmToken, forKey: "FCMtoken")
//        user.synchronize()
        // Defaults[fcmTokenkey._key] = fcmToken
        //        user.set(fcmToken,forKey:"FCMToken")
        //Defaults.synchronize()
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    
    func tokenRefreshNotification(notification: NSNotification) {
        // NOTE: It can be nil here
        let refreshedToken = InstanceID.instanceID().token()
        print("InstanceID token: \(String(describing: refreshedToken))")
        
        connectToFcm()
    }
    
    func connectToFcm() {
        Messaging.messaging().connect { (error) in
            if (error != nil) {
                print("Unable to connect with FCM. \(String(describing: error))")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    
    
    
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != UIUserNotificationType() {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        bgtask = application.beginBackgroundTask(expirationHandler: {
            self.bgtask = UIBackgroundTaskInvalid
        })
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        UserDefaults.standard.removeObject(forKey:"isdashbord")

        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    class func hasConnectivity() -> Bool {
        
        let reachability: Reachability = Reachability.forInternetConnection()
        let networkStatus: Int = reachability.currentReachabilityStatus().rawValue
        return networkStatus != 0
        
    }
    
}

