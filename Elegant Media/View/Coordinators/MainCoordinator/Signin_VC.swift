//
//  Signin_VC.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/10/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import UIKit
import RxSwift

class SigninVC: BaseVC<SigninVM>, FacebookSignable {

    @IBOutlet weak var facebookSigninBtn                                : NCFBLoginButton!
    
    
    deinit {
        print("deinit SigninVC")
    }
    
    override func customiseView() {
        super.customiseView()
        title                                                           = "Log In"
        configureFacebookSignIn(facebookSignInButton: facebookSigninBtn)
    }
    
}
