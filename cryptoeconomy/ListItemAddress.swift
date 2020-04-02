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

    var body: some View {
        HStack {
            Button(action: {}) {
                VStack(alignment: .leading) {
                    Text(self.recordAddress.alias).fontWeight(.bold).lineLimit(1)
                    Text(self.recordAddress.address).lineLimit(1).padding(.leading, 20)
                }
            }
            Spacer()
            Button(action: {}){
                Image("delete")}.buttonStyle(BorderlessButtonStyle())
            Button(action: {}){
                Image("qrcode")}.buttonStyle(BorderlessButtonStyle()).padding(.horizontal, 10).padding(.trailing, 5)
            Button(action: {}){
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
