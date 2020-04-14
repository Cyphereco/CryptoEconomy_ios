//
//  CoreDataManager.swift
//  cryptoeconomy
//
//  Created by FuYuanChuang on 2020/4/13.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {

    static let shared = CoreDataManager(moc: NSManagedObjectContext.current)

    var moc: NSManagedObjectContext

    private init(moc: NSManagedObjectContext) {
        self.moc = moc
    }

    func getAllAddresses() -> [DBAddress] {
        var addresses = [DBAddress]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DBAddress")

        do {
            addresses = try self.moc.fetch(request) as! [DBAddress]
        } catch let error as NSError {
            print(error)
        }
        return addresses
    }

    func insertAddress(addressVM: AddressViewModel) -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DBAddress")

        let addr = DBAddress(context: self.moc)
        addr.alias = addressVM.alias
        addr.address = addressVM.address

        do {
            let items = try self.moc.fetch(request)
            for item in items as! [DBAddress] {
                if (item.alias == addressVM.alias) && (item.address == addressVM.address) {
                    return true
                }
            }

            try self.moc.save()
        } catch {
            print(error)
            return false
        }

        return true
    }

    func deleteAddress(addressVM: AddressViewModel) -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DBAddress")

        do {
            let items = try self.moc.fetch(request)
            for item in items as! [DBAddress] {
                if (item.alias == addressVM.alias) && (item.address == addressVM.address) {
                    self.moc.delete(item)
                }
            }
            try self.moc.save()
        } catch {
            print(error)
            return false
        }

        return true
    }

    func getAllTransaction() -> [DBTransaction] {
        var transactions = [DBTransaction]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DBTransaction")

        do {
            transactions = try self.moc.fetch(request) as! [DBTransaction]
        } catch let error as NSError {
            print(error)
        }
        return transactions
    }

    func insertTransaction(transactionVM: TransactionViewModel) -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DBTransaction")

        let trans = DBTransaction(context: self.moc)
        trans.id = transactionVM.id
        trans.time = transactionVM.time
        trans.transHash = transactionVM.hash
        trans.payer = transactionVM.payer
        trans.payee = transactionVM.payee
        trans.amountSent = transactionVM.amountSent
        trans.amountRecv = transactionVM.amountRecv
        trans.rawData = transactionVM.rawData
        trans.blockHeight = transactionVM.blockHeight
        trans.exchangeRate = transactionVM.exchangeRate

        do {
            let items = try self.moc.fetch(request)
            for item in items as! [DBTransaction] {
                if item.id == transactionVM.id {
                    return true
                }
            }

            try self.moc.save()
        } catch {
            print(error)
            return false
        }

        return true
    }

    func deleteAllTransaction() -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DBTransaction")

        do {
            let items = try self.moc.fetch(request)
            for item in items as! [DBTransaction] {
                self.moc.delete(item)
            }
            try self.moc.save()
        } catch {
            print(error)
            return false
        }

        return true
    }

}

