//
//  PageHistory.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/3/30.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct PageHistory: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var transactionListVM = TransactionListViewModel()

    @State var showsAlert = false

    var body: some View {
        NavigationView {
            VStack {
                if self.transactionListVM.transactions.isEmpty {
                    Text("no_transaction_record")
                }
                else {
                    List {
                        ForEach(self.transactionListVM.transactions) { item in
                            ListItemTransaction(transactionListVM: self.transactionListVM,
                                                recordTransaction: item)
                        }
                    }.id(UUID())
                }
            }
            .onTapBackground({
                UIApplication.shared.endEditing()
            })
            .navigationBarTitle(Text("history"), displayMode: .inline)
            .navigationBarItems(
                trailing: Button(action: {self.showsAlert.toggle()}) {
                    Image("delete_all")
                }
                .alert(
                    isPresented: $showsAlert,
                    content: {
                        Alert(title: Text("clear_history"),
                              message: Text("delete_all_transaction_records?"),
                              primaryButton: .default(
                                Text("delete"),
                                action: {
                                    print("Clear History")
                                    if CoreDataManager.shared.deleteAllTransaction() {
                                        self.transactionListVM.fetch()
                                    }
                                }
                            ),
                              secondaryButton: .default(
                                Text("cancel"),
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
