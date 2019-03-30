//
//  AppDelegate.swift
//  MoodMapping
//
//  Created by spoonik on 2015/10/02.
//  Copyright © 2015年 com.spoonikapps. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        //let interval:NSTimeInterval = 60 * 180 // 3時間
        //UIApplication.sharedApplication().setMinimumBackgroundFetchInterval(interval)


        //Local Notificationの登録: TODO、可変の時間を登録できるように
        //Notification登録前のおまじない。テストの為、現在のノーティフィケーションを削除します
        UIApplication.sharedApplication().cancelAllLocalNotifications();
        
        //Notification登録前のおまじない。これがないとpermissionエラーが発生するので必要です。
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Sound,], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        UIApplication.sharedApplication().registerForRemoteNotifications()
      
        //以下で登録処理
        setTimeNotification(7, minute: 45)
        setTimeNotification(12, minute: 15)
        setTimeNotification(17, minute: 30)

        return true
    }
  
    func setTimeNotification(hour: Int, minute: Int) {
        let now = NSDate()
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
        let comps:NSDateComponents = calendar!.components([NSCalendarUnit.Year, .Month, .Day], fromDate: now)
        comps.calendar = calendar

        let notification = UILocalNotification()
        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.repeatInterval = .Day
        notification.alertBody = "Time to mark your mood!"
        notification.alertAction = "OK"
        notification.soundName = UILocalNotificationDefaultSoundName
      
        comps.hour = hour
        comps.minute = minute
        if now.compare(comps.date!) != .OrderedAscending {
            comps.day += 1
        }
        let now2 = comps.date
        notification.fireDate = now2
        UIApplication.sharedApplication().scheduleLocalNotification(notification);
    }
  
  
    /*func application(application: UIApplication,
        performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
            // 処理結果を通知するNotification生成
            let myNotification: UILocalNotification = UILocalNotification()
            // タイトルを設定
            myNotification.alertTitle = ""
            // メッセージを設定
            myNotification.alertBody = "Keep recording your mood!"
            // Timezoneを設定をする.
            myNotification.timeZone = NSTimeZone.defaultTimeZone()
            // Notificationを表示する.
            UIApplication.sharedApplication().scheduleLocalNotification(myNotification)
            // バックグラウンドフェッチ結果を通知
            completionHandler(UIBackgroundFetchResult.NewData)
    }*/
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

