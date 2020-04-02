//
//  AppDelegate.swift
//  Core Graphics 1
//
//  Created by Jackson Tubbs on 2/11/20.
//  Copyright © 2020 Jackson Tubbs. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: Properties
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        ParameterController.shared.loadParameters()
        presentInitialViewController()
        return true
    }

    private func presentInitialViewController() {
        let mainNavigationController = MainNavigationController(nibName: nil, bundle: nil)
        let mainViewController = MainViewController()
        mainNavigationController.viewControllers = [mainViewController]
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = mainNavigationController
        self.window?.makeKeyAndVisible()
    }
}

