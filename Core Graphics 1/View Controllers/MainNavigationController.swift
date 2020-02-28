//
//  MainNavigationController.swift
//  Core Graphics 1
//
//  Created by Jackson Tubbs on 2/28/20.
//  Copyright © 2020 Jackson Tubbs. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

    // Status Bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.barTintColor = .backgroundColor
        self.navigationBar.isTranslucent = false
    }
}
