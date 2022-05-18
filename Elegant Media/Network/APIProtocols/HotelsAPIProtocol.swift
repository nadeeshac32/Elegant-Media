//
//  HotelsAPIProtocol.swift
//  Elegant Media
//
//  Created by Nadeesha Chandrapala on 2022-05-18.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import Alamofire

protocol HotelsAPIProtocol {
    func getHotels(method: HTTPMethod!, onSuccess: ((_ hotels: [ListViewItem]) -> Void)?, onError: ErrorCallback?)
}
