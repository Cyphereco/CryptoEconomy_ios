//
//  ListItemTransaction.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/4/2.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI
struct ListItemTransaction: View {
    @ObservedObject var transactionListVM: TransactionListViewModel

    var recordTransaction: TransactionViewModel
    @State var showTransactionInfo = false

    var body: some View {
        HStack {
            HStack {
                if (AppTools.calcConfirmations(self.recordTransaction.blockHeight) < 0) {
                    Image("unconfirmed")
                }
                else if (AppTools.calcConfirmations(self.recordTransaction.blockHeight) < 1) {
                    Image("confirm0")
                }
                else if (AppTools.calcConfirmations(self.recordTransaction.blockHeight) < 2) {
                    Image("confirm1")
                }
                else if (AppTools.calcConfirmations(self.recordTransaction.blockHeight) < 3) {
                    Image("confirm2")
                }
                else if (AppTools.calcConfirmations(self.recordTransaction.blockHeight) < 4) {
                    Image("confirm3")
                }
                else if (AppTools.calcConfirmations(self.recordTransaction.blockHeight) < 5) {
                    Image("confirm4")
                }
                else if (AppTools.calcConfirmations(self.recordTransaction.blockHeight) < 6) {
                    Image("confirm5")
                }
                else {
                    Image("confirm6")
                }
            }
            VStack {
                Text(AppTools.timeToStringDate(self.recordTransaction.time))
                Text(AppTools.timeToStringTime(self.recordTransaction.time))
            }
            VStack {
                Text(self.recordTransaction.payer).lineLimit(1)
                HStack {
                    Image("send_to").padding(.top, -3).padding(.bottom, 3)
                        .padding(.leading, 5).padding(.trailing, -10)
                    Text(self.recordTransaction.payee).lineLimit(1)
                }.padding(.vertical, -10)
            }.padding(.trailing, 10).padding(.bottom, 10)
            Text(String(format: "%.4f", self.recordTransaction.amountSent))
        }.frame(alignment: .center)
        .onTapGesture {
            self.showTransactionInfo = true
        }
        .sheet(isPresented: $showTransactionInfo){
            ViewTransactionInformation()
                .addSheetTitle(AppStrings.transactionInfo)
        }
    }
}

struct ListItemTransaction_Previews: PreviewProvider {
    static var recordTransaction = TransactionViewModel(time: Date(), hash: "", payer: "1QEma6prBJscNqw7s3t8EGFcx3zF7mzWab", payee: "1QEma6prBJscNqw7s3t8EGFcx3zF7mzWab", amountSent: 0.05, amountRecv: 0.049, rawData: "", blockHeight: 2, exchangeRate: "")

    static var previews: some View {
        ListItemTransaction(transactionListVM: TransactionListViewModel(), recordTransaction: recordTransaction)
    }
}
