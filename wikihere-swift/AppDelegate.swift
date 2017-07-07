//
//  AppDelegate.swift
//  wikihere-swift
//
//  Created by Jeremy on 11/15/16.
//  Copyright © 2016 Maurerhouse. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        NSLog("Environment %@", Environment.sharedInstance.environmentName)
        NSLog("AppName %@", Environment.sharedInstance.appName)
        NSLog("wikiBaseUrl %@", Environment.sharedInstance.wikiBaseUrl)
        
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        
        let lat = 37.7858
        let long = -122.406
        
        let urlString = Environment.sharedInstance.wikiBaseUrl +
            "&list=geosearch" + // Asking Wikipedia to do a geosearch
            "&format=json" + // Make sure the format is JSON
            "&gslimit=50" + // Limit articles to return, hard set to 50
            "&gsmaxdim=3000" + // Limit articles to Wikipedia geo dimension size, hard set to 3000
            "&gsradius=5000" + // Max search radius
            "&gscoord=\(lat)|\(long)" // Lat/Long to conduct search around
        
        let escapedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let url = URL(string: escapedUrlString!)!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
            } else {
                
                if let urlContent = data {
                    
                    do {
                        
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options:
                            JSONSerialization.ReadingOptions.mutableContainers)
                        
                        let wikiEntries = WikiEntries.from(jsonResult as! NSDictionary)
                        
                        dLog(message: "ok then")
                        
                        
                    } catch {
                        
                        print("JSON Processing Failed")
                    }
                }
            }
            
        })
        task.resume()
        
        
        
        // Override point for customization after application launch.
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
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

