//
//  UnsignedTx.swift
//  cryptoeconomy
//
//  Created by JJ Cherng on 2020/4/5.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import Foundation

class UnsignedTx {
    var from: String
    var to: String
    var amount: Double
    var fees: Int64
    var toSign: Array<String>
    
    init(from: String, to: String, amount: Double, fees: Int64, toSign: Array<String>) {
        Logger.shared.debug("from:\(from), to:\(to), amount:\(amount), fees:\(fees), toSign:\(toSign)")
        self.from = from
        self.to = from
        self.amount = amount
        self.fees = fees
        self.toSign = toSign
    }
    
    func toString() -> String {
        return "from:\(from), to:\(to), amount:\(amount), fees:\(fees), toSign:\(toSign)"
    }
}
