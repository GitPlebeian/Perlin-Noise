//
//  AppDelegate.swift
//  Core Graphics 1
//
//  Created by Jackson Tubbs on 2/11/20.
//  Copyright © 2020 Jackson Tubbs. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: Properties
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        presentInitialViewController()
        return true
    }

    private func presentInitialViewController() {
        let initialViewController = MainViewController(nibName: nil, bundle: nil)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }
}

