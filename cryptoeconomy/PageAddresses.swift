//
//  PageAddresses.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/3/29.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct PageAddresses: View {
    var dataSetRecordAddress: Array<RecordAddress> = [
        RecordAddress(id: 0, alias: "Maicoin", address: "1QEma6prBJscNqw7s3t8EGFcx3zF7mzWab"),
        RecordAddress(id: 0, alias: "BitoEx", address: "1XMnd8x42kjdiwn8d9em8dm8keqD90wm2Z")]
    
    @State var searchText: String = ""
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText, placeholder: "search address")
                
                if (self.dataSetRecordAddress.count < 1) {
                    Text("No Address")
                }
                else {
                    List {
                        ForEach (0 ..< self.dataSetRecordAddress.count) {
                            ListItemAddress(recordAddress: self.dataSetRecordAddress[$0])
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Addresses"), displayMode: .inline)
            .navigationBarItems(trailing: NavigationLink(destination: ViewAddressEditor()){Image("plus")})
        }
    }
}

struct PageAddresses_Previews: PreviewProvider {
    static var previews: some View {
        PageAddresses().colorScheme(.dark)
    }
}
