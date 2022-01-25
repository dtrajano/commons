//
//  AppDelegate.swift
//  ProjectViewCode
//
//  Created by Diogo Trajano on 25/01/2022.
//  Copyright © 2022 Diogo Trajano. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = SampleViewController()
        self.window?.makeKeyAndVisible()
        return true
    }
}

