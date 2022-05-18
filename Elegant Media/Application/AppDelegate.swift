//
//  AppDelegate.swift
//  Elegant Media
//
//  Created by Nadeesha Chandrapala on 2022-05-18.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//


import UIKit
import RxSwift
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var appCoordinator                      : AppCoordinator!
    private let disposeBag                          = DisposeBag()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Configure Facebook Sign in
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        if #available(iOS 13, *) {
            // this part is handled in SceneDelegate
        } else {
            // keep the spash screen for bit more
            let storyboard                          = UIStoryboard(name: "LaunchScreen", bundle: nil)
            let splashScreen                        = storyboard.instantiateViewController(withIdentifier: "LaunchScreen")
            window?.rootViewController              = splashScreen
            window?.makeKeyAndVisible()
            sleep(UInt32(AppConfig.si.splashScreenDuration))
            
            appCoordinator  = AppCoordinator(window: self.window!)
            appCoordinator.start().subscribe().disposed(by: disposeBag)
        }
        return true
    }

    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

