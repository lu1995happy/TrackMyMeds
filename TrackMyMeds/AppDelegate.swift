//
//  AppDelegate.swift
//  TrackMyMeds
//
//  Created by 天霖 陆 on 2017/3/29.
//  Copyright © 2017年 天霖 陆. All rights reserved.
//

import UIKit
import MagicalRecord
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        UITabBar.appearance().tintColor = UIColor.black
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.black], for: .selected)
        
        MagicalRecord.setupCoreDataStack(withStoreNamed: "DataModel")
      
        
        if let payload = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? NSDictionary, let identifier = payload["AlarmNotiVC"] as? String {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: identifier)
            window?.rootViewController = vc
            
        }
        
        
        if UserDefaults.standard.bool(forKey: "isLoggedIn") ==  true
        {
            /*
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarcontroller") as! UITabBarController
        UIApplication.shared.keyWindow?.rootViewController = viewController
            */
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "tabBarcontroller")
            window?.rootViewController = vc
            
        }
        else
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "loginVC")
            window?.rootViewController = vc
            /*
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "loginVC")
            
            let applicationFrame = UIScreen.main.applicationFrame
            let window = UIWindow(frame: applicationFrame)
            window.rootViewController = viewController
            window.makeKeyAndVisible()
            self.window = window
            
            UIApplication.shared.keyWindow?.rootViewController = viewController*/

        }
        
        
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {(accepted, error) in
            if !accepted {
                print("Notification access denied.")
            }
        }
        
        return true
    }
    
    /*
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }*/
    
//    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        //let userInfo = response.notification.request.content.userInfo
//        //if let chatID = userInfo["chatID"] as? String {
//            // here you can instantiate / select the viewController and present it
//        /*
//        let myViewController = MyViewController()
//        guard let tabbarController = self.window.rootViewController as? UITabbarController else {
//            // your rootViewController is no UITabbarController
//            return
//        }
//        guard let selectedNavigationController = tabbarController.selectedViewController as? UINavigationController else {
//            // the selected viewController in your tabbarController is no navigationController!
//            return
//        }
//        selectedNavigationController.pushViewController(myViewController, animated: true)
//        
//        
//        //}
//        completionHandler()*/
//        
//    }
    
    
    
//    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
//        
//    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Play sound and show alert to the user
        print(notification.request.content.userInfo)
        completionHandler([.alert,.sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        //print(response.notification.request.content.userInfo)
        let infoDict = response.notification.request.content.userInfo
        
        for (_, _) in infoDict {
            
            //print(key, value)
            
            
            let medName = infoDict["MedName"]
            let medTime = infoDict["MedTime"]
            
            //print("\(medTime)")
            
        if let med = medName, let time = medTime
        {
        let alert = UIAlertController(title: "Time to take your medicine", message: "\(med)", preferredStyle: UIAlertControllerStyle.alert)
        
            let predicate = NSPredicate(format: "medicineName == %@ && alarmTLabel == %@", med as! CVarArg, time as! CVarArg)
            let findAlarm = Alarm.mr_findAll(with: predicate) as! [Alarm]!
            
            if findAlarm?.count != 0
            {
                
                alert.addAction(UIAlertAction(title: "Taken", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        let medFind = Medicine.mr_findFirst(byAttribute: "medName", withValue: med)
                        
                        if (medFind != nil) {
                            medFind?.noOfTimesTaken+=1
                        }
                        
                    case .cancel:
                        print("cancel")
                        
                    case .destructive:
                        print("destructive")
                    }
                }))
                
                alert.addAction(UIAlertAction(title: "Skipped", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        print("default")
                        
                    case .cancel:
                        print("cancel")
                        
                    case .destructive:
                        print("destructive")
                    }
                }))
            }
        //alert.addAction(UIAlertAction(title: "Taken", style: UIAlertActionStyle.default, handler: nil))
        //alert.addAction(UIAlertAction(title: "Skipped", style: UIAlertActionStyle.default, handler: nil))
        //alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
        completionHandler()
    }
    }
    
    
    /*func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    {
        print("HERE EHRE HERE HR EHE HR HE HR HE EH")
        /*
        if application.applicationState == UIApplicationState.active {
            //print("App already open")
            let alert = UIAlertController(title: "Message", message: "App already open", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)

        } else {
            //print("App opened from Notification")
            let alert = UIAlertController(title: "Message", message: "App opened from Notification", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            
        }*/
    }*/
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        let checkGoogle = GIDSignIn.sharedInstance().handle(url as URL!,sourceApplication: sourceApplication,annotation: annotation)
        return checkGoogle
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
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
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

