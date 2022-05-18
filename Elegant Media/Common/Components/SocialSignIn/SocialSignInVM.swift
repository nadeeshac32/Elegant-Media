//
//  SocialSignInVM.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/21/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

protocol SocialSignInVM {
    func signInWithFacebook(token: String, username: String, email: String)
}

extension SocialSignInVM where Self: SocialSignInSupportVM {
    
    func signInWithFacebook(token: String, username: String, email: String) {
        hideKeyBoard.onNext(true)
        UserAuth.si.setUserDetails(signedIn: true, username: username, token: token, email: email)
        self.showHomeVC.onNext(true)
    }
}
