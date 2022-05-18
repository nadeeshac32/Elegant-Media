//
//  GeneralEmptyDataResponse.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/8/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import ObjectMapper

class GeneralEmptyDataResponse: BaseModel {
    
    var status              : String?
    var message             : String?
    var displayMessage      : String?
    var errorCode           : Int?
    
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        status              <- map["status"]
        message             <- map["message"]
        displayMessage      <- map["displayMessage"]
        errorCode           <- map["errorCode"]
    }
    
}
