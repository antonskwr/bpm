//
//  AppDelegate.swift
//  Bpm-iphone
//
//  Created by Anton Skvartsou on 09/03/2018.
//  Copyright © 2018 Anton Skvartsou. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = HomeController()
        window?.makeKeyAndVisible()
        
        enableOptions()
        return true
    }
    
    fileprivate func enableOptions() {
        UIDevice.current.isBatteryMonitoringEnabled = true
    }
}
