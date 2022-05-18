//
//  BaseModel.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/7/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import Foundation
import ObjectMapper
import RxDataSources

/// Base Model that will extended by all the Models.
/// It will be used within the whole MVVM architecture.
class BaseModel: Mappable, IdentifiableType, Equatable {
    typealias Identity  = String
    
    var id              : String!
    var identity        : Identity { return id }
    var isSelected      : Bool = false
    
    static var arrayKey : String {
        return String(describing: self.self).lowercased()+"s"
    }
    
    init() {
        self.id         = ""
    }
    
    init(id: String) {
        self.id         = id
    }
    
    required init?(map: Map) {
        self.id         = ""
    }
    
    func mapping(map: Map) { }
    
    static func == (lhs: BaseModel, rhs: BaseModel) -> Bool {
        return lhs.identity == rhs.identity
    }
    
    /// when you're retrieving a list, when you want to sort the array, you can override this method to supply the key you want to support
    func getSortKey() -> String {
        return id
    }
}
