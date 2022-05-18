//
//  Map_VM.swift
//  Elegant Media
//
//  Created by Nadeesha Chandrapala on 2022-05-19.
//

import Foundation
import RxSwift

class MapVM: BaseVM{

    var item                                            : ListViewItem

    deinit {
        print("deinit MapVM")
    }
    
    init(item: ListViewItem) {
        self.item                                       = item
        super.init()
    }
    
}
