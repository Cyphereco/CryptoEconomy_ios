//
//  BlockChainInfoService.swift
//  PromiseAndAlamofireDemo
//
//  Created by JJ Cherng on 2020/4/1.
//  Copyright © 2020 Cyphereco OÜ. All rights reserved.
//

import Foundation
import PromiseKit
import Alamofire
import SwiftyJSON

/**
  Usage:
    BlockChainInfoService.shared.getBalance(address: "13GNvHaSjhs8dLbEWrRP7Lvbb8ZBsKUU4P").done { (balance) in
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
class BlockChainInfoService {
    
    static let webService = BaseWebServices()
    static let baseUrl = "https://blockchain.info/"
    static let pathBalance = "balance"
    static let pathTicker = "ticker"
    static let paramActive = "active"
    static let keyFinalBalance = "final_balance"
    
    static let shared = BlockChainInfoService()
    
    static func getBalance(address: String) -> Promise<Int64> {
        // return Promise
        return Promise<Int64>.init(resolver: { (resolver) in
            //
            var parameters = [String: AnyObject]()
            
            parameters.updateValue(address as AnyObject, forKey: paramActive)
            
            // generate Request
            let req = webService.requestGenerator(baseUrl: baseUrl, route: pathBalance, parameters: parameters, method: .get)
            
            firstly {
                // send request and get json response
                webService.setupResponse(req)
            }.then { (responseJSON) -> Promise<Int64> in
                // process response
                return Promise<Int64>.init(resolver: { (resolver) in
                    Logger.shared.debug(responseJSON)
                    // get the balacne from response
                    // The response is like:
                    // {
                    //  "13GNvHaSjhs8dLbEWrRP7Lvbb8ZBsKUU4P" : {
                    //    "n_tx" : 11,
                    //    "final_balance" : 4987000,
                    //    "total_received" : 54918000
                    //  }
                    // }
                    let balance: String? = responseJSON[address][self.keyFinalBalance].stringValue
                    
                    if let balance = balance {
                        let balanceInt64: Int64? = Int64(balance)
                        if let balanceInt64 = balanceInt64 {
                            resolver.fulfill(balanceInt64)
                        }
                        else {
                            // Failed to get balance
                            resolver.reject(WebServiceError.decodeContentFailure)
                        }
                    } else {
                        resolver.reject(WebServiceError.decodeContentFailure)
                    }
                })
            }.done { (balance) in
                // Complete
                resolver.fulfill(balance)
            }.catch(policy: .allErrors) { (error) in
                // error handling
                Logger.shared.debug(error)
                // XXX parse error
                resolver.reject(WebServiceError.otherErrors)
            }
        })
    }
    
    static func updateBtcExchangeRates() -> Promise<ExchangeRates> {
        // return Promise
        return Promise<ExchangeRates>.init(resolver: { (resolver) in
            //
            var parameters = [String: AnyObject]()
                        
            parameters.updateValue("USD" as AnyObject, forKey: paramActive)

            // generate Request
            let req = webService.requestGenerator(baseUrl: baseUrl, route: pathTicker, parameters: parameters, method: .get)
            
            firstly {
                // send request and get json response
                webService.setupResponse(req)
            }.then { (responseJSON) -> Promise<ExchangeRates> in
                // process response
                return Promise<ExchangeRates>.init(resolver: { (resolver) in
                    Logger.shared.debug(responseJSON)
                    let cny: String? = responseJSON["CNY"]["last"].stringValue
                    let eur: String? = responseJSON["EUR"]["last"].stringValue
                    let jpy: String? = responseJSON["JPY"]["last"].stringValue
                    let twd: String? = responseJSON["TWD"]["last"].stringValue
                    let usd: String? = responseJSON["USD"]["last"].stringValue

                    let exchangeRates = ExchangeRates(cny: (cny! as NSString).doubleValue, eur: (eur! as NSString).doubleValue, jpy: (jpy! as NSString).doubleValue, twd: (twd! as NSString).doubleValue, usd: (usd! as NSString).doubleValue)
                    
                    resolver.fulfill(exchangeRates)
                })
            }.done{ exchangeRates in
                resolver.fulfill(exchangeRates)
            }.catch(policy: .allErrors) { (error) in
                // error handling
                Logger.shared.debug(error)
                // XXX parse error
                resolver.reject(WebServiceError.otherErrors)
            }
        })
    }

}


