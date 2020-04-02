//
//  PageHistory.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/3/30.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct PageHistory: View {
    // var dataSetRecordTransaction = DBController.getDataSetRecordTransaction()
    var dataSetRecordTransaction: Array<RecordTransaction> = [
         RecordTransaction(id: 0, time: Date()-1234, hash: "", payer: "1QEma6prBJscNqw7s3t8EGFcx3zF7mzWab", payee: "1QEma6prBJscNqw7s3t8EGFcx3zF7mzWab", amountSent: 0.05, amountRecv: 0.049, rawData: "", blockHeight: -1, exchangeRate: ""),
         RecordTransaction(id: 0, time: Date()-5678, hash: "", payer: "1QEma6prBJscNqw7s3t8EGFcx3zF7mzWab", payee: "1QEma6prBJscNqw7s3t8EGFcx3zF7mzWab", amountSent: 0.063, amountRecv: 0.062, rawData: "", blockHeight: 0, exchangeRate: ""),
         RecordTransaction(id: 0, time: Date()-9876, hash: "", payer: "1QEma6prBJscNqw7s3t8EGFcx3zF7mzWab", payee: "1QEma6prBJscNqw7s3t8EGFcx3zF7mzWab", amountSent: 0.0567, amountRecv: 0.0556, rawData: "", blockHeight: 4, exchangeRate: "")]

    @State var showsAlert = false
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationView {
            VStack {
                if (self.dataSetRecordTransaction.count < 1) {
                    Text("No Transaction Record")
                }
                else {
                    List {
                        ForEach (0 ..< self.dataSetRecordTransaction.count) {
                            ListItemTransaction(recordTransaction: self.dataSetRecordTransaction[$0])
                        }
                    }
                }
            }
            .navigationBarTitle(Text("History"), displayMode: .inline)
            .navigationBarItems(
                trailing: Button(action: {self.showsAlert.toggle()}) {
                    Image("delete_all")
                }
                .alert(
                    isPresented: $showsAlert,
                    content: {
                        Alert(title: Text("Clear History"),
                              message: Text("Delete all trnsaction records?"),
                              primaryButton: .default(
                                Text("Delete"),
                                action: {print("Clear History")}
                            ),
                              secondaryButton: .default(
                                Text("Cancel"),
                                action: {print("Cancel Clear")}
                            )
                        )
                    }
                )
            )
        }
    }
}

struct PageHistory_Previews: PreviewProvider {
     static var previews: some View {
        PageHistory()
    }
}
