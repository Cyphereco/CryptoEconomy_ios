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


class BlockChainInfoService: WebService {
    static let webService = BaseWebServices()
    static let baseMainNetUrl = "https://blockchain.info/"
    static let baseTestNetUrl = "https://testnet.blockchain.info/"
    static let txFeesUrl = "https://bitcoinfees.earn.com/api/v1/fees/recommended"
    
    static let pathBalance = "balance"
    static let pathLatestBlock = "latestblock"
    static let pathRawTx = "rawtx/"
    static let paramActive = "active"
    static let pathTicker = "ticker"
    static let keyFinalBalance = "final_balance"
    static let keyHeight = "height"
    static let paramFormatHex = "?format=hex"
    
    static let shared = BlockChainInfoService()
    
    /*
     * Get base url for main net or test net depends on address prefix
     */
    static private func _getBaseUrl(address: String) -> String {
        // Main net address must be start with '1'
        if BtcUtils.isMainNet(address: address) {
            return BlockChainInfoService.baseMainNetUrl
        }
        return BlockChainInfoService.baseTestNetUrl
    }
    
    static private func _getBaseUrl(isMainNet: Bool) -> String {
        if isMainNet {
            return BlockChainInfoService.baseMainNetUrl
        }
        return BlockChainInfoService.baseTestNetUrl
    }
        
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
    static func getBalance(address: String) -> Promise<Int64> {
        // return Promise
        return Promise<Int64>.init(resolver: { (resolver) in
            //
            var parameters = [String: AnyObject]()
            
            parameters.updateValue(address as AnyObject, forKey: paramActive)
            
            // generate Request
            let req = webService.requestGenerator(baseUrl: _getBaseUrl(address: address), route: pathBalance, parameters: parameters, method: .get)
            
            firstly {
                // send request and get json response
                webService.getJSONResponse(req)
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
                    let b = responseJSON[address][self.keyFinalBalance].int64Value
                    Logger.shared.debug(b)
                    resolver.fulfill(b)
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
    
    /*
     * https://blockchain.info/latestblock
     */
    static func getLatestBlockHeight(isMainNet: Bool = true) -> Promise<Int64> {
        // return Promise
        return Promise<Int64>.init(resolver: { (resolver) in
            // generate Request
            let req = webService.requestGenerator(baseUrl: _getBaseUrl(isMainNet: isMainNet), route: pathLatestBlock, parameters: nil, method: .get)
            
            firstly {
                // send request and get json response
                webService.getJSONResponse(req)
            }.then { (responseJSON) -> Promise<Int64> in
                // process response
                return Promise<Int64>.init(resolver: { (resolver) in
                    Logger.shared.debug(responseJSON)
                    // get the latest block from response
                    // The response is like:
                    //  {"hash":"000000000000000000053543df1915c4a3e9024589f21dd4310fb42e6630ceeb","time":1586899972,"block_index":0,"height":625993,"txIndexes":[]}
                    let height = responseJSON[self.keyHeight].int64Value
                    Logger.shared.debug(height)
                    resolver.fulfill(height)
                })
            }.done { (height) in
                // Complete
                resolver.fulfill(height)
            }.catch(policy: .allErrors) { (error) in
                // error handling
                Logger.shared.debug(error)
                // XXX parse error
                resolver.reject(WebServiceError.otherErrors)
            }
        })
    }
    
    /*
     * REST API example:
     * https://blockchain.info/rawtx/86d258468e4a3fe4d7c3eca7b52565871165431a20cbeb1963b3a9a422bc8be3?format=hex
     */
    static func getRawTranaction(hash: String, isMainNet: Bool = true) -> Promise<String> {
        // return Promise
        return Promise<String>.init(resolver: { (resolver) in
            // Blockchaininfo doesn't get test net tx
            if isMainNet == false {
                resolver.reject(WebServiceError.serviceUnavailable)
                return
            }
            // generate Request
            let req = webService.requestGenerator(baseUrl: _getBaseUrl(isMainNet: isMainNet), route: pathRawTx + hash + paramFormatHex, parameters: nil, method: .get)
            
            firstly {
                // send request and get string response
                webService.getStringResponse(req)
            }.then { (response) -> Promise<String> in
                // process response
                return Promise<String>.init(resolver: { (resolver) in
                    Logger.shared.debug(response)
                    resolver.fulfill(response)
                })
            }.done { (transaction) in
                // Complete
                resolver.fulfill(transaction)
            }.catch(policy: .allErrors) { (error) in
                // error handling
                Logger.shared.debug(error)
                // XXX parse error
                resolver.reject(WebServiceError.otherErrors)
            }
        })
    }
    
    /*
     * Get block hight
     */
    static func getBlockHeight(hash: String, isMainNet: Bool = true) -> Promise<Int64> {
        // return Promise
        return Promise<Int64>.init(resolver: { (resolver) in
            // Blockchaininfo doesn't get test net tx
            if isMainNet == false {
                resolver.reject(WebServiceError.serviceUnavailable)
                return
            }
            // generate Request
            let req = webService.requestGenerator(baseUrl: _getBaseUrl(isMainNet: isMainNet), route: pathRawTx + hash, parameters: nil, method: .get)
            
            firstly {
                // send request and get json response
                webService.getJSONResponse(req)
            }.then { (responseJSON) -> Promise<Int64> in
                // process response
                return Promise<Int64>.init(resolver: { (resolver) in
                    Logger.shared.debug(responseJSON)
                    // get the transaction contnet from response
                    // The response is like:
                    //  ...
                    let blockHeight = responseJSON["block_height"].int64Value
                    resolver.fulfill(blockHeight)
                })
            }.done { (transaction) in
                // Complete
                resolver.fulfill(transaction)
            }.catch(policy: .allErrors) { (error) in
                // error handling
                Logger.shared.debug(error)
                // XXX parse error
                resolver.reject(WebServiceError.otherErrors)
            }
        })
    }
    
    /*
     * Get confirmations
     */
    static func getConfirmations(hash: String, isMainNet: Bool = true) -> Promise<Int64> {
        // return Promise
        return Promise<Int64>.init(resolver: { (resolver) in
            // Blockchaininfo doesn't get test net tx
            if isMainNet == false {
                return resolver.reject(WebServiceError.serviceUnavailable)
            }
            
            var latestBlockHeight: Int64 = -1
            getLatestBlockHeight(isMainNet: isMainNet).then { (lbh) -> Promise<Int64> in
                latestBlockHeight = lbh
                return self.getBlockHeight(hash: hash, isMainNet: isMainNet)
            }.done { (blockHeight) in
                // Complete
                resolver.fulfill(latestBlockHeight - blockHeight + 1)
            }.catch(policy: .allErrors) { (error) in
                // error handling
                Logger.shared.debug(error)
                // XXX parse error
                resolver.reject(WebServiceError.otherErrors)
            }
        })
    }
    static func updateBtcExchangeRates(isMainNet: Bool = true) -> Promise<ExchangeRates> {
        // return Promise
        return Promise<ExchangeRates>.init(resolver: { (resolver) in
            // generate Request
            let req = webService.requestGenerator(baseUrl: _getBaseUrl(isMainNet: isMainNet), route: pathTicker, parameters: nil, method: .get)
            
            firstly {
                // send request and get json response
                webService.getJSONResponse(req)
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

    static func updateBestTxFees() -> Promise<BestFees> {
        // return Promise
        return Promise<BestFees>.init(resolver: { (resolver) in
            // generate Request
            let req = webService.requestGenerator(baseUrl: txFeesUrl, route: "", parameters: nil, method: .get)
            
            firstly {
                // send request and get json response
                webService.getJSONResponse(req)
            }.then { (responseJSON) -> Promise<BestFees> in
                // process response
                return Promise<BestFees>.init(resolver: { (resolver) in
                    Logger.shared.debug(responseJSON)
                    let high: String? = responseJSON["fastestFee"].stringValue
                    let mid: String? = responseJSON["halfHourFee"].stringValue
                    let low: String? = responseJSON["hourFee"].stringValue

                    let bestFees = BestFees(low: Int((low! as NSString).intValue), mid: Int((mid! as NSString).intValue), high: Int((high! as NSString).intValue))
                    
                    resolver.fulfill(bestFees)
                })
            }.done{ bestFees in
                resolver.fulfill(bestFees)
            }.catch(policy: .allErrors) { (error) in
                // error handling
                Logger.shared.debug(error)
                // XXX parse error
                resolver.reject(WebServiceError.otherErrors)
            }
        })
    }
}


