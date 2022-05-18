//
//  Signin_MV.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/10/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import Foundation
import RxSwift

class SigninVM: BaseVM, SocialSignInVM {
    
    // MARK: - Inputs
    // MARK: - Outputs
    let showHomeVC                              : PublishSubject<Bool>      = PublishSubject()
    
    deinit {
        print("deinit SigninVM")
    }
    
}
