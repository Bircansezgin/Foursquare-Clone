//
//  AppDelegate.swift
//  foursQuareClone
//
//  Created by Bircan Sezgin on 1.06.2023.
//

import UIKit
import Parse

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Uygulama acilirken Sunucunun Baglantisi!
        let configuartin = ParseClientConfiguration { (ParseMutableClientConfiguration) in
            ParseMutableClientConfiguration.applicationId = "sYZMeJwaHxo1c6FUeCevExriOYiAPBtQ0VJzUPvn"
            ParseMutableClientConfiguration.clientKey = "NqwSWKo6n3ZH9srdWHXVB5z8HW2aR3yBrFOcjAlm"
            ParseMutableClientConfiguration.server = "https://parseapi.back4app.com"
        }
        
        Parse.initialize(with: configuartin)
        
        
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


}

