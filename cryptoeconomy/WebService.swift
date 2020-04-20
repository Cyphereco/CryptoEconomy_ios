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
    static func getBalance(webService: AnyClass = BlockChainInfoService.self, address: String) -> Promise<Int64> {
        if webService.self is BlockChainInfoService.Type {
            return BlockChainInfoService.getBalance(address: address)
        }
        else if webService.self is BlockCypherService.Type {
            return BlockCypherService.getBalance(address: address)
        }
        return Promise<Int64>.init(resolver: { (resolver) in
            resolver.reject(WebServiceError.serviceUnavailable)
        })
    }
}

