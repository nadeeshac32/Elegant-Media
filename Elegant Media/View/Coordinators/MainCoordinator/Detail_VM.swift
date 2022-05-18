//
//  Detail_VM.swift
//  Elegant Media
//
//  Created by Nadeesha Chandrapala on 2022-05-19.
//

import Foundation
import RxSwift

class DetailVM: BaseVM{

    var item                                            : ListViewItem
    
    // MARK: - Inputs
    var locationBtnTapped                               = PublishSubject<Bool>()
    
    // MARK:- Output
    let showLocationVC                                  : Observable<ListViewItem>
    
    deinit {
        print("deinit DetailVM")
    }
    
    init(item: ListViewItem) {
        self.item                                       = item
        showLocationVC                                  = locationBtnTapped.map({ (_) in return item })
        super.init()
    }
    
}
