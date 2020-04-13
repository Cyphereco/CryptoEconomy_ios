//
//  PageAddresses.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/3/29.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct PageAddresses: View {
    @State var searchText: String = ""
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appData: AppData
    @State var showAddressEditor = false

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText, placeholder: NSLocalizedString("search_address", comment: ""))
                
                if (self.appData.dataSetRecordAddress.count < 1) {
                    Spacer()
                    Text("no_address")
                    Spacer()
                }
                else {
                    List {
                        ForEach (0 ..< self.appData.dataSetRecordAddress.count) {
                            ListItemAddress(recordAddress: self.appData.dataSetRecordAddress[$0])
                        }
                    }
                }
            }
            .navigationBarTitle(Text("addresses"), displayMode: .inline)
            .navigationBarItems(trailing:
                Image("plus")
                    .foregroundColor(AppConfig.getAccentColor(colorScheme:  self.colorScheme))
                .onTapGesture {
                    self.showAddressEditor = true
                }
                .sheet(isPresented: $showAddressEditor) {
                    ViewAddressEditor(alias: "")
            })
        }
    }
}

struct PageAddresses_Previews: PreviewProvider {
    static var previews: some View {
        PageAddresses().environmentObject(AppData())
    }
}
