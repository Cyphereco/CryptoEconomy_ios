//
//  TextFieldBtcAddress.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/3/30.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct TextFieldBtcAddress: View {
    @State private var name = ""
    @Binding var address: String
    @ObservedObject var otkNpi = OtkNfcProtocolInterface()

    var body: some View {
        VStack {
            HStack(alignment: .bottom) {
                TextFieldWithBottomLine(hint: "recipient_address",
                                        textContent: address,
                                        textAlign: .leading,
                                        readOnly: true)
                Button(action: {}){Image("clear")}
            }
            HStack {
                Spacer()
                Button(action: {}){
                    Image("paste")}
                Button(action: {
                    self.otkNpi.beginScanning(completion: {
                        self.address = self.otkNpi.otkData.btcAddress
                    })
                }){
                    Image("read_nfc")}
                        .padding(.horizontal, 10.0)
                        .padding(.trailing, 4.0)
                Button(action: {}){
                    Image("scan_qrcode")}
                Spacer().fixedSize().frame(width: 40
                    , height: 0, alignment: .leading)
            }
        }
    }
}

struct TextFieldBtcAddress_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldBtcAddress(address: .constant(""))
    }
}
