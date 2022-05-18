//
//  FacebookSignIn.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/21/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit

protocol FacebookSignInSupport: class {
    var facebookSignInVM: SocialSignInVM { get }
    func configureFacebookSignIn(facebookSignInButton: NCFBLoginButton)
    func signedInWithFacebookToken(token: String, username: String, email: String)
}

/// Default implementation of `FacebookSignInSupport` protocol
extension FacebookSignInSupport where Self: SocialSignInSupportVC {

    var facebookSignInVM: SocialSignInVM {
        return viewModel!
    }
    
    func configureFacebookSignIn(facebookSignInButton: NCFBLoginButton) {
        facebookSigninBtn.loginCompletionHandler = { [weak self] (button, result) in
            switch result {
            case .success(let result):
                Profile.loadCurrentProfile { (profile, error) in
                    if let token = result.token?.tokenString {
                        self?.signedInWithFacebookToken(token: token, username: "\(profile?.firstName ?? "") \(profile?.lastName ?? "")", email: profile?.email ?? "")
                    }
                }
                break
            case .failure:
                self?.somethingWentWrong()
                break
            }
        }
        
        facebookSignInButton.loginCancleHandler = { [weak self] (button) in
            self?.userCanceled()
        }
    }
    
    func signedInWithFacebookToken(token: String, username: String, email: String) {
        facebookSignInVM.signInWithFacebook(token: token, username: username, email: email)
    }
}


protocol FacebookSignable: FacebookSignInSupport, SocialSignInCanclable { }
