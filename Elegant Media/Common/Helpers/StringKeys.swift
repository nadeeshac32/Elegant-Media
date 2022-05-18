//
//  StringKeys.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/8/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

// MARK: - UserDefault keys
public enum Defaults: String {
    case userSignedIn
    case userGuideShown
    case reportDownloadDate
}

// MARK: - Storyboard keys
public enum Storyboards: String {
    case main           = "Main"
    case launchScreen   = "LaunchScreen"
}

// MARK: - FormValidationError
public enum FormValidationError: String {
    case loginButtonDesablOnFirstLoad = "loginButtonDesablOnFirstLoad"
}
