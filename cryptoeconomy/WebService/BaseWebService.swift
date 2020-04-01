//
//  BlockChainInfoService.swift

//  Created by JJ Cherng on 2020/4/1.
//  Copyright © 2020 Cyphereco OÜ. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit
import SwiftyJSON

class BaseWebServices {
    
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
   
    public func setupResponse(_ dataRequest: DataRequest) -> Promise<JSON> {
        return Promise<JSON>.init(resolver: { (resolver) in
            dataRequest.validate().responseJSON(queue: DispatchQueue.global(), options: JSONSerialization.ReadingOptions.mutableContainers, completionHandler: { (response) in
                
                switch response.result {
                    
                case .success(let json):
                    Logger.shared.debug("Success")
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
    case decodeContentFailure
    case otherErrors
    
    var localizedDescription: String {
        return getLocalizedDescription()
    }
    
    private func getLocalizedDescription() -> String {
        
        switch self {
            
        case .decodeContentFailure:
            return "Decode response content failure."
        case .otherErrors:
            return "Other errors"
        }
        
    }
}
