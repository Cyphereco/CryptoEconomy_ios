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
    static func updateBtcExchangeRates() -> Promise<ExchangeRates>
    static func newTransaction(from: String, to: String, amountInSatoshi: Int64, fees: Int64) -> Promise<UnsignedTx>
    static func sendTransaction(unsignedTx: UnsignedTx, signatures: Array<String>, publicKey: String) -> Promise<Transaction>
    static func getConfirmations(hash: String, isMainNet: Bool) -> Promise<Int64>
    static func getRawTranaction(hash: String, isMainNet: Bool) -> Promise<String>
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
    
    static func updateBtcExchangeRates(webServiceProvider: AnyClass = BlockChainInfoService.self) -> Promise<ExchangeRates> {
        if webServiceProvider.self is BlockChainInfoService.Type {
            return BlockChainInfoService.updateBtcExchangeRates()
        }
        else if webServiceProvider.self is BlockCypherService.Type {
            return BlockCypherService.updateBtcExchangeRates()
        }
        
        return Promise<ExchangeRates>.init(resolver: { (resolver) in
            resolver.reject(WebServiceError.serviceUnavailable)
        })
    }
    
    static func newTransaction(webServiceProvider: AnyClass = BlockCypherService.self, from: String, to: String, amountInSatoshi: Int64, fees: Int64) -> Promise<UnsignedTx> {
        if webServiceProvider.self is BlockChainInfoService.Type {
            return BlockChainInfoService.newTransaction(from: from, to: to, amountInSatoshi: amountInSatoshi, fees: fees)
        }
        else if webServiceProvider.self is BlockCypherService.Type {
            return BlockCypherService.newTransaction(from: from, to: to, amountInSatoshi: amountInSatoshi, fees: fees)
        }
        
        return Promise<UnsignedTx>.init(resolver: { (resolver) in
            resolver.reject(WebServiceError.serviceUnavailable)
        })
    }
    
    static func sendTransaction(webServiceProvider: AnyClass = BlockCypherService.self, unsignedTx: UnsignedTx, signatures: Array<String>, publicKey: String) -> Promise<Transaction> {
        if webServiceProvider.self is BlockChainInfoService.Type {
            return BlockChainInfoService.sendTransaction(unsignedTx: unsignedTx, signatures: signatures, publicKey: publicKey)
        }
        else if webServiceProvider.self is BlockCypherService.Type {
            return BlockCypherService.sendTransaction(unsignedTx: unsignedTx, signatures: signatures, publicKey: publicKey)
        }
        
        return Promise<Transaction>.init(resolver: { (resolver) in
            resolver.reject(WebServiceError.serviceUnavailable)
        })
    }
    
    static func getConfirmations(webServiceProvider: AnyClass = BlockCypherService.self, hash: String, isMainNet: Bool = true) -> Promise<Int64> {
        if webServiceProvider.self is BlockChainInfoService.Type {
            return BlockChainInfoService.getConfirmations(hash: hash, isMainNet: isMainNet)
        }
        else if webServiceProvider.self is BlockCypherService.Type {
            return BlockCypherService.getConfirmations(hash: hash, isMainNet: isMainNet)
        }
        
        return Promise<Int64>.init(resolver: { (resolver) in
            resolver.reject(WebServiceError.serviceUnavailable)
        })
    }
    
    static func getRawTranaction(webServiceProvider: AnyClass = BlockCypherService.self, hash: String, isMainNet: Bool = true) -> Promise<String> {
        if webServiceProvider.self is BlockChainInfoService.Type {
            return BlockChainInfoService.getRawTranaction(hash: hash, isMainNet: isMainNet)
        }
        else if webServiceProvider.self is BlockCypherService.Type {
            return BlockCypherService.getRawTranaction(hash: hash, isMainNet: isMainNet)
        }
        
        return Promise<String>.init(resolver: { (resolver) in
            resolver.reject(WebServiceError.serviceUnavailable)
        })
    }
}

