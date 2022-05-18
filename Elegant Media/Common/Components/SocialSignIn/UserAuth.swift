//
//  UserAuth.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/8/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper
import KeychainSwift

class UserAuth: BaseModel {
    static let          si                  = UserAuth()    //    shared instance
    
    var signedIn        : Bool              = false
    var username        : String            = ""
    var email           : String            = ""
    var token           : String            = ""
    
    let defaults                            = UserDefaults.standard
    let keychain                            = KeychainSwift()
    
    private override init() {
        super.init()
    }
    
    required init?(map: Map) {
        super.init(map: map)
        self.id                             = UUID().uuidString
    }

    //call this method in app delegate
    func initialise() {
        self.signedIn                       = keychain.getBool("user_SignedIn") ?? false
        self.token                          = keychain.get("access_token")                  ?? ""
        if self.signedIn && self.token != "" {
            self.username                   = defaults.string(forKey: "username")           ?? ""
            self.email                      = defaults.string(forKey: "email")              ?? ""
        } else {
            logOut()
        }
    }
    
    func setUserDetails(signedIn: Bool = false, username: String = "", token: String = "", email: String = "") {
        self.signedIn                       = signedIn
        self.username                       = username
        self.token                          = token
        keychain.set(signedIn               , forKey: "user_SignedIn")
        keychain.set(token                  , forKey: "access_token")
        defaults.set(username               , forKey: "username")
        defaults.set(email                  , forKey: "email")
    }
    
    func logOut() {
        setUserDetails()
    }
    
    func printUser() {
        print("user details =>")
        print("user_SignedIn                : \(signedIn)")
        print("username                     : \(username)")
        print("email                        : \(email)")
        print("access_token                 : \(token)")
    }
}
