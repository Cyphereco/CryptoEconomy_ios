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
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText, placeholder: "search address")
                
                Spacer()
                Text("No Address")
                Spacer()
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
