//
//  NSManagedObjectContext.swift
//  cryptoeconomy
//
//  Created by FuYuanChuang on 2020/4/13.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension NSManagedObjectContext {

    static var current: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}
