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
        request.sortDescriptors = [NSSortDescriptor(key: "alias", ascending: true), NSSortDescriptor(key: "address", ascending: true)]

        do {
            addresses = try self.moc.fetch(request) as! [DBAddress]
        } catch let error as NSError {
            print(error)
        }
        return addresses
    }

    func insertAddress(addressVM: AddressViewModel) -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DBAddress")
        request.predicate = NSPredicate(format: "alias == %@", addressVM.alias as CVarArg)

        do {
            let items = try self.moc.fetch(request)

            if items.count > 0 {
                return false
            }
            
            let addr = DBAddress(context: self.moc)
            addr.id = addressVM.id
            addr.alias = addressVM.alias
            addr.address = addressVM.address

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
        request.predicate = NSPredicate(format: "id == %@", addressVM.id as CVarArg)

        do {
            let items = try self.moc.fetch(request)
            for item in items as! [DBAddress] {
                self.moc.delete(item)
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
        request.sortDescriptors = [NSSortDescriptor(key: "time", ascending: false)]
        
        do {
            transactions = try self.moc.fetch(request) as! [DBTransaction]
        } catch let error as NSError {
            print(error)
        }
        return transactions
    }

    func insertTransaction(transactionVM: TransactionViewModel) -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DBTransaction")
//        request.predicate = NSPredicate(format: "hash == %@", transactionVM.hash as CVarArg)

        do {
            let items = try self.moc.fetch(request)
            
//            if items.count > 0 {
//                return false
//            }

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
    
    func getPreviousTransaction(_ transaction: TransactionViewModel) -> TransactionViewModel? {
        let transactions = getAllTransaction().map(TransactionViewModel.init)
        if let index = transactions.firstIndex(where: {$0.id == transaction.id}) {
            return index > 0 ? transactions[index - 1] : nil
        }
        return nil
    }

    func getNextTransaction(_ transaction: TransactionViewModel) -> TransactionViewModel? {
        let transactions = getAllTransaction().map(TransactionViewModel.init)
        if let index = transactions.firstIndex(where: {$0.id == transaction.id}) {
            return index < transactions.count - 1 ? transactions[index + 1] : nil
        }
        return nil
    }

    func deleteTransaction(transactionVM: TransactionViewModel) -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DBTransaction")
        request.predicate = NSPredicate(format: "id == %@", transactionVM.id as CVarArg)

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

