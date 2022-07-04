//
//  AppDelegate.swift
//  PoemApp
//
//  Created by Юлия Алдохина on 12/05/22.
//


import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()

        window?.rootViewController = UINavigationController(rootViewController: PoemsViewController())

        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        StorageManager.shared.savePoem()
    }

}



