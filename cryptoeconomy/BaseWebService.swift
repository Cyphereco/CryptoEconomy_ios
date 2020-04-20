//
//  BlockChainInfoService.swift

//  Created by JJ Cherng on 2020/4/1.
//  Copyright © 2020 Cyphereco OÜ. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit
import SwiftyJSON

extension Request {
    public func debugLog() -> Self {
        #if DEBUG
            debugPrint("=======================================")
            debugPrint(self)
            debugPrint("=======================================")
        #endif
        return self
    }
}

class BaseWebServices {
    
    /**
     * Base Http Request Generator
     *
     */
    public func requestGenerator(baseUrl: String, route: String, urlParameters: String = "", parameters: Parameters? = nil, method: HTTPMethod = .get, encoding: ParameterEncoding = URLEncoding.default) -> DataRequest {
        
        let url = baseUrl + route + urlParameters
        
        return Alamofire.request(
            url,
            method: method,
            parameters: parameters,
            encoding: encoding
        )
    }
    /**
     * Base Http Request Generator
     *
     */
    public func requestGenerator(baseUrl: String, route: String, parameters: Parameters? = nil, method: HTTPMethod = .get, encoding: ParameterEncoding = URLEncoding.default) -> DataRequest {
        
        let url = baseUrl + route
        
        return Alamofire.request(
            url,
            method: method,
            parameters: parameters,
            encoding: encoding
        )
    }
    
    public func getStringResponse(_ dataRequest: DataRequest) -> Promise<String> {
        return Promise<String>.init(resolver: { (resolver) in
            dataRequest.debugLog().validate().responseString(completionHandler: { (response) in
                switch response.result {
                    
                case .success(let response):
                    Logger.shared.debug("Success:\(response)")
                    resolver.fulfill(response)
                case .failure(let error):
                    Logger.shared.debug(error)
                    
                    if let aferror = error as? AFError {
                        // Error Catch
                        switch aferror {
                        case .invalidURL:
                            ()
                        case .parameterEncodingFailed:
                            ()
                        case .multipartEncodingFailed:
                            ()
                        case .responseValidationFailed:
                            ()
                        case .responseSerializationFailed:
                            ()
                        }
                    }
                    resolver.reject(error)
                }
            })
        })
    }
   
    public func getJSONResponse(_ dataRequest: DataRequest) -> Promise<JSON> {
        return Promise<JSON>.init(resolver: { (resolver) in
            dataRequest.debugLog().validate().responseJSON(queue: DispatchQueue.global(), options: JSONSerialization.ReadingOptions.mutableContainers, completionHandler: { (response) in
                switch response.result {
                    
                case .success(let json):
                    Logger.shared.debug("Success:\(json)")
                    let content = JSON(json)
                    resolver.fulfill(content)
                case .failure(let error):
                    Logger.shared.debug(error)
                    
                    if let aferror = error as? AFError {
                        // Error Catch
                        switch aferror {
                        case .invalidURL:
                            ()
                        case .parameterEncodingFailed:
                            ()
                        case .multipartEncodingFailed:
                            ()
                        case .responseValidationFailed:
                            ()
                        case .responseSerializationFailed:
                            ()
                        }
                    }
                    resolver.reject(error)
                }
            })
        })
    }
}

enum WebServiceError: Error {
    case serviceUnavailable
    case decodeContentFailure
    case otherErrors
    
    var localizedDescription: String {
        return getLocalizedDescription()
    }
    
    private func getLocalizedDescription() -> String {
        
        switch self {
            
        case .decodeContentFailure:
            return "Decode response content failure."
        case .serviceUnavailable:
            return "Service is unavailable."
        case .otherErrors:
            return "Other errors"
        }
        
    }
}
