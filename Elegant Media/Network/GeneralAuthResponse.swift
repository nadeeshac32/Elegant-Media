//
//  GeneralAuthResponse.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/8/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import ObjectMapper

class GeneralAuthResponse: GeneralObjectResponse<UserAuth> {
    
    var token                   : String = ""
    var refreshToken            : String = ""
    var tokenType               : String = ""
    var expiresIn               : Int    = 0
    var scope                   : String = ""
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        token                   <- map["access_token"]
        refreshToken            <- map["refresh_token"]
        tokenType               <- map["token_type"]
        expiresIn               <- map["expires_in"]
        scope                   <- map["scope"]
        
        self.data?.token        = token
    }
    
}
