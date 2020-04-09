//
//  Transaction.swift
//  cryptoeconomy
//
//  Created by JJ Cherng on 2020/4/6.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import Foundation

class Transaction {
    var from: String
    var to: String
    var amount: Double
    var fees: Int64
    var hash: String
    var blockHeight: Int64
    var rawData: String
    
    init(hash: String, from: String, to: String, amount: Double, fees: Int64, blockHeight: Int64, rawData: String) {
        Logger.shared.debug("hash:\(hash), from:\(from), to:\(to), amount:\(amount), fees:\(fees), block height:\(blockHeight), raw:\(rawData)")
        self.from = from
        self.to = to
        self.amount = amount
        self.fees = fees
        self.hash = hash
        self.blockHeight = blockHeight
        self.rawData = rawData
    }
    
    func toString() -> String {
        return "hash:\(hash), from:\(from), to:\(to), amount:\(amount), fees:\(fees), block height:\(blockHeight), raw:\(rawData)"
    }
}
