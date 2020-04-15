//
//  AddressListViewModel.swift
//  cryptoeconomy
//
//  Created by FuYuanChuang on 2020/4/13.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class AddressViewModel: Identifiable {
    var alias = ""
    var address = ""
    var id = UUID()

    init(addr: DBAddress) {
        self.alias = addr.alias!
        self.address = addr.address!
    }

    init(alias: String, address: String) {
        self.alias = alias
        self.address = address
    }
}

class AddressListViewModel: ObservableObject {

    @Published
    var addresses = [AddressViewModel]()

    init() {
        self.fetchAllAddresses()
    }

    func fetchAllAddresses() {
        self.addresses = CoreDataManager.shared.getAllAddresses().map(AddressViewModel.init)
    }
}
