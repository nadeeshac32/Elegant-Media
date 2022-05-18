//
//  AppCoordinator.swift
//  Elegant Media
//
//  Created by Nadeesha Chandrapala on 2022-05-18.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//


import UIKit
import RxSwift

class AppCoordinator: BaseCoordinator<Void> {

    private let defaults                = UserDefaults.standard
    
    deinit {
        print("deinit AppCoordinator")
    }
    
    override func start() -> Observable<Void> {
        UserAuth.si.initialise()
        let mainCoordinator         = MainCoordinator(window: window)
        return coordinate(to: mainCoordinator)
        
        /*
         Here we can coordintate the flow to navigate to introduction screens as below code.
         */
        
//        let userGuideShown              = defaults.bool(forKey: Defaults.userGuideShown.rawValue)
//        if !userGuideShown {
//            // This code execute only once
//            // Navigate to introductions screens
//        } else {
//            // Navita to main screens
//            let mainCoordinator         = MainCoordinator(window: window)
//            return coordinate(to: mainCoordinator)
//        }
    }
    
}
