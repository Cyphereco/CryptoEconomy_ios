//
//  WebService.swift
//  cryptoeconomy
//
//  Created by JJ Cherng on 2020/4/20.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import Foundation
import PromiseKit

protocol WebService {
    static func getBalance(address: String) -> Promise<Int64>
}

class WebServices {
    /**
      Usage:
        -Use default service provider
	     WebServices.getBalance(address: "13GNvHaSjhs8dLbEWrRP7Lvbb8ZBsKUU4P").done { (balance) in
	        // Success case
	        Logger.shared.debug(balance)
	     }.catch { error in
	        // Error case
	        Logger.shared.debug(error)
	     }.finally {
	        // No matter success or fail will run finally
	        Logger.shared.debug("finally")
	     }
      	-Assign a service provider
	     WebServices.getBalance(webServiceProvider: BlockCypherService.self as AnyClass, address: "13GNvHaSjhs8dLbEWrRP7Lvbb8ZBsKUU4P").done { (balance) in
	        // Success case
	        Logger.shared.debug(balance)
	     }.catch { error in
	        // Error case
	        Logger.shared.debug(error)
	     }.finally {
	        // No matter success or fail will run finally
	        Logger.shared.debug("finally")
	     }
     */
    static func getBalance(webServiceProvider: AnyClass = BlockChainInfoService.self, address: String) -> Promise<Int64> {
        if webServiceProvider.self is BlockChainInfoService.Type {
            return BlockChainInfoService.getBalance(address: address)
        }
        else if webServiceProvider.self is BlockCypherService.Type {
            return BlockCypherService.getBalance(address: address)
        }
        return Promise<Int64>.init(resolver: { (resolver) in
            resolver.reject(WebServiceError.serviceUnavailable)
        })
    }
}

