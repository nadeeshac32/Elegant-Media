# Elegant-Media
Elegant Media iOS Practical Assignment

## Description
This project has used some base classes which were developed by me. Which can be extended and implement on that. Supports MVVM-C Architecture and UI binding is powered by [RxSwift](https://github.com/ReactiveX/RxSwift). The main purpose of this base classes is to develop efficient architecture for the applications and to reduce as much as development time.

## Architectural components
- [x] Base MVVM-Coodinator architecture.
- [x] Base Table view controller & Base Collection view controller that adopts to MVVM architecture.
- [x] Base Table View Controller and Base Collection View Controller supports,
  - API Pagination,
  - Static data loading,
  - Search,
  - Multiple list views & grid views in one screen,
  - Section headers (Dynemic and custom).
  - Can eliminate all the boilerplate code and you only have to customise your UITableViewCell/UICollectionViewCell which extends from BaseTVCell/BaseCVCell.

## Reusable components
- [x] Facebook SignIn - Social sign in capability with these protocols and there default implementations. Adopts to Base MVVM architecture.

## Requirements:
- [x] Xcode Version 10.3 (Developed on Xcode 13.3.1)
- [x] Swift 5
- [x] iOS Version 9.0 or above


 ## Running Xcode Project and General changes
 - Open the project(.xcworkspace file) in Xcode.
 - Select Environment: Go to Project(Elegant Media) -> Elegant Media -> Application -> AppConfig.swift (line 41) -> Change environment which you want to run (.prod / .dev / .qa).
 - Now you can simply run the project in simulator.

## Special notes
 - Please note that the image urls that comes with the API response are not working.

## Use this test account to Sign in with Facebook
 - email: "johndoe20220518@gmail.com"
 - password: "johnDoe20220518."
  
## Project Architecture and Related details

Specifics                 | Details
--------------------------|------------------------------------------------------------------------
| Architecture - MVVM-C   | Used RxSwift to bind View and ViewModel. Coodinator are responsible for navigation flow
| Networking - Alamofire  | `Network` folder -<br/>- `Network\HTTPService.swift` <br/>- `Network\APIProtocols` folder - All the protocols will be implementing in `HTTPService.swift` <br/>
| Base classes            | `Common/Components`, `Common/Architectural` folders - All the base & generic classes & Common components reside within this folder. All the other classes are inherited from the classes which are within this folders
| Models                  | `Models` folder - All the models used by the app reside within this folder. Almost all the models which are consumed by the Network Services are extending `BaseModel` class
| Views                   | `Views` folder - All the UI elements reside within this folder. (Storyboards, ViewControllers, ViewModels, Common Reusable components, TableView Cells)
| App Config         	    | Used a simple Singleton class to keep the configuration parameters. All the values that are used by AppConfig are stored in `Configuration.plist`


## Dependancies

Name                          | purpose
--------------------------    | -----------------------------------------------------
[Alamofire](https://github.com/Alamofire/Alamofire) | Network library
[ObjectMapper](https://github.com/tristanhimmelman/ObjectMapper) | Mapping JSON objects into Swift classes
[KeychainSwift](https://github.com/evgenyneu/keychain-swift) | Wraper to store data securely in Keychain.
[RxCocoa](https://github.com/ReactiveX/RxSwift) | This is a Swift version of Rx.
[FBSDKLoginKit](https://developers.facebook.com/docs/facebook-login/ios/) | Google Sign in functionality

## License

Copyright © 2022 Nadeesha Chandrapala. All rights reserved.
