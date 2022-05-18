//
//  EMImage.swift
//  Elegant Media
//
//  Created by Nadeesha Chandrapala on 2022-05-18.
//

import Foundation
import ObjectMapper

class EMImage: BaseModel {
    var small   : String?
    var medium  : String?
    var large   : String?

    required init?(map: Map) {
        super.init(map: map)
    }

    override func mapping(map: Map) {
        id      = UUID().uuidString
        small   <- map["small"]
        medium  <- map["medium"]
        large   <- map["large"]
    }
}
