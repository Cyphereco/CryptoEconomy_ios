//
//  AppData.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/4/3.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import Foundation

struct RecordAddress: Identifiable {
    var id = UUID()
    var alias: String
    var address: String
}

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

class AppData: ObservableObject {
    static var demoRecordTransactions: Array<RecordTransaction> = [
         RecordTransaction(id: 0, time: Date()-1234, hash: "", payer: "1QEma6prBJscNqw7s3t8EGFcx3zF7mzWab", payee: "1QEma6prBJscNqw7s3t8EGFcx3zF7mzWab", amountSent: 0.05, amountRecv: 0.049, rawData: "", blockHeight: -1, exchangeRate: ""),
         RecordTransaction(id: 0, time: Date()-5678, hash: "", payer: "1QEma6prBJscNqw7s3t8EGFcx3zF7mzWab", payee: "1QEma6prBJscNqw7s3t8EGFcx3zF7mzWab", amountSent: 0.063, amountRecv: 0.062, rawData: "", blockHeight: 0, exchangeRate: ""),
         RecordTransaction(id: 0, time: Date()-9876, hash: "", payer: "1QEma6prBJscNqw7s3t8EGFcx3zF7mzWab", payee: "1QEma6prBJscNqw7s3t8EGFcx3zF7mzWab", amountSent: 0.0567, amountRecv: 0.0556, rawData: "", blockHeight: 4, exchangeRate: "")]
    
    // assign to demo dataSet for demo/test
    @Published var dataSetRecordAddress: [RecordAddress] = [RecordAddress]()
    @Published var dataSetRecordTransaction: Array<RecordTransaction> = demoRecordTransactions //[]

    private var dbControllor: DatabaseControllor?

    init() {
        self.dbControllor = DatabaseControllor()
        self.fetchAddress()
    }

    func fetchAddress() {
        self.dataSetRecordAddress.removeAll()
        for item in self.dbControllor!.getAllAddressBook() {
            self.dataSetRecordAddress.append(RecordAddress(alias: item.alias, address: item.address))
        }
    }
}
