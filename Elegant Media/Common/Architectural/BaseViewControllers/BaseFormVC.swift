//
//  BaseFormVC.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/7/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Toast_Swift

/// This class is used where there's any form submition.
/// Handles form validation and enabling submit button.
/// Handles scrolling functionality and dynemic adjustments in UI.
/// - Note: You always have to override `scrollViewContentHeightWithouDynemicGap` variable in the subclass.
///     - `scrollViewContentHeightWithouDynemicGap` is the height of the `ScrollView.ContentView` without dynemically adjusting height.
class BaseFormVC<ViewModel: BaseFormVM>: BaseVC<ViewModel> {
    
    var scrollView                                          : UIScrollView!
    var dynemicGapCons                                      : NSLayoutConstraint!
    var scrollViewTopCons                                   : NSLayoutConstraint!
    var scrollViewBottomCons                                : NSLayoutConstraint!
    var submitButton                                        : UIButton?
    var scrollViewBottomMargin                              : NSLayoutConstraint!
    
    var dynemicGapShouldCalculate                           : Bool                  = true
    var scrollViewContentHeightWithouDynemicGap             : CGFloat               = 517
    var scrollViewMinimumDynemicGap                         : CGFloat               = 50
    var scrollViewBottomConsRealValue                       : CGFloat               = 0
    var scrollViewFrameHeight                               : CGFloat?
    var contentHeight                                       : CGFloat?
    var previousVCTitle                                     : String?
    
    override func viewDidLoad() {
        self.viewDidLoad(extraFormFields: nil)
    }
    
    
    /// Overload method of `viewDidLoad`. If there are TextFields in the form that are not direct children of the ScrollView, then they can be passed through this method.
    /// - Parameter extraFormFields: Fields that are not direct child of the ScrollView.
    func viewDidLoad(extraFormFields: [AnimateTextField]? = nil) {
        super.viewDidLoad()
        if let formView = scrollView {
            viewModel?.formErrors.append(contentsOf: formView.subviews.filter{ $0 is AnimateTextField }.map{
                
                // form validation evaluated prior to user enter anything
                let textField                               = $0 as! AnimateTextField
                let error                                   = textField.error
                let validation                              = textField.validation.validate(fieldName: textField.fieldName, text: textField.finalString)?.first ?? ""
                error.onNext(validation.isNotEmpty ? FormValidationError.loginButtonDesablOnFirstLoad.rawValue : "")
                
                return error
            })
            
            if let extraFormFields = extraFormFields {
                viewModel?.formErrors.append(contentsOf: extraFormFields.map {
                    let error                               = $0.error
                    let validation                          = $0.validation.validate(fieldName: $0.fieldName, text: $0.finalString)?.first ?? ""
                    error.onNext(validation.isNotEmpty ? FormValidationError.loginButtonDesablOnFirstLoad.rawValue : "")
                    
                    return error
                })
            }
        }
        viewModel?.initialiseFormErrors()
        setupFormBindings()
    }
    
    /// Bind the actual UI with the Base class variables.
    /// - Note: Because from the subclass, IBOutlets cannot be created directly to Base class variables.
    func initialise(scrollView: UIScrollView!, dynemicGapCons: NSLayoutConstraint!, scrollViewTopCons: NSLayoutConstraint!, scrollViewBottomCons: NSLayoutConstraint!, submitButton: UIButton?, scrollViewBottomMargin: NSLayoutConstraint) {
        self.scrollView                                     = scrollView
        self.dynemicGapCons                                 = dynemicGapCons
        self.scrollViewTopCons                              = scrollViewTopCons
        self.scrollViewBottomCons                           = scrollViewBottomCons
        self.submitButton                                   = submitButton
        self.scrollViewBottomMargin                         = scrollViewBottomMargin
        
        let window                                          = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let bottomPadding: CGFloat
        if #available(iOS 11.0, *) {
            bottomPadding                                   = window?.safeAreaInsets.bottom ?? 0
        } else {
            bottomPadding                                   = 20
        }
        self.scrollViewBottomMargin?.constant               = (self.scrollViewBottomMargin?.constant ?? 0) - bottomPadding
    }
    
    override func customiseView() {
        super.customiseView()

        submitButton?.addBoarder(width: 1, cornerRadius: 5, color: AppConfig.si.colorPrimary)
        submitButton?.backgroundColor                       = AppConfig.si.colorPrimary
        submitButton?.setTitleColor(.white, for: .normal)
        submitButton?.setTitleColor(.lightGray, for: .disabled)
        
        setScrollView(keyboardHeight: 0)
    }
    
    func setupFormBindings() {
        if let viewModel = self.viewModel {
            if submitButton != nil {
                disposeBag.insert([
                    // MARK: - Outputs
                    submitButton!.rx.tap.bind(onNext: viewModel.performSubmitRequest),
                    
                    // MARK: - Inputs
                    viewModel.isValid.bind(to: submitButton!.rx.isEnabled)
                ])
            }
            // MARK: - Inputs
            viewModel.adjustForKeyboardHeightChange.observeOn(MainScheduler.instance)
                .subscribe(onNext: { [weak self] (keyboardHeight) in
                    self?.setScrollView(keyboardHeight: keyboardHeight)
                }).disposed(by: disposeBag)
        }
    }
    
    func setScrollView(keyboardHeight: CGFloat) {
        let window                                          = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let bottomPadding: CGFloat
        if #available(iOS 11.0, *) {
            bottomPadding                                   = window?.safeAreaInsets.bottom ?? 0
        } else {
            bottomPadding                                   = 20
        }
        let scrollViewContentHeightWithouDynemicGapUpdated  = scrollViewContentHeightWithouDynemicGap - bottomPadding
        
        self.navigationController?.isNavigationBarHidden    = false
        let topBarHeight                                    = self.navigationController?.navigationBar.frame.size.height ?? 0
        let statusBarHeight                                 : CGFloat!
        if #available(iOS 13.0, *) {
            statusBarHeight                                 = self.view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 44
        } else {
            statusBarHeight                                 = AppConfig.si.statusBarHeightForLessthaniOS13()
        }
        
        if keyboardHeight > 0 && self.scrollViewBottomCons.constant == self.scrollViewBottomConsRealValue {
            self.scrollViewBottomCons.constant              = keyboardHeight
        }
        if keyboardHeight == 0 && self.scrollViewBottomCons.constant != self.scrollViewBottomConsRealValue  {
            self.scrollViewBottomCons.constant              = self.scrollViewBottomConsRealValue
        }
        self.view.layoutSubviews()
        
        self.scrollViewFrameHeight                          = AppConfig.si.screenSize.height - self.scrollViewTopCons.constant - topBarHeight - statusBarHeight - self.scrollViewBottomCons.constant - bottomPadding
        
        if scrollViewFrameHeight! > scrollViewContentHeightWithouDynemicGapUpdated + scrollViewMinimumDynemicGap && dynemicGapShouldCalculate {
            self.dynemicGapCons.constant                    = scrollViewFrameHeight! - scrollViewContentHeightWithouDynemicGapUpdated
        } else {
            self.dynemicGapCons.constant                    = scrollViewMinimumDynemicGap
        }

        self.contentHeight                                  = scrollViewContentHeightWithouDynemicGapUpdated + self.dynemicGapCons.constant
                
        if keyboardHeight > 0 {
            var formStartY                                  : CGFloat = 0
            if let formView = scrollView {
                let fields = formView.subviews.filter { $0 is AnimateTextField }.map { $0 as! AnimateTextField }
                if let forcusedField = fields.first, forcusedField.isFirstResponder {
                    formStartY                              = forcusedField.frame.minY + forcusedField.frame.height
                }
            }
            
            let yOffSet                                     = self.contentHeight! - self.scrollViewFrameHeight! - formStartY > 0 ? self.contentHeight! - self.scrollViewFrameHeight! - formStartY : self.contentHeight! - self.scrollViewFrameHeight!
            
            self.scrollView.setContentOffset(CGPoint(x: 0, y: yOffSet), animated: true)
        } else {
            self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
    
    func toggleViewModeEditMode(viewMode: Bool) {
        if let formView = scrollView {
            for subView in formView.subviews.filter({ $0 is AnimateTextField }) {
                let textField                               = subView as! AnimateTextField
                textField.toggleViewModeEditMode(viewMode: viewMode)
            }
        }
    }
}


/*
    @IBOutlet public weak var _scrollView                   : BaseScrollView!
    @IBOutlet public weak var _dynemicGapCons               : NSLayoutConstraint!
    @IBOutlet public weak var _scrollViewTopCons            : NSLayoutConstraint!
    @IBOutlet public weak var _scrollViewBottomCons         : NSLayoutConstraint!
    @IBOutlet public weak var _submitButton                 : UIButton!
    @IBOutlet public weak var _scrollViewBottomMargin       : NSLayoutConstraint!
 
    override var dynemicGapShouldCalculate                  : Bool { get { return false } set {} }
    override var scrollViewContentHeightWithouDynemicGap    : CGFloat { get { return 475 } set {} }
    override var scrollViewMinimumDynemicGap                : CGFloat { get { return 50 } set {} }
    override var scrollViewBottomConsRealValue              : CGFloat { get { return 34 } set {} }
*/
