//
//  PageAddresses.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/3/29.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct PageAddresses: View {
    @ObservedObject var addressListVM = AddressListViewModel()
    @State var searchText: String = ""
    @State var showAddressEditor = false

    var body: some View {
        
        NavigationView {
            VStack {
                SearchBar(text: self.$searchText, placeholder: AppStrings.searchAddress)

                if addressListVM.addresses.isEmpty {
                    Spacer()
                    Text("no_address")
                    Spacer()
                }
                else {
                    List {
                        ForEach(self.addressListVM.addresses) { item in
                            if (self.searchText.isEmpty) || (item.alias.lowercased().contains(self.searchText.lowercased())) {
                                ListItemAddress(addressListVM: self.addressListVM, recordAddress: item)
                            }
                        }
                    }.id(UUID())
                }
            }
            .onTapBackground({
                UIApplication.shared.endEditing()
            })
            .sheet(isPresented: self.$showAddressEditor) {
                ViewAddressEditor(addressListVM: self.addressListVM, alias: "", address: "")
            }
            .navigationBarTitle(Text(AppStrings.addresses), displayMode: .inline)
            .navigationBarItems(trailing:
                Image("plus")
                    .setCustomDecoration(.foregroundAccent)
                .onTapGesture {
                    UIApplication.shared.endEditing()
                    self.showAddressEditor = true
                })
        }
    }
}

struct PageAddresses_Previews: PreviewProvider {
    static var previews: some View {
        PageAddresses()
    }
}
