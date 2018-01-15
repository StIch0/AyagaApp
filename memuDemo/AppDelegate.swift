//
//  AppDelegate.swift
//  memuDemo
//  Created by Pavel Burdikovskii (StIch)
//  Created by Parth Changela on 09/10/16.
//  Copyright © 2016 Parth Changela. All rights reserved.
//

import UIKit
import Alamofire
import UserNotifications
import UserNotificationsUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate { 

    var window: UIWindow?    
    let requestIdentifier = "SampleRequest"    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.self.self.self.self //<<-- just for fun
        
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barTintColor = UIColor(colorLiteralRed: 1, 
                                                            green: 0.75686275, 
                                                            blue: 0.02745098, 
                                                            alpha: 1)        
                
        UIApplication.shared.statusBarStyle = .lightContent        
              
        let def = UserDefaults.standard
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        if def.string(forKey: "login") != nil {
            Profile.shared.setData(
                login: def.string(forKey: "login")!,
                pswd: def.string(forKey: "pswd")!,
                name: def.string(forKey: "name")!,
                serName: def.string(forKey: "serName")!,
                phone: def.string(forKey: "phone")!,
                city: def.string(forKey: "city")!,
                birth_date: def.string(forKey: "birth_date")!,
                id: def.integer(forKey: "id"))
            Profile.shared.sign = def.bool(forKey: "sign")
            Profile.shared.sub_num = def.string(forKey: "sub_num")!
        }
        
        request(baseURL + "/api/user-info", method: .post, parameters: ["id":Profile.shared.id]).responseJSON{ responseJSON in
            switch responseJSON.result{
            case .success(_):
                guard let jsonArray = responseJSON.value as? [String: AnyObject] else {return}
                //  let result = jsonArray["news"] as! [AnyObject]
                print(jsonArray)
                //if jsonArray["status"]! as! String != "ОК" {
                    Profile.shared.setData(login: Profile.shared.login,
                                           pswd: Profile.shared.pswd,
                                           name: jsonArray["name"] as? String ?? "",
                                           serName: jsonArray["family"] as? String ?? "",
                                           phone: jsonArray["tel"] as? String ?? "",
                                           city: jsonArray["city"] as? String ?? "",
                                           birth_date: jsonArray["birth_date"] as? String ?? "", 
                                           id: Profile.shared.id)
                
                print("id =  __________________",Profile.shared.id)
                print("id =  __________________",Profile.shared.name)
                print("id =  __________________",Profile.shared.city)
                print("id =  __________________",Profile.shared.login)
                print("id =  __________________",Profile.shared.birth_date)
                print("id =  __________________",Profile.shared.pswd)
                print("id =  __________________",Profile.shared.phone)
                 //}
                
            case .failure(let error):
                print("Error = ",error)
            }
            
        }
                        
//        load()
        
        //let navBackgroundImage:UIImage! = UIImage(named: "statusBarBG")
        //UINavigationBar.appearance().setBackgroundImage(navBackgroundImage, for: .default)                
        
        return true
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
        Profile.shared.Save()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        Profile.shared.Save()
    }

  
    
    //This is key callback to present notification while the app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("Notification being triggered")
        //You can either present alert ,sound or increase badge while the app is in foreground too with ios 10
        //to distinguish between notifications
        if notification.request.identifier == requestIdentifier{
            
            completionHandler( [.alert,.sound,.badge])
            
        }
    }
}

