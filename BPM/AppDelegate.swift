//
//  AppDelegate.swift
//  Bpm-iphone
//
//  Created by Keeper on 09/03/2018.
//  Copyright © 2018 Keeper. All rights reserved.
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
        setupStatusBar()
        return true
    }
    
    fileprivate func enableOptions() {
        UIDevice.current.isBatteryMonitoringEnabled = true
    }
    
    fileprivate func setupStatusBar() {
        guard let window = window else { return }
        
        let statusBar = StatusBarView.shared
        window.addSubview(statusBar)
        statusBar.anchor(
            top: window.topAnchor,
            leading: window.leadingAnchor,
            bottom: nil,
            trailing: window.trailingAnchor
        )
        
        let statusBarHeight: CGFloat = ScreenService.shared.isX() ? 44 : 20
        statusBar.anchorSize(size: Size(width: nil, height: statusBarHeight))
        statusBar.barTintColor = .appDarkGray
    }
}

