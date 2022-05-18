//
//  SocialSignInVC.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/21/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

/// Replace the ViewController with which you're gonna add Google SignIn Button
typealias SocialSignInSupportVC = SigninVC
typealias SocialSignInSupportVM = SigninVM

/// This protocol methods are called from ViewController side
protocol SocialSignInCanclable: class {
    /// This method will be called when the user canceled the sign-in flow.
    func userCanceled()
    
    /// This method will be called when `GIDSignIn.sharedInstance()?.disconnect()` is called
    func userDisconnect()
    func somethingWentWrong()
}

/// Default implementation of `SocialSignInCanclable` protocol
extension SocialSignInCanclable where Self: SocialSignInSupportVC {
    func userCanceled() {
        // MARK: - Handle as wanted
        //  viewModel?.userCanceled()
    }
    
    func userDisconnect() {
        // MARK: - Handle as wanted
        //  viewModel?.userDisconnect()
    }
    
    func somethingWentWrong() {
        viewModel?.handleDefaultError()
    }
}
