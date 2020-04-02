//
//  ListItemTransaction.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/4/2.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI
struct ListItemTransaction: View {
    var recordTransaction: RecordTransaction

    var body: some View {
        HStack {
            HStack {
                if (calcConfimations(blockHeight: self.recordTransaction.blockHeight) < 0) {
                    Image("unconfirmed")
                }
                else if (calcConfimations(blockHeight: self.recordTransaction.blockHeight) < 1) {
                    Image("confirm0")
                }
                else if (calcConfimations(blockHeight: self.recordTransaction.blockHeight) < 2) {
                    Image("confirm1")
                }
                else if (calcConfimations(blockHeight: self.recordTransaction.blockHeight) < 3) {
                    Image("confirm2")
                }
                else if (calcConfimations(blockHeight: self.recordTransaction.blockHeight) < 4) {
                    Image("confirm3")
                }
                else if (calcConfimations(blockHeight: self.recordTransaction.blockHeight) < 5) {
                    Image("confirm4")
                }
                else if (calcConfimations(blockHeight: self.recordTransaction.blockHeight) < 6) {
                    Image("confirm5")
                }
                else {
                    Image("confirm6")
                }
            }
            VStack {
                Text(timeToStringDate(time: self.recordTransaction.time))
                Text(timeToStringTime(time: self.recordTransaction.time))
            }
            VStack {
                Text(self.recordTransaction.payer).lineLimit(1)
                HStack {
                    Image("send_to").padding(.top, -3).padding(.bottom, 3)
                        .padding(.leading, 5).padding(.trailing, -10)
                    Text(self.recordTransaction.payee).lineLimit(1)
                }.padding(.vertical, -10)
            }.padding(.trailing, 10).padding(.bottom, 10)
            Button(action: {}) {
                Text(String(format: "%.4f", self.recordTransaction.amountSent))
            }
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
    
    func calcConfimations(blockHeight: Int64) -> Int {
        // return Int(WebService.getCurrentBlockHeight() - blockHeight))
        return Int(blockHeight)
    }
}

struct ListItemTransaction_Previews: PreviewProvider {
    static var previews: some View {
      PreviewWrapper()
    }

    struct PreviewWrapper: View {
        var recordTransaction = RecordTransaction(id: 0, time: Date(), hash: "", payer: "1QEma6prBJscNqw7s3t8EGFcx3zF7mzWab", payee: "1QEma6prBJscNqw7s3t8EGFcx3zF7mzWab", amountSent: 0.05, amountRecv: 0.049, rawData: "", blockHeight: -1, exchangeRate: "")
        
        var body: some View {
            ListItemTransaction(recordTransaction: self.recordTransaction)
        }
    }
}
