//
//  AppDelegate.swift
//  Tuner
//
//  Created by Raphael Cruzeiro on 11/02/2017.
//  Copyright © 2017 Raphael Cruzeiro. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = ViewController()
        window!.makeKeyAndVisible()

        return true
    }

}
