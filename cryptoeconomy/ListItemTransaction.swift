//
//  ListItemTransaction.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/4/2.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI
struct ListItemTransaction: View {
    @Binding var confirmations: Int
    @Binding var payerAddr: String
    @Binding var payeeAddr: String
    @Binding var amount: Double

    var body: some View {
        HStack {
            HStack {
                if (confirmations < 0) {
                    Image("unconfirmed")
                }
                else if (confirmations < 1) {
                    Image("confirm0")
                }
                else if (confirmations < 2) {
                    Image("confirm1")
                }
                else if (confirmations < 3) {
                    Image("confirm2")
                }
                else if (confirmations < 4) {
                    Image("confirm3")
                }
                else if (confirmations < 5) {
                    Image("confirm4")
                }
                else if (confirmations < 6) {
                    Image("confirm5")
                }
                else {
                    Image("confirm6")
                }
            }.padding()
            VStack {
                Text("")
            }
            VStack {
                Text(payerAddr)
                HStack {
                    Image("send_to").padding(.vertical, -20)
                    Text(payeeAddr)
                }
            }.padding(.trailing, 30)
            Text("\(self.amount)").padding()
        }.frame(alignment: .center)
    }
}

struct ListItemTransaction_Previews: PreviewProvider {
    static var previews: some View {
      PreviewWrapper()
    }

    struct PreviewWrapper: View {
      @State var confirmations = -1
      @State var payerAddr = "1Lx8alsiAI8x1jfaIzz82naoba38nDga"
      @State var payeeAddr = "1Fmaia13lzibIls820Naliali18nbaiL"
        @State var amount = 0.025
      var body: some View {
        ListItemTransaction(confirmations: self.$confirmations,
                            payerAddr: self.$payerAddr,
                            payeeAddr: self.$payeeAddr,
                            amount: self.$amount)
      }
    }
}
