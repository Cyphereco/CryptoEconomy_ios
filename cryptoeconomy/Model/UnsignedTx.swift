//
//  UnsignedTx.swift
//  cryptoeconomy
//
//  Created by JJ Cherng on 2020/4/5.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import Foundation
import SwiftyJSON

class UnsignedTx {
    var from: String
    var to: String
    var amount: Double
    var fees: Int64
    var toSign: Array<String>
    var jsonData: JSON
    
    init(from: String, to: String, amount: Double, fees: Int64, toSign: Array<String>, jsonData: JSON) {
        Logger.shared.debug("from:\(from), to:\(to), amount:\(amount), fees:\(fees), toSign:\(toSign)")
        self.from = from
        self.to = from
        self.amount = amount
        self.fees = fees
        self.toSign = toSign
        self.jsonData = jsonData
    }
    
    func toString() -> String {
        return "from:\(from), to:\(to), amount:\(amount), fees:\(fees), toSign:\(toSign)"
    }
}
