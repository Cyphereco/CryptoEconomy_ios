//
//  OtkDatabase.swift
//  openturnkey
//
//  Created by FuYuan Chuang on 2020/2/15.
//  Copyright © 2020 FuYuan Chuang. All rights reserved.
//

import SQLite3
import UIKit


class DBAddressItem {
    var id: Int64?
    var alias: String = ""
    var address: String = ""

    init() {
        self.address = "";
        self.alias = "";
    }

    init(address:String, alias:String) {
        self.address = address
        self.alias = alias
    }

    init(id: Int64, address:String, alias:String) {
        self.id = id
        self.address = address
        self.alias = alias
    }
}


class DBTransItem {
    private let unitDefaultString:String = "BTC"

    var id:Int64?
    var datetime:Int64 = 0
    var payeeAddress:String = ""
    var payerAddress:String = ""
    var amount:Double = 0
    var amountUnitString:String = ""
    var fee:Double = 0
    var feeUnitString:String = ""
    var status:Int = 0
    var confirmations:Int = 0
    var hash:String = ""
    var comment:String = ""
    var rawData:String = ""

    init() {
        self.datetime = 0
        self.payeeAddress = ""
        self.payerAddress = ""
        self.amount = 0
        self.amountUnitString = self.unitDefaultString
        self.fee = 0
        self.feeUnitString = self.unitDefaultString
        self.status = 0
        self.confirmations = 0
        self.hash = ""
        self.comment = ""
        self.rawData = ""
    }

    init(id:Int64, datetime:Int64,  hash:String, payeeAddr:String, payerAddr:String, amount:Double,
         fee:Double, status:Int, comment:String, rawData:String, confirmations:Int) {
        self.id = id
        self.datetime = datetime
        self.hash = hash
        self.payeeAddress = payeeAddr
        self.payerAddress = payerAddr
        self.amount = amount
        self.fee = fee
        self.status = status
        self.comment = comment
        self.rawData = rawData
        self.confirmations = confirmations
        self.amountUnitString = self.unitDefaultString
        self.feeUnitString = self.unitDefaultString
    }
}


class DatabaseControllor {

    private var otkDB:DatabaseHelper? = nil
    private let otkDBURL: URL = {
        do {
            return try FileManager.default.url(for: .documentDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil,
                                               create:true).appendingPathComponent("otkdb.sqlite")
        }
        catch {
            fatalError("Error getting file URL from document directory.")
        }
    }()

    private let tableNameTransaction:String = "TransactionLog"
    private let tableNameAddressBook:String = "addressbook"

    private let transColId:String = "_id"
    private let transColDatetime:String = "transDateTime"
    private let transColHash:String = "hash"
    private let transColPayerAddr:String = "payerAddr"
    private let transColPayeeAddr:String = "payeeAddr"
    private let transColAmount:String = "amount"
    private let transColAmountUnitStr:String = "amountTypeStr"
    private let transColFee:String = "fee"
    private let transColFeeUnitStr:String = "feeTypeStr"
    private let transColStatus:String = "status"
    private let transColComments:String = "comments"
    private let transColRawData:String = "rowData"
    private let transColConfirmations:String = "confirmations"

    private let addrbookColId:String = "_id"
    private let addrbookColAddress:String = "address"
    private let addrbookColUserName:String = "name"

    init?() {
        otkDB = DatabaseHelper(path: otkDBURL.path)
        if (nil == otkDB) {
            return nil
        }

        // Create tables
        if (true != self.otkDB?.createTable(tableNameAddressBook, columns:[
                self.addrbookColId + " INTEGER PRIMARY KEY AUTOINCREMENT",
                self.addrbookColAddress + " VARCHAR(128) UNIQUE NOT NULL",
                self.addrbookColUserName + " VARCHAR(128) NOT NULL",
                ])) {
            print("Create Address book table failed.")
        }
        if (true != self.otkDB?.createTable(tableNameTransaction, columns:[
                transColId + " INTEGER PRIMARY KEY AUTOINCREMENT",
                transColDatetime + " DateTime NOT NULL",
                transColHash + " VARCHAR(128)",
                transColPayerAddr + " VARCHAR(64) NOT NULL",
                transColPayeeAddr + " VARCHAR(64) NOT NULL",
                transColAmount + " DOUBLE",
                transColAmountUnitStr + " VARCHAR(32)",
                transColFee + " DOUBLE",
                transColFeeUnitStr + " VARCHAR(32)",
                transColStatus + " INTEGER",
                transColComments + " TEXT",
                transColRawData + " TEXT",
                transColConfirmations + " INTEGER",
                ])) {
            print("Create Transaction table failed.")
        }
    }

    func addAddressItem(item: DBAddressItem) -> Bool {
        if item.id != nil {
            return self.updateAddressItem(item: item)
        }
        return otkDB?.insert(self.tableNameAddressBook,
                             rowInfo: [self.addrbookColAddress: "\'\(item.address)\'",
                                       self.addrbookColUserName: "\'\(item.alias)\'"]) ?? false
    }
    
    func updateAddressItem(item: DBAddressItem) -> Bool {
        if item.id == nil {
            return self.addAddressItem(item: item)
        }
        let condition = self.addrbookColId + "=" + "\(String(describing: item.id))"
        return otkDB?.update(self.tableNameAddressBook, cond: condition,
                             rowInfo: [self.addrbookColAddress: "\'\(item.address)\'",
                                       self.addrbookColUserName: "\'\(item.alias)\'"]) ?? false
    }
    
    func deleteAddressItemByAddress(address: String) -> Bool {
        let condition = "\(self.addrbookColAddress) = \'\(address)\'"
        return otkDB?.delete(self.tableNameAddressBook, cond: condition) ?? false
    }
    
    func deleteAddressItemByAlias(alias: String) -> Bool {
        let condition = "\(self.addrbookColUserName) = \'\(alias)\'"
        return otkDB?.delete(self.tableNameAddressBook, cond: condition) ?? false
    }
    
    func deleteAddressItemByAliasAndAddress(alias: String, address: String) -> Bool {
        let condition = "\(self.addrbookColUserName) = \'\(alias)\' AND \(self.addrbookColAddress) = \'\(address)\'"
        return otkDB?.delete(self.tableNameAddressBook, cond: condition) ?? false
    }

    func getAllAddressBook() -> [DBAddressItem] {
        var result = [DBAddressItem]()
        let statement = otkDB?.fetch(self.tableNameAddressBook, cond: nil, order: self.addrbookColUserName)

        while sqlite3_step(statement) == SQLITE_ROW {
            let item = DBAddressItem(address: String(cString: sqlite3_column_text(statement, 1)),
                                     alias: String(cString: sqlite3_column_text(statement, 2)))
            item.id = sqlite3_column_int64(statement, 0)
            result.append(item)
        }
        return result
    }
}
