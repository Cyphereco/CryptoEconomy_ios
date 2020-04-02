//
//  RecordAddress.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/4/2.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import Foundation

struct RecordAddress {
    var id: Int64
    var alias: String
    var address: String
    
    init(id: Int64, alias: String, address: String) {
        self.id = id
        self.alias = alias
        self.address = address
    }
}
