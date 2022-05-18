//
//  BaseFormVM.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/7/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

/// Base ViewModel that supports BaseFormVC.
class BaseFormVM: BaseVM {
    
    var formErrors              = [BehaviorSubject<String>]()
    
    // MARK: - Inputs
    
    // MARK: - Outputs
    var isValid                 : Observable<Bool>          = PublishSubject<Bool>()
    
    // MARK: - Class methods
    func initialiseFormErrors() {
        self.isValid            = Observable.combineLatest(self.formErrors.map {$0.asObservable()}) { (errors) in
            return errors.filter{$0.isNotEmpty}.count == 0
        }
    }
    
    func performSubmitRequest() { }
}
