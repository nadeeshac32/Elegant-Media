//
//  Plist.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/8/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import Foundation

/// This class is used to retrieve data from plist file.
struct Plist {
    let name                : String
    var sourcePath          : String? {
        guard let path = Bundle.main.path(forResource: name, ofType: "plist") else { return .none }
        return path
    }
    
    init?(name:String) {
        self.name           = name
        let fileManager     = FileManager.default
        guard let source    = sourcePath else { return nil }
        guard fileManager.fileExists(atPath: source) else { return nil }
    }
    
    func getValuesInPlistFile() -> NSDictionary? {
        let fileManager     = FileManager.default
        if fileManager.fileExists(atPath: sourcePath!) {
            guard let dict  = NSDictionary(contentsOfFile: sourcePath!) else { return .none }
            return dict
        } else {
            return .none
        }
    }
}
