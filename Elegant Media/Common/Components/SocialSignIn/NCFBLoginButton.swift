//
//  NCFBLoginButton.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/21/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class NCFBLoginButton: BaseButton {
    
    private weak var responsibleViewController  : UIViewController!
    var loginCompletionHandler                  : ((NCFBLoginButton, Result<LoginManagerLoginResult, Error>) -> Void)?
    var loginCancleHandler                      : ((NCFBLoginButton) -> Void)?
    
    override func configureView() {
        super.configureView()
        
        responsibleViewController               = findResponsibleViewController()
        
        clipsToBounds                           = true
        layer.cornerRadius                      = 5
        backgroundColor                         = #colorLiteral(red: 0.2595475912, green: 0.4040731192, blue: 0.699347496, alpha: 1)
        tintColor                               = .white
        imageEdgeInsets                         = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        titleLabel?.font                        = UIFont.systemFont(ofSize: 14, weight: .semibold)
        setImage(#imageLiteral(resourceName: "icon_Facebook"), for: .normal)
        addTarget(self, action: #selector(touchUpInside(sender:)), for: .touchUpInside)
        setTitle("Sign in with Facebook", for: .normal)
        setTitleColor(.white, for: .normal)
    }
    
    override func didMoveToSuperview() {
        superview?.addShadow()
    }
    
    @objc private func touchUpInside(sender: NCFBLoginButton) {
        LoginManager().logIn(permissions: ["public_profile", "email"], from: responsibleViewController) { [weak self] (result, error) in
            guard error == nil else {
                print("error: \(error!.localizedDescription)")
                if let self = self {
                    self.loginCompletionHandler?(self, .failure(error!))
                }
                return
            }
            
            guard let result = result, !result.isCancelled else {
                print("User cancelled login")
                if let self = self {
                    self.loginCancleHandler?(self)
                }
                return
            }
            
            if let self = self {
                print("Login successfull")
                self.loginCompletionHandler?(self, .success(result))
            }
        }
    }
}

extension UIView {
    
    /// Find the view controller that responsible for a particular view
    func findResponsibleViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findResponsibleViewController()
        } else {
            return nil
        }
    }
}
