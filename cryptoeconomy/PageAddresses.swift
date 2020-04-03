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
    @EnvironmentObject var appData: AppData

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText, placeholder: "search address")
                
                if (self.appData.dataSetRecordAddress.count < 1) {
                    Text("No Address")
                }
                else {
                    List {
                        ForEach (0 ..< self.appData.dataSetRecordAddress.count) {
                            ListItemAddress(recordAddress: self.appData.dataSetRecordAddress[$0])
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Addresses"), displayMode: .inline)
            .navigationBarItems(trailing: NavigationLink(destination: ViewAddressEditor(alias: "")){Image("plus")})
        }
    }
}

struct PageAddresses_Previews: PreviewProvider {
    static var previews: some View {
        PageAddresses().environmentObject(AppData())
    }
}
