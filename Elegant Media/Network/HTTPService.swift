//
//  HTTPService.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/8/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import Alamofire
import ObjectMapper

class HTTPService: NSObject {
    
    var baseUrl                                     : String?
    var parameters                                  : Parameters? = [:]
    var headers                                     : HTTPHeaders? = [:]

    init(baseUrl: String! = AppConfig.si.baseUrl) { self.baseUrl = baseUrl }
    
    /// Generic method that actually do the network call
    /// - Parameters:
    ///   - method: Request method
    ///   - parameters: Request body `parameters`
    ///   - contextPath: Request `context path`
    ///   - responseType: The type that should passe the `response data` into
    ///   - arrayKey: If the response data is an array it will come under this key
    ///   - encoding: Parameter encoding type
    ///   - onError: On error call back
    ///   - completionHandler: Completion Handler for Single return object
    ///   - completionHandlerForArray: Completion Handler for Array of return objects
    ///   - completionHandlerForNull: Completion Handler for no return objects
    private func genericRequest<T: BaseModel>(method: HTTPMethod,
                                                 parameters: Parameters?,
                                                 contextPath: String,
                                                 responseType: T.Type,
                                                 arrayKey: String? = nil,
                                                 encoding: ParameterEncoding? = JSONEncoding.default,
                                                 onError: ErrorCallback? = nil,
                                                 completionHandler: ((T) -> Void)? = nil,
                                                 completionHandlerForArray: (([T]) -> Void)? = nil,
                                                 completionHandlerForNull: (() -> Void)? = nil
                                                ) {

        let urlString                               = "\(self.baseUrl!)/\(contextPath)"
        self.parameters?.update(other: parameters)
//        #if DEBUG
//        print("uslString: \(urlString)")
//        print("self.parameters: \(String(describing: self.parameters))")
//        print("headers: \(self.headers!)")
//        #endif
        let request                                 : DataRequest!
        if let encoding = encoding {
            request                                 = Alamofire.request(urlString,
                                                                 method: method,
                                                                 parameters: method == .get ? nil : self.parameters!,
                                                                 encoding: encoding,
                                                                 headers: self.headers!)
        } else {
            request                                 = Alamofire.request(urlString,
                                                                 method: method,
                                                                 parameters: method == .get ? nil : self.parameters!,
                                                                 headers: self.headers!)
        }

        request.responseJSON { response in
            var exception                           : RestClientError?
            if let errorMessage = response.error?.localizedDescription {
                exception                           = RestClientError.AlamofireError(message: errorMessage)
            } else {
                if response.data != nil {
                    
                    // Status check for backend response
                    if (200..<300).contains((response.response?.statusCode)!) {
                        //  #if DEBUG
                        //  print("response.result.value        : \(String(describing: response.result.value))")
                        //  #endif
                        
                        // Convert to Auth object
                        if responseType == UserAuth.self,
                            let serverResponse      = response.value as? Dictionary<String, AnyObject>,
                            let responseObject      = Mapper<GeneralAuthResponse>().map(JSON: serverResponse),
                            let authObject          = responseObject.data as? T {
                            completionHandler?(authObject)
                            return
                            
                        // Convert to Objects array
                        } else if let serverResponse  = response.value as? Dictionary<String, AnyObject>,
                            let responseObject      = Mapper<GeneralArrayResponse<T>>().map(JSON: serverResponse),
                            let responseItemsArrayResponse  = responseObject.data {
                            completionHandlerForArray?(responseItemsArrayResponse)
                            return
                        
                        // Convert to Object
                        } else if let serverResponse = response.value as? Dictionary<String, AnyObject>,
                            let responseObject      = Mapper<GeneralObjectResponse<T>>().map(JSON: serverResponse),
                            let object              = responseObject.data {
                            completionHandler?(object)
                            return
                        
                        // Handle when there is empty backend response
                        } else if let serverResponse = response.value as? Dictionary<String, AnyObject>,
                            let responseObject      = Mapper<GeneralEmptyDataResponse>().map(JSON: serverResponse),
                            responseObject.status?.elementsEqual("SUCCESS") == true {
                            completionHandlerForNull?()
                            return
                            
                        // Return Error if response couldn't pass to any of the above
                        } else {
                            exception               = RestClientError.JsonParseError
                        }
                    // Status check fails and Back and returns error.
                    } else if let dataObject = response.value as? Dictionary<String, Any> {
                        // Initialize Backend error
                        exception                   = RestClientError.init(jsonResult: dataObject)
                    
                    // Generate Json pass error
                    } else {
                        exception                   = RestClientError.JsonParseError
                    }
                } else {
                    exception                       = RestClientError.EmptyDataError
                }
            }

            if let error = exception {
                #if DEBUG
                print("")
                print("status code                  : \(String(describing: response.response?.statusCode))")
                print("error                        : \(error)")
                print("baseUrl                      : \(self.baseUrl ?? "")")
                print("contextPath                  : \(contextPath)")
                print("parameters                   : \(String(describing: self.parameters))")
                print("response.result.value        : \(String(describing: response.value))")
                print("request                      : \(request.debugDescription)")
                #endif
                onError?(error)
                return
            }
        }
        
    }
}

extension HTTPService {
    // This method won't be used
    func resizeImage(image: UIImage, size: CGSize, scalar: CGFloat) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, scalar)
        image.draw(in: rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}

extension HTTPService: HotelsAPIProtocol {
    func getHotels(method: HTTPMethod! = .get, onSuccess: ((_ hotels: [ListViewItem]) -> Void)?, onError: ErrorCallback?) {
        let contextPath                 = "s/6nt7fkdt7ck0lue/hotels.json"
        genericRequest(method: method!, parameters: nil, contextPath: contextPath, responseType: ListViewItem.self, onError: onError, completionHandlerForArray: { (arrayResponse) in
            onSuccess?(arrayResponse)
            return
        })
    }
}
