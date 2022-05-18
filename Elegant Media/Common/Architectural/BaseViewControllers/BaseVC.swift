//
//  BaseVC.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/7/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import UIKit
import RxSwift
import RxAppState


/// Generic view controller super class. It has all the functionality which are required by all the ViewControllers.
/// When you're subclassing this class you have to give the type of ViewModel you're gonna use in the subclass. That ViewModel also should be a subclass of BaseVM.
class BaseVC<ViewModel: BaseVM>: BaseSuperVC {
    
    var viewModel: ViewModel?
    override weak var baseViewModel: BaseVM? {
        get {
            return viewModel
        }
        set {
            if let newViewModel = newValue as? ViewModel {
                viewModel = newViewModel
            } else {
                print("incorrect BaseVM type for BaseVC")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customiseView()
        setupBindings()
        viewModel?.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        viewModel?.viewWillLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewModel?.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden                        = false
        self.navigationController?.navigationBar.isTranslucent                  = true
        self.navigationController?.navigationBar.tintColor                      = .white
        self.navigationController?.navigationBar.titleTextAttributes            = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.backgroundColor                = AppConfig.si.colorGradient2
        self.navigationController?.setStatusBar(backgroundColor: AppConfig.si.colorGradient2)
        viewModel?.viewWillAppear(animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.viewDidAppear(animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel?.viewWillDisappear(animated: animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel?.viewDidDisappear(animated: animated)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func customiseView() {
        self.view.backgroundColor                                               = .white
    }
    
    func addBackButton(title: String? = "Back", icon: String? = "icon_back") {
        let button                                                              = UIButton(type: .system)
        if let icon = icon {
            button.setImage(UIImage(named: icon)?.withRenderingMode(.alwaysTemplate), for: .normal)
            let spacing: CGFloat                                                = 14.0
            let inset                                                           = UIEdgeInsets(top: -3, left: -spacing, bottom: -3, right: spacing)
            button.imageEdgeInsets                                              = inset
        }
        if let title = title {
            button.titleLabel?.font                                             = button.titleLabel?.font.withSize(17)
            button.setTitle(title, for: .normal)
            let spacing: CGFloat                                                = 14.0
            let inset                                                           = UIEdgeInsets(top: 0, left: -spacing, bottom: 0, right: spacing)
            button.titleEdgeInsets                                              = inset
        }
        let leftBarButton = UIBarButtonItem(customView: button)
        button.addTarget(self, action: #selector(self.backBtnTapped), for: .touchUpInside)

        self.navigationItem.leftBarButtonItem                                   = leftBarButton
    }
    
    @objc func backBtnTapped() {
        self.viewModel?.backButtonTapped()
    }
    
    func removeRightButton() {
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem    = nil
    }
    
    func removeLeftButton() {
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem     = nil
    }
    
    func removeNavigationBarShadow() {
        self.navigationController?.navigationBar.removeShadow()
    }
    
    func setupBindings() {
        
        if let viewModel = viewModel {
            disposeBag.insert([
                // MARK: - Outputs
                UIApplication.shared.rx.didOpenAppCount
                    .subscribe(onNext: { count in
                        viewModel.didOpenTheApp()
                    }),
                
                // MARK: - Inputs
                viewModel.showAlert.subscribe(onNext: { [weak self] (alertTupple) in
                    let ac = UIAlertController(title: alertTupple.title, message: alertTupple.message, preferredStyle: .alert)
                    
                    let cancelAction  = UIAlertAction(title: alertTupple.secondaryBtnTitle ?? "Cancel", style: .default, handler: alertTupple.secondaryAction != nil ? { (ac) in alertTupple.secondaryAction!() } : nil)
                    cancelAction.setValue(alertTupple.secondaryActionColor ?? AppConfig.si.colorPrimary, forKey: "titleTextColor")
                    ac.addAction(cancelAction)
                    
                    if let action = alertTupple.primaryAction {
                        let primaryAction = UIAlertAction(title: alertTupple.primaryBtnTitle ?? "Confirm", style: .default, handler: { (ac) in action() })
                        primaryAction.setValue(alertTupple.primaryActionColor ?? AppConfig.si.colorPrimary, forKey: "titleTextColor")
                        ac.addAction(primaryAction)
                    }

                    self?.present(ac, animated: true, completion: nil)
                }),
                viewModel.requestLoading.asObservable().bind(to: self.rx.isAnimating),
                viewModel.freezeForRequestLoading.asObservable().bind(to: self.rx.isFreezing),
                viewModel.freezeForRequestLoading.subscribe(onNext: { [weak self] (isFreezed) in
                    self?.navigationItem.leftBarButtonItem?.isEnabled   = !isFreezed
                    self?.navigationItem.rightBarButtonItem?.isEnabled  = !isFreezed
                }),
                viewModel.toastMessage.subscribe(onNext: { [weak self] (message) in
                    self?.view.makeToast(message)
                }),
                viewModel.successMessage.subscribe(onNext: { (tupple) in
                    NCCustomMessageMaker.showSuccessMessage(text: tupple.message, blockScreen: tupple.blockScreen, completion: tupple.completionHandler)
                }),
                viewModel.warningMessage.subscribe(onNext: { (tupple) in
                    NCCustomMessageMaker.showWarningMessage(text: tupple.message, blockScreen: tupple.blockScreen, completion: tupple.completionHandler)
                }),
                viewModel.errorMessage.subscribe(onNext: { (tupple) in
                    NCCustomMessageMaker.showErrorMessage(text: tupple.message, blockScreen: tupple.blockScreen, completion: tupple.completionHandler)
                }),
                viewModel.hideKeyBoard.subscribe(onNext: { [weak self] (hide) in
                    self?.view.endEditing(true)
                }),
                viewModel.goToPreviousVC.subscribe(onNext: { [weak self] (_) in
                    self?.navigationController?.popViewController(animated: true)
                })
            ])
        }
    }
    
}
