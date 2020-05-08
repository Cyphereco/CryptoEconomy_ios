//
//  ViewTransactionRecord.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/4/11.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct ViewTransactionInformation: View {
    let dismiss: ()->Void
    @State var transactionList: TransactionListViewModel
    @State var transaction: TransactionViewModel
    @EnvironmentObject var appController: AppController
    @State var showAlert = false
    @State var msg = ""
    @State var showLocalCurrency = false
    
    @Environment(\.presentationMode) var presentationMode
    @State var confirmations = "Unconfirmed"

    var body: some View {
        GeometryReader {geometry in
            VStack {
                HStack {
                    VStack(alignment: .trailing) {
                        Text("\(AppStrings.date)/\(AppStrings.time) :")
                            .font(.headline)
                        Text("\(AppStrings.result) :")
                            .font(.headline)
                    }
                    .frame(width: geometry.size.width / 4)


                    VStack(alignment: .leading) {
                        Text(AppTools.formatTime(self.transaction.time))
                        Text(self.confirmations)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        HStack {
                            Image("raw_data")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24.0,height:24.0)
                            Button(action: {
                                self.showAlert = true
                            }) {
                                Image("delete")
                                .padding(.leading, 5.0)
                            }
                        }
                    }
                    .setCustomDecoration(.accentColor)
                }
                .padding([.top, .horizontal])

                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text("\(AppStrings.sender) :")
                            .font(.headline)
                        Text(self.transaction.payer)
                            .lineLimit(3)
                            .multilineTextAlignment(.leading)
                            .padding(.leading)
                            .frame(height: 50)
                    }
                    HStack {
                        Text("\(AppStrings.sendAmount) :")
                            .font(.headline)
                        Spacer()
                        Text(self.amountSent())
                    }
                }.padding([.top, .leading, .trailing])
                Divider()
                .alert(isPresented: self.$showAlert) {
                    return Alert(title: Text("Delete this transaction record?"),
                        primaryButton: .default(Text("delete"), action: {
                            let next = CoreDataManager.shared.getNextTransaction(self.transaction)
                            
                            let prev = CoreDataManager.shared.getPreviousTransaction(self.transaction)
                            
                            _ = CoreDataManager.shared.deleteTransaction(transactionVM: self.transaction)
                            
                            self.transactionList.fetch()
                            
                            if next != nil {
                                self.transaction = next!
                            }
                            else if prev != nil {
                                self.transaction = prev!
                            }
                            else {
                                self.dismiss()
                            }
                        }),
                        secondaryButton: .default(Text(AppStrings.cancel)))
                }

                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text("\(AppStrings.recipient) :")
                            .font(.headline)
                        Text(self.transaction.payee)
                            .multilineTextAlignment(.leading)
                            .lineLimit(3)
                            .padding(.leading)
                        .frame(height: 50)
                    }
                    HStack {
                        Text("\(AppStrings.recvAmount) :")
                            .font(.headline)
                        Spacer()
                        Text(self.amountRecv())
                    }
                    Divider()
                }.padding()

                HStack {
                    Text("\(AppStrings.fees) :")
                        .font(.headline)
                    Spacer()
                    Text(self.amountFees())
                }.padding(.horizontal)

                HStack {
                    Spacer()
                    Image("pay")
                        .setCustomDecoration(.foregroundAccent)
                    Text(AppStrings.showLocalCurrency).lineLimit(1).font(.headline)
                    Toggle("", isOn: self.$showLocalCurrency)
                        .labelsHidden()
                }.padding([.leading, .bottom, .trailing])

                Spacer()
                HStack {
                    Text("\(AppStrings.transactionId):")
                        .font(.headline)
                    Image("eye")
                        .setCustomDecoration(.foregroundAccent)
                    Spacer()
                }.padding(.horizontal)
                Text(self.transaction.hash).padding(.horizontal).frame(height: 50.0)
                HStack {
                    Button(action: {
                        self.transaction = CoreDataManager.shared.getPreviousTransaction(self.transaction)!
                    }) {
                        Image(systemName: "backward").font(.system(size: 19)).padding(4)
                    }
                    .disabled(CoreDataManager.shared.getPreviousTransaction(self.transaction) == nil)
                    .padding(.bottom)
                    .setCustomDecoration(.accentColor)
                    .frame(width: geometry.size.width/2)

                    Button(action: {
                        self.transaction = CoreDataManager.shared.getNextTransaction(self.transaction)!
                    }) {
                        Image(systemName: "forward").font(.system(size: 19)).padding(4)
                    }
                    .disabled(CoreDataManager.shared.getNextTransaction(self.transaction) == nil)
                    .padding(.bottom)
                    .setCustomDecoration(.accentColor)
                    .frame(width: geometry.size.width/2)
               }
            }
        }
    }
    
    func amountSent() -> String {
        return AppTools.btcToFormattedString(self.transaction.amountSent)
    }
    
    func amountRecv() -> String {
        return AppTools.btcToFormattedString(self.transaction.amountRecv)
    }
    
    func amountFees() -> String {
        return AppTools.btcToFormattedString(self.transaction.amountSent - self.transaction.amountRecv)
    }

    func checkConfirmation() {
        if self.transaction.blockHeight > 0 {
            self.confirmations = "1 \(AppStrings.confirmations)"
        }
    }
}

struct ViewTransactionRecord_Previews: PreviewProvider {
    static var previews: some View {
        ViewTransactionInformation(dismiss: {}, transactionList: TransactionListViewModel(), transaction: TransactionViewModel(transaction: DBTransaction())).environmentObject(AppController())
    }
}
