//
//  PageAddresses.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/3/29.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct PageAddresses: View {
    @Environment(\.colorScheme) var colorScheme
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
                    }
                }
            }
            .setDismissKeyboardBackground()
            .navigationBarTitle(Text("addresses"), displayMode: .inline)
            .navigationBarItems(trailing:
                Image("plus")
                    .foregroundColor(AppConfig.getAccentColor(colorScheme:  self.colorScheme))
                .onTapGesture {
                    UIApplication.shared.endEditing()
                    self.showAddressEditor = true
                }
                .sheet(isPresented: self.$showAddressEditor) {
                    ViewAddressEditor(addressListVM: self.addressListVM, alias: "", address: "")
            })
        }
    }
}

struct PageAddresses_Previews: PreviewProvider {
    static var previews: some View {
        PageAddresses()
    }
}
