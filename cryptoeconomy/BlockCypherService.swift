//
//  BlockCypherService.swift
//  cryptoeconomy
//
//  Created by JJ Cherng on 2020/4/5.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import Foundation
import PromiseKit
import Alamofire
import SwiftyJSON

/**
  Usage:
    BlockCypherService.shared.newTransaction(from: "13GNvHaSjhs8dLbEWrRP7Lvbb8ZBsKUU4P", to: "1LG9fDp3do4X2tEf4k7V4uCYhNUmSq6vL8", amountInSatoshi: 10000, fees: 1000).done { (unsignedTx) in
        // Success case
        Logger.shared.debug(unsignedTx.toString)
    }.catch { error in
        // Error case
        Logger.shared.debug(error)
    }.finally {
        // No matter success or fail will run finally
        Logger.shared.debug("finally")
    }
 */
class BlockCypherService: BaseWebServices {
    static let shared = BlockCypherService()

    let baseMainNetUrl = "https://api.blockcypher.com/v1/btc/main/"
    let baseTestNetUrl = "https://api.blockcypher.com/v1/btc/test3/"
    let pathNewTx = "txs/new"
    let pathSendTx = "txs/send"
    let pathGetTx = "txs/"
    let paramToken = "?token=7744d177ce1e4ef48c7431fcb55531b9"
    let paramInclueHex = "?includeHex=true"
    
    /*
     * Get base url for main net or test net depends on address prefix
     */
    private func _getBaseUrl(address: String) -> String {
        // Main net address must be start with '1'
        if BtcUtils.isMainNet(address: address) {
            return baseMainNetUrl
        }
        return baseTestNetUrl
    }
    
    private func _getBaseUrl(isMainNet: Bool) -> String {
        // Main net address must be start with '1'
        if isMainNet {
            return baseMainNetUrl
        }
        return baseTestNetUrl
    }
        
    /*
      New Transaction
      Usage:
        BlockCypherService.shared.newTransaction(from: "13GNvHaSjhs8dLbEWrRP7Lvbb8ZBsKUU4P", to: "1LG9fDp3do4X2tEf4k7V4uCYhNUmSq6vL8", amountInSatoshi: 10000, fees: 1000).done { (unsignedTx) in
            // Success case
            Logger.shared.debug(unsignedTx.toString)
        }.catch { error in
            // Error case
            Logger.shared.debug(error)
        }.finally {
            // No matter success or fail will run finally
            Logger.shared.debug("finally")
        }
     
     */
    func newTransaction(from: String, to: String, amountInSatoshi: Int64, fees: Int64) -> Promise<UnsignedTx> {
        // return Promise
        return Promise<UnsignedTx>.init(resolver: { (resolver) in
            // Set parametere
            // Exmaple
            //{"inputs":[{"addresses": ["1LG9fDp3do4X2tEf4k7V4uCYhNUmSq6vL8"]}],"outputs":[{"adresses": ["1QEma6prBJscNqw7s3t8EGFcx3zF7mzWab"], "value": 10000}], "fees": 1000}
            var parameters = [String: AnyObject]()
            var addresses = [String: AnyObject]()
            addresses.updateValue([from] as AnyObject, forKey: "addresses")
            parameters.updateValue([addresses] as AnyObject, forKey: "inputs")
            
            var outputs = [String: AnyObject]()
            outputs.updateValue([to] as AnyObject, forKey: "addresses")
            outputs.updateValue(amountInSatoshi as AnyObject, forKey: "value")
            parameters.updateValue([outputs] as AnyObject, forKey: "outputs")
            parameters.updateValue(fees as AnyObject, forKey: "fees")
            
            Logger.shared.debug(JSON(parameters))
            
            // generate Request
            let req = self.requestGenerator(baseUrl: _getBaseUrl(address: from), route: pathNewTx, urlParameters: paramToken, parameters: parameters, method: .post, encoding: JSONEncoding.default)

            firstly {
                // send request and get json response
                self.getJSONResponse(req)
            }.then { (responseJSON) -> Promise<UnsignedTx> in
                // process response
                return Promise<UnsignedTx>.init(resolver: { (resolver) in
                    Logger.shared.debug(responseJSON)
                    // get the unsigned tx from response
                    // The response is like:
                    // {
                    //  "tx" : {
                    //    ...
                    //    "outputs" : [
                    //      {
                    //        "addresses" : [
                    //          "13GNvHaSjhs8dLbEWrRP7Lvbb8ZBsKUU4P"
                    //        ],
                    //        "script_type" : "pay-to-pubkey-hash",
                    //        "value" : 10000,
                    //        "script" : "76a91418d8c9aea40eb32739c8f0dc4e83e70ca8a9bac688ac"
                    //      },
                    //      ...
                    //    ],
                    //    "fees" : 1000,
                    //
                    //  "tosign" : [
                    //    "14f01dbd13317541340d6eb8fe7e1399225e0af264bd25bffcc9eba9dbae975a"
                    //  ]
                    // }
                    
                    
                    // Get tosign
                    let toSigns = responseJSON["tosign"].arrayValue
                    if toSigns.count <= 0 {
                        Logger.shared.debug("No tosign")
                        resolver.reject(WebServiceError.decodeContentFailure)
                    }
                    var toSignArray = Array<String>()
                    for toSign in toSigns {
                        toSignArray.append(toSign.stringValue)
                    }
                    
                    // Calculate amount
                    var amount: Double = 0.0
                    if from == to {
                        // If the from equals to then use the amount in passed-in amount
                        amount = BtcUtils.satoshiToBtc(satoshi: amountInSatoshi)
                    } else {
                        // Sum all the value in outputs which address equals to to
                        let outputs = responseJSON["tx"]["outputs"].arrayValue
                        Logger.shared.debug(outputs)
                        for output in outputs {
                            Logger.shared.debug(output)
                            let address = output["addresses"][0].stringValue
                            Logger.shared.debug(address)
                            if address == to {
                                let value = output["value"].int64Value
                                amount += BtcUtils.satoshiToBtc(satoshi: value)
                            }
                        }
                    }
                    
                    // Get fees
                    let fees = responseJSON["tx"]["fees"].int64Value
                    let unsignedTx = UnsignedTx(from: from, to: to, amount: amount, fees: fees, toSign: toSignArray, jsonData: responseJSON)
                    resolver.fulfill(unsignedTx)
                })
            }.done { (unsignedTx) in
                // Complete
                resolver.fulfill(unsignedTx)
            }.catch(policy: .allErrors) { (error) in
                // error handling
                Logger.shared.debug(error)
                // XXX parse error
                resolver.reject(WebServiceError.otherErrors)
            }
        })
    }
    
    /*
      Complete an unsigned transaction
      Usage:
        BlockCypherService.shared.sendTransaction(unsignedTx: unsignedTx, signatures: ["71afd0977030180970e345fd4fb713bb561933f7329aefd1a2bbd99d8de88eae1d8901b26439067849ee296150f4a692803b98b140059c4f8bfe5dd04d068941"], publicKey: "02853861e2f9f802626d71242c3248a870bc51815138620d5676c2b5cf23ff9917").done { (transaction) in
            Logger.shared.debug(transaction.toString())
        }.catch { error in
            // Error case
            Logger.shared.debug(error)
        }.finally {
            // No matter success or fail will run finally
            Logger.shared.debug("finally")
        }
     */
    func sendTransaction(unsignedTx: UnsignedTx, signatures: Array<String>, publicKey: String) -> Promise<Transaction> {
        // return Promise
        return Promise<Transaction>.init(resolver: { (resolver) in
            var sigArray = Array<String>()
            var pubKeyArray = Array<String>()
            for sig in signatures {
                // convert to DER and append to array
                let der = BtcUtils.toDER(sigHexString: sig) as Data
                sigArray.append(der.hexEncodedString())
                pubKeyArray.append(publicKey)
            }
            // Add signnatures and pubkeys
            unsignedTx.jsonData["signatures"].arrayObject = sigArray
            unsignedTx.jsonData["pubkeys"].arrayObject = pubKeyArray
            
            // Convert JSON to dictionary
            var parameters = [String: AnyObject]()
            if let data = unsignedTx.jsonData.rawString()!.data(using: .utf8) {
                do {
                    parameters = try JSONSerialization.jsonObject(with: data, options: []) as! [String : AnyObject]
                } catch {
                    Logger.shared.debug("Failed to generate data for send transaction")
                    resolver.reject(WebServiceError.otherErrors)
                }
            }
            // generate Request
            let req = self.requestGenerator(baseUrl: _getBaseUrl(address: unsignedTx.from), route: pathSendTx, urlParameters: paramToken, parameters: parameters, method: .post, encoding: JSONEncoding.default)

            firstly {
                // send request and get json response
                self.getJSONResponse(req)
            }.then { (responseJSON) -> Promise<Transaction> in
                // process response
                return Promise<Transaction>.init(resolver: { (resolver) in
                    Logger.shared.debug(responseJSON)
                    // get the tx from response
                    // The response is like:
                    // {
                    //    "tx": {
                    //    "hash": "4e6dfb1415b4fba5bd257c129847c70fbd4e45e41828079c4a282680528f3a50",
                    //    ...
                    //    "fees": 12000,
                    // }
                    
                    // Get hash
                    let hash = responseJSON["tx"]["hash"].stringValue
                    // Get fees
                    let fees = responseJSON["tx"]["fees"].int64Value
                    // Get block height
                    let blockHeight = responseJSON["tx"]["block_height"].int64Value
                    // Get raw
                    let rawData = responseJSON["tx"]["hex"].stringValue
                    let tx = Transaction(hash: hash, from: unsignedTx.from, to: unsignedTx.to, amount: unsignedTx.amount, fees: fees, blockHeight: blockHeight, confirmations: -1, rawData: rawData)
                    resolver.fulfill(tx)
                })
            }.done { (tx) in
                // Complete
                resolver.fulfill(tx)
            }.catch(policy: .allErrors) { (error) in
                // error handling
                Logger.shared.debug(error)
                // XXX parse error
                resolver.reject(WebServiceError.otherErrors)
            }
        })
    }
    
    /*
      Get transaction from BlockCypher service
      Currently this function is only use to get block height, confirmations and raw data of a transaction.
      It's suggested to use BlochChainInfoService to get those transaction's info since the request might be rejected by BlockCypher due to response 429.
     */
    func getTransaction(hash: String, isMainNet: Bool = true) -> Promise<Transaction> {
        // return Promise
        return Promise<Transaction>.init(resolver: { (resolver) in
                        // generate Request
            let req = self.requestGenerator(baseUrl: _getBaseUrl(isMainNet: isMainNet), route: pathGetTx + hash, urlParameters: paramToken, parameters: nil, method: .get)

            firstly {
                // send request and get json response
                self.getJSONResponse(req)
            }.then { (responseJSON) -> Promise<Transaction> in
                // process response
                return Promise<Transaction>.init(resolver: { (resolver) in
                    Logger.shared.debug(responseJSON)
                    // get the tx from response
                    // The response is like:
                    // {
                    //    "block_height": 1696713,
                    //    "hex": "..."
                    //    "confirmations: 704
                    // }
                    
                    // Get block height
                    let blockHeight = responseJSON["block_height"].int64Value
                    // Get confirmations
                    let confirmations = responseJSON["confirmations"].int64Value
                    // Get raw data
                    let rawData = responseJSON["hex"].stringValue
                    let tx = Transaction(hash: hash, from: "", to: "", amount: 0, fees: 0, blockHeight: blockHeight, confirmations: confirmations, rawData: rawData)
                    resolver.fulfill(tx)
                })
            }.done { (tx) in
                // Complete
                resolver.fulfill(tx)
            }.catch(policy: .allErrors) { (error) in
                // error handling
                Logger.shared.debug(error)
                // XXX parse error
                resolver.reject(WebServiceError.otherErrors)
            }
        })
    }
}


