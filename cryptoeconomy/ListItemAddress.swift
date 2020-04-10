//
//  ListItemAddress.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/4/2.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct ListItemAddress: View {
    var recordAddress: RecordAddress
    @EnvironmentObject var appConfig: AppConfig
    @Environment(\.colorScheme) var colorScheme
    @State var showAddressEditor = false

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(self.recordAddress.alias).fontWeight(.bold).lineLimit(1)
                Text(self.recordAddress.address).lineLimit(1).padding(.leading, 20)
            }
            .onTapGesture {
                self.showAddressEditor = true
            }
            .sheet(isPresented: $showAddressEditor) {
                ViewAddressEditor(alias: self.recordAddress.alias, address: self.recordAddress.address)
                    .foregroundColor(AppConfig.getAccentColor(colorScheme:  self.colorScheme))}
            Spacer()
            Button(action: {}){
                Image("delete")}.buttonStyle(BorderlessButtonStyle())
            Button(action: {}){
                Image("qrcode")}.buttonStyle(BorderlessButtonStyle()).padding(.horizontal, 10).padding(.trailing, 5)
            Button(action: {
                self.appConfig.payeeAddr = self.recordAddress.address
                self.appConfig.pageSelected = 0
            }){
                Image("send")}.buttonStyle(BorderlessButtonStyle())
        }.padding(.horizontal, 5)
    }
}

struct ListItemAddress_Previews: PreviewProvider {
    static var previews: some View {
      PreviewWrapper()
    }

    struct PreviewWrapper: View {
        var recordAddress = RecordAddress(id: 0, alias: "Maicoin", address: "1QEma6prBJscNqw7s3t8EGFcx3zF7mzWab")
        
        var body: some View {
            ListItemAddress(recordAddress: self.recordAddress)
        }
    }
}
