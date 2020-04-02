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
    @Binding var time: Date
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
            }
            VStack {
                Text(timeToStringDate(time: self.time))
                Text(timeToStringTime(time: self.time))
            }
            VStack {
                Text(payerAddr).lineLimit(1)
                HStack {
                    Image("send_to").padding(.top, -3).padding(.bottom, 3)
                        .padding(.leading, 5).padding(.trailing, -10)
                    Text(payeeAddr).lineLimit(1)
                }.padding(.vertical, -10)
            }.padding(.trailing, 10).padding(.bottom, 10)
            Text(String(format: "%.4f", self.amount)).padding()
        }.frame(alignment: .center)
    }
    
    func timeToStringDate(time: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: time)
    }
    
    func timeToStringTime(time: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: time)
    }
}

struct ListItemTransaction_Previews: PreviewProvider {
    static var previews: some View {
      PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @State var confirmations = -1
        @State var now = Date()
        @State var payerAddr = "1Lx8alsiAI8x1jfaIzz82naoba38nDga"
        @State var payeeAddr = "1Fmaia13lzibIls820Naliali18nbaiL"
        @State var amount = 0.025
        
        var body: some View {
            ListItemTransaction(confirmations: self.$confirmations,
                                time: self.$now,
                                payerAddr: self.$payerAddr,
                                payeeAddr: self.$payeeAddr,
                                amount: self.$amount)
        }
    }
}
