//
//  AppDelegate.swift
//  Flight
//
//  Created by Eli Zhang on 5/5/20.
//  Copyright © 2020 Eli Zhang. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        let homeView = HomeView()
        window?.rootViewController = homeView
        window?.makeKeyAndVisible()
        return true
    }

}

