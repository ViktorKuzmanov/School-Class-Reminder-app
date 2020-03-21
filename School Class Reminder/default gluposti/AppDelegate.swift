//
//  AppDelegate.swift
//  School Class Scedule
//
//  Created by Viktor Kuzmanov on 10/1/17.


import UIKit
import Foundation
import UserNotifications
import CoreData
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var key = "itIsNotfirstLaunchOfTheApp"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        // autorization i delegate
        UNUserNotificationCenter.current().requestAuthorization(options:[.alert,.sound,.badge],completionHandler: {(didAllow, error) in})
        UNUserNotificationCenter.current().delegate = self
        
        if !UserDefaults.standard.bool(forKey: "TermsAccepted") {
            UserDefaults.standard.set(false, forKey: "TermsAccepted")
            UserDefaults.standard.set(true, forKey: key)
            print("in if in TermsAccepted - appDelagate")
        } else {
            print("in els in TermsAccepted - appDelagate")
            
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.makeKeyAndVisible()
            let mainST = UIStoryboard(name: "Main", bundle: Bundle.main)
            let VC = mainST.instantiateViewController(withIdentifier: "TabBar39") as! MajorTabBarController
            window?.rootViewController = VC
            
            if UserDefaults.standard.bool(forKey: key) == true {
                // if is not first time lauching the app allow get the second tabbar item opened
                print()
                print(" if is not first time lauching the app allow get the second tabbar item opened")
                print()
                VC.selectedIndex = 1
            }
        }
        
        return true
    }
    
    // za da se pokazuat notification i u foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
        // let state = UIApplication.shared.applicationState
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
        // Saves changes in the application's managed object context before the application terminates.
        PersistanceService.saveContext()
    }
}
