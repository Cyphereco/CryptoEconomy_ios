//
//  RecordTransaction.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/4/2.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import Foundation

struct RecordTransaction {
    var id: Int64
    var time: Date
    var hash: String
    var payer: String
    var payee: String
    var amountSent: Double
    var amountRecv: Double
    var rawData: String
    var blockHeight: Int64
    var exchangeRate: String
    
    init(id: Int64, time: Date, hash: String, payer: String,
         payee: String, amountSent: Double, amountRecv: Double,
         rawData: String, blockHeight: Int64, exchangeRate: String) {
        self.id = id
        self.time = time
        self.hash = hash
        self.payer = payer
        self.payee = payee
        self.amountSent = amountSent
        self.amountRecv = amountRecv
        self.rawData = rawData
        self.blockHeight = blockHeight
        self.exchangeRate = exchangeRate
    }

}
