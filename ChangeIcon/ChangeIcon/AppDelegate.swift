//
//  AppDelegate.swift
//  ChangeIcon
//
//  Created by quanjunt on 2018/3/14.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

import UIKit
import CoreData

var Uploadimagecount = 0

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound], categories: nil))
        
        UIViewController.runtimeReplaceAlert()
        
        return true
    }


}

