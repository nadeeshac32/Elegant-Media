//
//  AppConfig.swift
//  Elegant Media
//
//  Created by Nadeesha Chandrapala on 2022-05-18.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//


import UIKit
import CoreLocation

let configFileName:String = "Configuration"

public enum Environment: String {
    case prod
    case qa
    case dev
    case uat
}

class AppConfig: NSObject, CLLocationManagerDelegate {
    
    static let si               = AppConfig()
    private var configDict      : NSDictionary?
    
    let defaults                = UserDefaults.standard
    
    var appName: String! {
        guard let string        = getValue(key: "appName") else { return "" }
        return (string as! String)
    }
    
    // MARK: - environment variables
    var environments: NSDictionary! {
        guard let urlArray      = getValue(key: "environments") else { return [:] }
        return (urlArray as! NSDictionary)
    }

    var environmentSelection: Environment! {
        return Environment.dev
    }
    
    var currentEnvironment: NSDictionary! {
        return (environments[(environmentSelection.rawValue)] as! NSDictionary)
    }
    
    // MARK: - url variables
    var domains: NSDictionary! {
        guard let domainsDict   = currentEnvironment["domains"] else { return [:] }
        return (domainsDict as! NSDictionary)
    }
    
    var baseUrl: String! {
        guard let string        = domains["base_url"] else { return "" }
        return (string as! String)
    }

    
    // MARK: - API keys
    var apiKeys: NSDictionary! {
        guard let keysArray     = getValue(key: "apiKeys") else { return [:] }
        return (keysArray as! NSDictionary)
    }
    
    var loginToken: String! {
        guard let string        = apiKeys["loginToken"] else { return "" }
        return (string as! String)
    }
    
    var x_API_Key: String! {
        guard let string        = apiKeys["X-API-Key"] else { return "" }
        return (string as! String)
    }
    
    //MAEK: - Specific image names
    let defaultAvatar_ImageName = "icon_avatarPlaceHolder"
    
    //MARK: - Colors
    //TODO: - Color palet should be properly implemented
    let colorPrimary            = #colorLiteral(red: 0.420697093, green: 0.3667229414, blue: 0.7243047357, alpha: 1)
    let colorPrimaryDisabled    = #colorLiteral(red: 0.3019607843, green: 0.2509803922, blue: 0.5176470588, alpha: 0.5)
    let colorSubDetail          = #colorLiteral(red: 0.6078431373, green: 0.5960784314, blue: 0.6274509804, alpha: 1)
    let colorGradient1          = #colorLiteral(red: 0.3411764706, green: 0.3098039216, blue: 0.6039215686, alpha: 1)
    let colorGradient2          = #colorLiteral(red: 0.3411764706, green: 0.5764705882, blue: 0.6235294118, alpha: 1)
    let colorSuccess            = #colorLiteral(red: 0, green: 0.6980392157, blue: 0.01176470588, alpha: 1)
    let colorError              = #colorLiteral(red: 0.6901960784, green: 0, blue: 0.1254901961, alpha: 1)
    let colorWarning            = #colorLiteral(red: 1, green: 0.5960784314, blue: 0, alpha: 1)
    
    // MARK: - system variables
    let splashScreenDuration    = 1
    
    let screenSize              = UIScreen.main.bounds
    
    func statusBarSize() -> CGSize {
        let statusBarSize: CGRect
        if #available(iOS 13.0, *) {
            let window          = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            statusBarSize       = window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect(x: 0, y: 0, width: 0, height: 44)
        } else {
            statusBarSize       = UIApplication.shared.statusBarFrame
        }
        
        return statusBarSize.size
    }
    
    func statusBarHeightForLessthaniOS13() -> CGFloat {
        return Swift.min(statusBarSize().width, statusBarSize().height)
    }
    
        
    //MARK: - init
    override private init() {
        super.init()
        if let plist = Plist(name: configFileName) {
            configDict          = plist.getValuesInPlistFile()
        } else {
            print("AppConfig -> startManager : Unable to start")
        }
    }
    
    func getValue(key:String) -> AnyObject? {
        var value:AnyObject?
        if let dict = configDict {
            let keys = Array(dict.allKeys)
            //print("[Config] Keys are: \(keys)")
            if keys.count != 0 {
                for (_,element) in keys.enumerated() {
                    //print("[Config] Key Index - \(index) = \(element)")
                    if element as! String == key {
                        //print("[Config] Found the Item that we were looking for for key: [\(key)]")
                        value = dict[key]! as AnyObject
                        break
                    }
                }
                
                if value != nil {
                    return value!
                } else {
                    print("[AppConfig] WARNING: The Item for key '\(key)' does not exist! Please, check your spelling.")
                    return .none
                }
            } else {
                print("[AppConfig] No Plist Item Found when searching for item with key: \(key). The Plist is Empty!")
                return .none
            }
        } else {
            print("[AppConfig] -> getValue : Unable to get Plist")
            return .none
        }
    }
}
