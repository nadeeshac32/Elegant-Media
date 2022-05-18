//
//  LoadingViewable.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/8/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import UIKit
import SnapKit

protocol loadingViewable {
    func startAnimating()
    func stopAnimating()
}
extension loadingViewable where Self : UIViewController {
    func startAnimating(){
        let activityView                    : UIActivityIndicatorView!
        if #available(iOS 13.0, *) {
            activityView                    = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        } else {
            activityView                    = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        }
        activityView.color                  = AppConfig.si.colorPrimary
        view.addSubview(activityView)
        activityView.restorationIdentifier  = "activityView"
        view.bringSubviewToFront(activityView)
        activityView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        activityView.startAnimating()
    }
    func stopAnimating() {
        for item in view.subviews
            where item.restorationIdentifier == "activityView" {
                UIView.animate(withDuration: 0.3, animations: {
                    item.alpha = 0
                }) { (_) in
                    item.removeFromSuperview()
                }
        }
    }
}


protocol loadingFreezable {
    func startFreezeAnimation()
    func stopFreezeAnimating()
}
extension loadingFreezable where Self : UIViewController {
    func startFreezeAnimation(){
        let overlay = UIView(frame: CGRect.init(x: 0, y: 0, width: AppConfig.si.screenSize.width, height: AppConfig.si.screenSize.height))
        overlay.backgroundColor = .black
        overlay.alpha = 0.2
        
        view.addSubview(overlay)
        overlay.restorationIdentifier   = "loadingOverlay"
        view.bringSubviewToFront(overlay)
        startAnimating()
    }
    func stopFreezeAnimating() {
        stopAnimating()
        for item in view.subviews
            where item.restorationIdentifier == "loadingOverlay" {
                UIView.animate(withDuration: 0.3, animations: {
                    item.alpha = 0
                }) { (_) in
                    item.removeFromSuperview()
                }
        }
    }
}
