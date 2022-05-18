//
//  StoryboardInitializable.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/7/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import UIKit

protocol StoryboardInitializable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardInitializable where Self: UIViewController {

    static var storyboardIdentifier: String {
        return String(describing: Self.self)
    }

    static func initFromStoryboard(name: String = "Main") -> Self {
        let storyboard      = UIStoryboard(name: name, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
    }
}


extension StoryboardInitializable where Self: BaseSuperVC {
    
    static func initFromStoryboardEmbedInNVC(name: String = "Main", withViewModel: BaseVM) -> UINavigationController {
        let storyboard      = UIStoryboard(name: name, bundle: Bundle.main)
        let vc              = storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
        vc.baseViewModel    = withViewModel
        
        return UINavigationController(rootViewController: vc)
    }
    
    static func initFromStoryboard(name: String = "Main", withViewModel: BaseVM) -> Self {
        let storyboard      = UIStoryboard(name: name, bundle: Bundle.main)
        let vc              = storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
        vc.baseViewModel    = withViewModel
        
        return vc
    }
    
}

extension StoryboardInitializable where Self: UIPageViewController {

    static func initFromStoryboard(name: String = "Main") -> Self {
        let storyboard = UIStoryboard(name: name, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
    }
    
}

extension StoryboardInitializable where Self: UITableViewController {

    static func initFromStoryboard(name: String = "Main") -> Self {
        let storyboard = UIStoryboard(name: name, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
    }
    
}
