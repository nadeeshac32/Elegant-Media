//
//  AnimateTextField.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/7/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxAppState

public protocol Validatable {
    func validate(fieldName: String?, text: String?) -> [String]?
}

/// Form validation type that can be set to TextFields
public indirect enum FormValidation: Validatable {
    case none
    case required
    case email
    case phone
    case password
    case confirmPassword(passwordField: BehaviorSubject<String>)
    case optional
    case numberWithin(max: Int, min: Int)
    case custom(regex: String, errorMsg: String)
    case or(firstValidation: FormValidation, secondValidation: FormValidation)
    case and(firstValidation: FormValidation, secondValidation: FormValidation)
    
    public func validate(fieldName: String?, text: String?) -> [String]? {
        switch self {
        case .none: return nil
        case .required:
            if let text = text?.trimmingCharacters(in: .whitespacesAndNewlines), text.isNotEmpty {
                return nil
            } else {
                return ["\(fieldName ?? "This field") is required."]
            }
        case .email:
            let emailRegex = NSRegularExpression("[a-zA-Z0-9\\+\\.\\_\\%\\-\\+]{1,256}" +
                                                "\\@" +
                                                "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
                                                "(" +
                                                "\\." +
                                                "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
                                                ")+")
            if let text = text, emailRegex.matches(text) {
                return nil
            } else {
                return ["Invalid \(fieldName?.lowercased() ?? "input")"]
            }
        case .phone                                         :
            //  let phoneRegex = NSRegularExpression("\\+[0-9.()-]{7,15}")
            let phoneRegex = NSRegularExpression("^\\+[1-9]{1}[0-9]{7,14}$")
            if let text = text, phoneRegex.matches(text) {
                return nil
            } else {
                return ["Invalid \(fieldName?.lowercased() ?? "input")"]
            }
        case .password:
            let passwordRegex = NSRegularExpression("^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[\\w~@#$%^&*+=`|{}:;!.?\\\"()\\[\\]-]{6,}$")
            if let text = text, passwordRegex.matches(text) {
                return nil
            } else {
                return ["Invalid \(fieldName?.lowercased() ?? "input")"]
            }
        case let .confirmPassword(passwordField):
            guard let password = try? passwordField.value() else { return nil }
            if password.isEmpty {
                return ["Please enter password first."]
            }
            if let text = text, text == password {
                return nil
            } else {
                return ["password doesn't match"]
            }
        case .optional:
            if text == nil || text == "" {
                return nil
            } else {
                return ["\(fieldName?.lowercased() ?? "This") field can be empty."]
            }
        case let .numberWithin(max, min):
            let currencyFormatter                               = NumberFormatter()
            currencyFormatter.usesGroupingSeparator             = true
            currencyFormatter.numberStyle                       = NumberFormatter.Style.currency
            currencyFormatter.currencySymbol                    = ""
            currencyFormatter.locale                            = NSLocale.current
            if let number = currencyFormatter.number(from: text ?? "") {
                if number.doubleValue < Double(min) {
                    return ["Value should be more than \(min - 1)"]
                } else if number.doubleValue > Double(max) {
                    return ["Maximum value you can enter is \(max)"]
                } else {
                    return nil
                }
            } else {
                return ["Invalid value"]
            }
        case let .custom(regex, errorMsg):
            let customRegex = NSRegularExpression(regex)
            if let text = text, customRegex.matches(text) {
                return nil
            } else {
                return [errorMsg]
            }
        case let .or(firstValidation, secondValidation):
            if let firstEvaluation = firstValidation.validate(fieldName: fieldName, text: text), let secondEvaluation = secondValidation.validate(fieldName: fieldName, text: text) {
                return firstEvaluation + secondEvaluation
            } else {
                return nil
            }
            
        case let .and(firstValidation, secondValidation):
            let firstEvaluation = firstValidation.validate(fieldName: fieldName, text: text)
            let secondEvaluation = secondValidation.validate(fieldName: fieldName, text: text)
            if firstEvaluation == nil &&  secondEvaluation == nil{
                return nil
            } else {
                return (firstEvaluation ?? []) + (secondEvaluation ?? [])
            }
        }
    }
    
    public func or(validation secondValidation: FormValidation) -> FormValidation {
        return FormValidation.or(firstValidation: self, secondValidation: secondValidation)
    }
    
    public func and(validation secondValidation: FormValidation) -> FormValidation {
        return FormValidation.and(firstValidation: self, secondValidation: secondValidation)
    }
}


/// Base Text Field skeleton class that can be subclassed and implement animations for events.
/// - Note:
///     - Calls validate method in each text input value change
///     - Calls animateViewsForTextEntry
///     - Calls animateViewsForTextDisplay
///     - Calls animateViewsForErrorDisplay
///     - Calls animateViewsForErrorRemoving
///     - you have to override those methods in your subclasses as you want the animations to happen
open class AnimateTextField: UITextField {
    /**
     The type of animation a TextFieldEffect can perform.
     
     - TextEntry: animation that takes effect when the textfield has focus.
     - TextDisplay: animation that takes effect when the textfield loses focus.
     */
    public enum AnimationType: Int {
        case textEntry
        case textDisplay
    }
    
    /**
     * Closure executed when an animation has been completed.
     */
    public typealias AnimationCompletionHandler = (_ type: AnimationType)->()
    
    /**
     * UILabel that holds all the placeholder information
     */
    public let placeholderLabel = UILabel()
    
    /**
     * UILabel that holds all the error information
     */
    public let errorLabel = UILabel()
    
    /**
     * Creates all the animations that are used to leave the textfield in the "entering text" state.
     */
    open func animateViewsForTextEntry() {
        fatalError("\(#function) must be overridden")
    }
    
    /**
     * Creates all the animations that are used to leave the textfield in the "display input text" state.
     */
    open func animateViewsForTextDisplay() {
        fatalError("\(#function) must be overridden")
    }
    
    /**
     * Creates all the animations that are used to show the error message from the textfield in the "display input text" state
     */
    open func animateViewsForErrorDisplay() {
        fatalError("\(#function) must be overridden")
    }
    
    /**
     * Creates all the animations that are used to remove the error message from the textfield in the "entering text" state
     */
    open func animateViewsForErrorRemoving() {
        fatalError("\(#function) must be overridden")
    }
    
    /**
     * The animation completion handler is the best place to be notified when the text field animation has ended.
     */
    open var animationCompletionHandler: AnimationCompletionHandler?
    
    /**
     * Draws the receiver’s image within the passed-in rectangle.
     - parameter rect: The portion of the view’s bounds that needs to be updated.
     */
    open func drawViewsForRect(_ rect: CGRect) {
        fatalError("\(#function) must be overridden")
    }
    
    open func updateViewsForBoundsChange(_ bounds: CGRect) {
        fatalError("\(#function) must be overridden")
    }
    
    // MARK: - Overrides
    open override func awakeFromNib() {
        let _ = error.subscribe(onNext: { [weak self] (error) in
            if error.isNotEmpty && error != FormValidationError.loginButtonDesablOnFirstLoad.rawValue {
                self?.errorLabel.text     = error
                self?.animateViewsForErrorDisplay()
            } else {
                self?.errorLabel.text     = ""
                self?.animateViewsForErrorRemoving()
            }
        })
    }
    override open func draw(_ rect: CGRect) {
        // FIXME: Short-circuit if the view is currently selected. iOS 11 introduced
        // a setNeedsDisplay when you focus on a textfield, calling this method again
        // and messing up some of the effects due to the logic contained inside these
        // methods.
        // This is just a "quick fix", something better needs to come along.
        guard isFirstResponder == false else { return }
        drawViewsForRect(rect)
        
        UIApplication.shared.rx.didOpenAppCount
            .subscribe(onNext: { [weak self] count in
                self?.didOpenTheApp()
            })
            .disposed(by: DisposeBag())
    }
    
    override open func drawPlaceholder(in rect: CGRect) {
        // Don't draw any placeholders
    }
    
    var finalString: String {
        if self.text == "" || self.text == nil {
            return self.text ?? ""
        } else {
            return "\(self.prefixValue)\(self.text ?? "")\(self.sufixValue)"
        }
    }
    open var prefixValue                        : String = "" {
        didSet {
            self.error.onNext(validation.validate(fieldName: self.fieldName, text: self.finalString)?.first ?? "")
        }
    }
    open var sufixValue                         : String = "" {
        didSet {
            self.error.onNext(validation.validate(fieldName: self.fieldName, text: self.finalString)?.first ?? "")
        }
    }
    override open var text: String? {
        didSet {
            error.onNext("")
            if let text = text, text.isNotEmpty || isFirstResponder {
                animateViewsForTextEntry()
            } else {
                animateViewsForTextDisplay()
            }
        }
    }
    
    var error: BehaviorSubject<String> = BehaviorSubject<String>(value: "")
    
    var validation : FormValidation     = .none
    
    var fieldName: String?
    
    func didOpenTheApp() {
        errorLabel.alpha                = 0
    }
    
    func toggleViewModeEditMode(viewMode: Bool) {
        self.isEnabled                  = !viewMode
        updateBorder()
        if viewMode {
            self.animateViewsForTextEntry()
            self.errorLabel.text        = ""
            self.animateViewsForErrorRemoving()
        } else {
            animateViewsForTextDisplay()
            self.error.onNext(validation.validate(fieldName: self.fieldName, text: self.finalString)?.first ?? "")
        }
    }
    // MARK: - UITextField Observing
    override open func willMove(toSuperview newSuperview: UIView!) {
        if newSuperview != nil {
            NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidEndEditing), name: UITextField.textDidEndEditingNotification, object: self)
            NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidBeginEditing), name: UITextField.textDidBeginEditingNotification, object: self)
            NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChangeValue), name: UITextField.textDidChangeNotification, object: self)
        } else {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    /**
     * The textfield has started an editing session.
     */
    @objc open func textFieldDidBeginEditing() {
        animateViewsForTextEntry()
        self.errorLabel.text     = ""
        self.animateViewsForErrorRemoving()
    }
    
    /**
     *The textfield has ended an editing session.
     */
    @objc open func textFieldDidEndEditing() {
        animateViewsForTextDisplay()
        self.error.onNext(validation.validate(fieldName: self.fieldName, text: self.finalString)?.first ?? "")
    }
    
    /**
     *The textfield has changed it's value
     */
    @objc open func textFieldDidChangeValue() {
        self.error.onNext(validation.validate(fieldName: self.fieldName, text: self.finalString)?.first ?? "")
    }
    
    // MARK: - Interface Builder
    
    deinit {
        print("Deinit AnimateTextField")
    }
    
    override open func prepareForInterfaceBuilder() {
        drawViewsForRect(frame)
    }
    
    open func updateBorder() {
    }
    
}
