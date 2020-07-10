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
    @State var showRawData = false
    @State var showAlert = false
    @State var msg = ""
    @State var showLocalCurrency = false
    
    @Environment(\.presentationMode) var presentationMode
    var pasteboard = UIPasteboard.general
    @State var bubbleMessage = ""
    @State var showBubble = false
    @GestureState  var dragOffset = CGSize.zero
    @State var paging = 0
    @State var showRates = false
    
    var body: some View {
        GeometryReader {geometry in
            ZStack {
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
                            Text(self.getConfirmation())
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            HStack {
                                Button(action: {
                                    self.showRawData = true
                                }) {
                                    Image("raw_data")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24.0,height:24.0)
                                }
                                Button(action: {
                                    self.showAlert = true
                                }) {
                                    Image("delete")
                                    .padding(.leading, 5.0)
                                }
                            }
                        }
                        .setCustomDecoration(.accentColor)
                        .alert(isPresented: self.$showRawData) {
                            return Alert(title: Text("Raw Data"), message: Text("\(self.transaction.rawData)"), primaryButton: .default(Text("cancel")), secondaryButton: .default(Text("copy"), action: {
                                self.pasteboard.string = self.transaction.rawData
                                self.bubbleMessage = "raw_data" + AppStrings.copied
                                self.showBubble = true
                            }))
                        }
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
                            Text(self.amountSent(showLocalCurrency: self.showLocalCurrency) + " ") +
                                Text(self.showLocalCurrency ? self.appController.getLocalCurrency().label : "BTC")
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
                            Text(self.amountRecv(showLocalCurrency: self.showLocalCurrency) + " ") +
                            Text(self.showLocalCurrency ? self.appController.getLocalCurrency().label : "BTC")
                        }
                        Divider()
                    }.padding()

                    HStack {
                        Text("\(AppStrings.fees) :")
                            .font(.headline)
                        Spacer()
                        Text(self.amountFees(showLocalCurrency: self.showLocalCurrency) + " ") +
                        Text(self.showLocalCurrency ? self.appController.getLocalCurrency().label : "BTC")
                    }.padding(.horizontal)

                    HStack {
                        Spacer()
                        Button(action: {
                            self.showRates = true
                        }) {
                            Image("pay")
                        }.setCustomDecoration(.accentColor)
                        Text(AppStrings.showLocalCurrency).lineLimit(1).font(.headline)
                        Toggle("", isOn: self.$showLocalCurrency)
                            .labelsHidden()
                    }.padding([.leading, .bottom, .trailing])

                    Spacer()
                    HStack {
                        Text("\(AppStrings.transactionId):")
                            .font(.headline)
                        Button(action: {
                            if let url = URL(string: "https://blockchain.com/btc/tx/" + self.transaction.hash) {
                                UIApplication.shared.open(url)
                            }
                        }){
                            Image("eye")
                        }.setCustomDecoration(.accentColor)
                        Spacer()
                    }.padding(.horizontal)
                    Text(self.transaction.hash).padding(.horizontal).frame(height: 50.0)
                    HStack {
                        Button(action: {
                            if let tx = CoreDataManager.shared.getPreviousTransaction(self.transaction) {
                                self.paging = -1
                                self.transaction = tx
                            }
                        }) {
                            Image(systemName: "backward").font(.system(size: 19)).padding(4)
                        }
                        .disabled(CoreDataManager.shared.getPreviousTransaction(self.transaction) == nil)
                        .padding(.bottom)
                        .setCustomDecoration(.accentColor)
                        .frame(width: geometry.size.width/2)

                        Button(action: {
                            if let tx = CoreDataManager.shared.getNextTransaction(self.transaction) {
                                self.paging = 1
                                self.transaction = tx
                            }
                        }) {
                            Image(systemName: "forward").font(.system(size: 19)).padding(4)
                        }
                        .disabled(CoreDataManager.shared.getNextTransaction(self.transaction) == nil)
                        .padding(.bottom)
                        .setCustomDecoration(.accentColor)
                        .frame(width: geometry.size.width/2)
                   }
                }

                GeometryReader { _ in
                    EmptyView()
                }
                .background(Color.gray.opacity(0.6))
                .opacity(self.showRates ? 0.5 : 0.0)
                .animation(.easeInOut)
                .onTapGesture {
                    self.showRates = false
                }

                if self.showRates {
                    VStack(alignment: .center) {
                        Text("Exchange Rates").font(.headline).padding(5)
                        VStack(alignment: .trailing) {
                            HStack {
                                Text("Data/Time: ").font(.headline)
                                Text(AppTools.formatTime(self.transaction.time))
                            }.padding(.vertical)
                            Text("1 BTC")
                            Text("=").padding(.horizontal)
                            HStack {
                                Text("\(self.formatedExchangeRate(currency: FiatCurrency.CNY)) ")
                                Text(FiatCurrency.CNY.label).frame(width: 40)
                            }
                            HStack {
                                Text("\(self.formatedExchangeRate(currency: FiatCurrency.EUR)) ")
                                Text(FiatCurrency.EUR.label).frame(width: 40)
                            }
                            HStack {
                                Text("\(self.formatedExchangeRate(currency: FiatCurrency.JPY)) ")
                                Text(FiatCurrency.JPY.label).frame(width: 40)
                            }
                            HStack {
                                Text("\(self.formatedExchangeRate(currency: FiatCurrency.TWD)) ")
                                Text(FiatCurrency.TWD.label).frame(width: 40)
                            }
                            HStack {
                                Text("\(self.formatedExchangeRate(currency: FiatCurrency.USD)) ")
                                Text(FiatCurrency.USD.label).frame(width: 40)
                            }
                        }.padding(.vertical)
                        Button(action: {
                            self.showRates = false
                        }){
                            Image(systemName: "xmark.circle.fill").font(.title)
                        }
                    }.padding()
                    .setCustomDecoration(.accentColor)
                    .setCustomDecoration(.backgroundNormal)
                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
                }
            }
        }
        .onAppear(){
            print(self.transaction.toString())
            if self.transaction.rawData.isEmpty {
                _ = WebServices.getRawTranaction(webServiceProvider: BlockChainInfoService.self, hash: self.transaction.hash)
                    .done(){ rawData in
                        print("RawData: >> \(rawData)")
                        self.transaction.rawData = rawData
                        _ = CoreDataManager.shared.updateTransaction(transactionVM: self.transaction)
                }
            }
        }
        .pagingIndicator(paging: self.$paging)
        .bubbleMessage(message: self.$bubbleMessage, show: self.$showBubble)
        .gesture(DragGesture()
            .onEnded { gesture in
                if gesture.translation.width < -100 {
                    withAnimation {
                        if let tx = CoreDataManager.shared.getNextTransaction(self.transaction) {
                            self.paging = 1
                            self.transaction = tx
                        }
                    }
                }
                else if gesture.translation.width > 100 {
                    withAnimation {
                        if let tx = CoreDataManager.shared.getPreviousTransaction(self.transaction) {
                            self.paging = -1
                            self.transaction = tx
                        }
                    }
                }
            })
    }
        
    func getConfirmation() -> String {
        print("Tx Block Height: >> \(self.transaction.blockHeight)")

        if self.transaction.blockHeight <= 0 {
            _ = BlockChainInfoService.getBlockHeight(hash: self.transaction.hash)
                .done(){ height in
                    print("Height: >> \(height)")
                    self.transaction.blockHeight = height
                    _ = CoreDataManager.shared.updateTransaction(transactionVM: self.transaction)
            }
            
            return "Unconfirmed"
        }
        else {
            let confirmations = self.appController.calcConfirmations(self.transaction.blockHeight)
            return "\(confirmations > 144 ? ">144" : "\(confirmations)") Confirmations"
        }
    }
    
    func formatedExchangeRate(currency: FiatCurrency) -> String {
        return AppTools.fiatToFormattedString(getExchangeRate(currency: currency))
    }
    
    func getExchangeRate(currency: FiatCurrency) -> Double {
        let exchangeRates = ExchangeRates(exchangeRates: self.transaction.exchangeRate)

        switch currency {
            case .CNY:
                return exchangeRates.cny
            case .EUR:
                return exchangeRates.eur
            case .JPY:
                return exchangeRates.jpy
            case .TWD:
                return exchangeRates.twd
            default:
                return exchangeRates.usd
        }
    }
    
    func fiatExchangeRate() -> Double {
        return getExchangeRate(currency: self.appController.getLocalCurrency())
    }
    
    func amountSent(showLocalCurrency: Bool) -> String {
        let amount = showLocalCurrency ? self.transaction.amountSent * fiatExchangeRate() : self.transaction.amountSent
        return showLocalCurrency ? AppTools.fiatToFormattedString(amount) : AppTools.btcToFormattedString(amount)
    }
    
    func amountRecv(showLocalCurrency: Bool) -> String {
        let amount = showLocalCurrency ? self.transaction.amountRecv * fiatExchangeRate() : self.transaction.amountRecv
        
        return showLocalCurrency ? AppTools.fiatToFormattedString(amount) : AppTools.btcToFormattedString(amount)
    }
    
    func amountFees(showLocalCurrency: Bool) -> String {
        let fees = self.transaction.amountSent - self.transaction.amountRecv
        let amount = showLocalCurrency ? fees * fiatExchangeRate() : fees
        
        return showLocalCurrency ? AppTools.fiatToFormattedString(amount) : AppTools.btcToFormattedString(amount)
    }
}

struct ViewTransactionRecord_Previews: PreviewProvider {
    static var previews: some View {
        ViewTransactionInformation(dismiss: {}, transactionList: TransactionListViewModel(), transaction: TransactionViewModel(transaction: DBTransaction())).environmentObject(AppController())
    }
}
