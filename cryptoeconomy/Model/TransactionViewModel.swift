//
//  TransactionViewModel.swift
//  cryptoeconomy
//
//  Created by FuYuanChuang on 2020/4/14.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class TransactionViewModel: Identifiable {
    var id:UUID
    var time: Date
    var hash: String
    var payer: String
    var payee: String
    var amountSent: Double
    var amountRecv: Double
    var rawData: String
    var blockHeight: Int64
    var exchangeRate: String

    init(transaction: DBTransaction) {
        self.time = transaction.time!
        self.hash = transaction.transHash!
        self.payee = transaction.payee!
        self.payer = transaction.payer!
        self.amountRecv = transaction.amountRecv
        self.amountSent = transaction.amountSent
        self.rawData = transaction.rawData!
        self.blockHeight = transaction.blockHeight
        self.exchangeRate = transaction.exchangeRate!
        self.id = transaction.id ?? UUID()
    }

    init(time: Date, hash: String, payer: String, payee: String,
         amountSent: Double, amountRecv: Double, rawData: String,
         blockHeight: Int64, exchangeRate: String) {
        self.id = UUID()
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
    
    func toString() -> String {
        return "id: \(self.id)\n"
            + "time: \(self.time)\n"
            + "hash: \(self.hash)\n"
            + "payer: \(self.payer)\n"
            + "payee: \(self.payee)\n"
            + "amountSent: \(self.amountSent)\n"
            + "amountRecv: \(self.amountRecv)\n"
            + "rawData: \(self.rawData)\n"
            + "blockHeight: \(self.blockHeight)\n"
            + "exchangeRate: \(self.exchangeRate)\n"
    }
}

class TransactionListViewModel: ObservableObject {

    @Published
    var transactions = [TransactionViewModel]()

    init() {
        self.fetch()
    }

    func fetch() {
        self.transactions = CoreDataManager.shared.getAllTransaction().map(TransactionViewModel.init)
    }
}


