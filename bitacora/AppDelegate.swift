//
//  AppDelegate.swift
//  bitacora
//
//  Created by Andres Yepes on 5/23/19.
//  Copyright © 2019 Andres Yepes. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let dataController = DataController(modelName: "bitacora")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        dataController.load()
        
        let tabBarController = window?.rootViewController as! UITabBarController
        let navBarController = tabBarController.viewControllers?.first as! UINavigationController
        let newVC = navBarController.topViewController as! PhotosViewController
        newVC.dataController = dataController

        return true
    }
}

