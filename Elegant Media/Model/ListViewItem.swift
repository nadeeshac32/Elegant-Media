//
//  ListViewItem.swift
//  Elegant Media
//
//  Created by Nadeesha Chandrapala on 2022-05-18.
//

import Foundation
import ObjectMapper

class ListViewItem: BaseModel {
    var title       : String?
    var desc        : String?
    var address     : String?
    var postcode    : String?
    var phoneNumber : String?
    var latitude    : String?
    var longitude   : String?
    var image       : EMImage?

    required init?(map: Map) {
        super.init(map: map)
    }

    override func mapping(map: Map) {
        super.mapping(map: map)
        var idInt: Int?
        idInt       <- map["id"]
        id          = "\(idInt ?? 0)"
        title       <- map["title"]
        desc        <- map["description"]
        address     <- map["address"]
        postcode    <- map["postcode"]
        phoneNumber <- map["phoneNumber"]
        latitude    <- map["latitude"]
        longitude   <- map["longitude"]
        image       <- map["image"]
    }

    var latitudeCGFloat: CGFloat? {
        guard let latitude = latitude, let doubleValue = Double(latitude) else { return nil }
        return CGFloat(doubleValue)
    }
    
    var longitudeCGFloat: CGFloat? {
        guard let longitude = longitude, let doubleValue = Double(longitude) else { return nil }
        return CGFloat(doubleValue)
    }
    
}
