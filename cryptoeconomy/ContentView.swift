//
//  ContentView.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/3/28.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    let totalTabs = 4
    @GestureState  var dragOffset = CGSize.zero
    @EnvironmentObject var appController: AppController
    @State var keyboardActive = false
    @State var fullscreenMessage = ""
    @State var showPaymentConfirmation = false
    @State var paymentConfirmed = false
    @State var showToast = false
    @State var toastMessage = ""
    @State var showBubble = false
    @State var bubbleMessage = ""
    @State var showTransactionInfo = false
    @State var showDialogEnterPin = false
    @State var strPincode = ""
    @ObservedObject var transactionList = TransactionListViewModel()
    @State private var transaction: TransactionViewModel? = nil
    
    let otkNpi = AppController.otkNpi

    var body: some View {
        ZStack {
            TabView(selection: self.$appController.pageSelected){
                PagePay(promptMessage: self.$fullscreenMessage, showConfirmation: self.$showPaymentConfirmation, confirmation: self.$paymentConfirmed, showToast: self.$showToast, toastMessage: self.$toastMessage)
                    .tabItem {
                        VStack {
                            Image("pay")
                            Text(AppStrings.pay)
                        }
                    }
                    .tag(0)
                PageOpenTurnKey()
                    .tabItem {
                        VStack {
                            Image("cyphereco_icon")
                            Text(AppStrings.openturnkey)
                        }
                    }
                    .tag(1)
                PageHistory()
                    .tabItem {
                        VStack {
                            Image("history")
                            Text(AppStrings.history)
                        }
                    }
                    .tag(2)
                PageAddresses()
                    .tabItem {
                        VStack {
                            Image("addressbook")
                            Text(AppStrings.addresses)
                        }
                    }
                    .tag(3)
            }
            .sheet(isPresented: $showTransactionInfo){
                ViewTransactionInformation(dismiss: {self.showTransactionInfo = false}, transactionList: self.transactionList, transaction: self.transaction!)
                    .environmentObject(self.appController)
                    .addSheetTitle(AppStrings.transactionInfo)
            }
            .blur(radius: self.appController.interacts != .none ? 0.8 : 0)
            .animation(.easeInOut)
            .setCustomDecoration(.accentColor)
            .swipableTabs(currentTab: self.$appController.pageSelected, totalTabs: self.totalTabs)
            
            GeometryReader { _ in
                EmptyView()
            }
            .background(Color.gray.opacity(0.6))
            .opacity(self.appController.interacts != .none ? 0.5 : 0.0)
            .animation(.easeInOut)
            .onTapGesture {
                self.closeMenu()
            }
            .gesture(DragGesture()
                .updating(self.$dragOffset, body: { (value, state, transaction) in
                    state = value.translation
                })
                .onEnded { gesture in
                    if self.appController.interacts == .menuPay || self.appController.interacts == .menuOpenTurnKey {
                        if gesture.translation.width > 100 {
                            withAnimation {
                                self.closeMenu()
                            }
                        }
                    }
                    else if self.appController.interacts == .configLocalCurrency || self.appController.interacts == .configFees {
                        if gesture.translation.height > 100 {
                            withAnimation {
                                self.closeMenu()
                            }
                        }
                    }
                })
            
            SideMenuPay(isOpened: self.appController.interacts == .menuPay, closeMenu: {
                self.closeMenu()
            })
            .offset(x: dragOffset.width > 0 ? dragOffset.width : 0)

            SideMenuOpenTurnKey(isOpened: self.appController.interacts == .menuOpenTurnKey, closeMenu: {
                self.closeMenu()
            })
            .offset(x: dragOffset.width > 0 ? dragOffset.width : 0)

            ConfigLocalCurrency(isOpened: self.appController.interacts == .configLocalCurrency, closeMenu: {
                withAnimation {
                    self.closeMenu()
                }
            })
            .disabled(self.appController.interacts != .configLocalCurrency)
            .offset(y: dragOffset.height > 0 ? dragOffset.height : 0)

            ConfigFees(isOpened: self.appController.interacts == .configFees, closeMenu: {
                withAnimation {
                    self.closeMenu()
                }
            })
            .disabled(self.appController.interacts != .configFees)
            .offset(y: dragOffset.height > 0 ? dragOffset.height : 0)
            
            DialogConfirmPayment(showDialog: self.showPaymentConfirmation, closeDialog: {
                self.showPaymentConfirmation = false
            }, onConfirm: {
                withAnimation {
                    self.showPaymentConfirmation = false
                    // if set AutyByPin, prompt PIN input dialog then proceed
                    if self.appController.authByPin {
                        self.showDialogEnterPin = true
                    }
                    else {
                        self.makePayment()
                    }
                }
            }, onCancel: {
                self.toastMessage = "Payment canceled!"
                self.showToast = true
                self.showPaymentConfirmation = false
            })

            DialogEnterPin(showDialog: self.showDialogEnterPin, closeDialog: {
                withAnimation {
                    self.showDialogEnterPin = false
                }
            }, pin: "", handler: {pin in
                self.strPincode = pin
                self.makePayment()
            })
        }
        .isKeyboardActive(keyboardActive: self.$keyboardActive)
        .fullScreenPrompt(message: self.$fullscreenMessage)
        .toastMessage(message: self.$toastMessage, show: self.$showToast)
        .bubbleMessage(message: self.$bubbleMessage, show: self.$showBubble)
    }
    
    func makePayment() {
        self.fullscreenMessage = "Processing transaction..."

        _ = WebServices.newTransaction(from: self.appController.payer, to: self.appController.payee, amountInSatoshi: BtcUtils.BtcToSatoshi(btc: self.appController.getAmountReceived()), fees: BtcUtils.BtcToSatoshi(btc: self.appController.fees)).done(){ unsignedTx in
            
            print(unsignedTx.toString())
            
            var signatures = ""
            for signature in unsignedTx.toSign {
                signatures += signature + "\n"
            }
            
            self.otkNpi.request = OtkRequest(command: .sign, pin: self.strPincode, data: signatures, option: "")
            
            self.otkNpi.beginScanning(onCompleted: {
                print("\(self.otkNpi.otkState)")
                print("\(self.otkNpi.otkData)")
                print("\(self.otkNpi.otkData.signatures.count)")
                if self.otkNpi.otkState.execState == .success {
                    _ = WebServices.sendTransaction(unsignedTx: unsignedTx, signatures: self.otkNpi.otkData.signatures, publicKey: self.otkNpi.otkData.publicKey)
                        .done(){tx in
                        
                        print(tx)
                            
                        let transaction = TransactionViewModel(time: Date(), hash: tx.hash, payer: tx.from, payee: tx.to, amountSent: self.appController.getAmountSent(), amountRecv: self.appController.getAmountReceived(), rawData: tx.rawData, blockHeight: tx.blockHeight, exchangeRate: AppController.exchangeRates.toString())
                        _ = CoreDataManager.shared.insertTransaction(transactionVM: transaction)

                        if transaction.rawData.isEmpty {
                            _ = WebServices.getRawTranaction(hash: transaction.hash)
                                .done(){ rawData in
                                    transaction.rawData = rawData
                                    _ = CoreDataManager.shared.updateTransaction(transactionVM: transaction)
                            }
                        }
                        self.transaction = transaction

                        DispatchQueue.main.async {
                            self.fullscreenMessage = ""
                            self.appController.pageSelected = 2
                            self.showTransactionInfo = true
                        }
                    }
                    .catch(){err in
                        DispatchQueue.main.async {
                            self.fullscreenMessage = ""
                            self.bubbleMessage = "Error: \(err)"
                            self.showBubble.toggle()
                        }
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.fullscreenMessage = ""
                        self.bubbleMessage = "Error: \(self.otkNpi.otkState.failureReason.desc)"
                        self.showBubble.toggle()
                    }
                }
//              self.transaction = TransactionViewModel(time: Date(), hash: "fake_hash", payer: self.appController.payer, payee: self.appController.payee, amountSent: self.appController.getAmountSent(), amountRecv: self.appController.getAmountReceived(), rawData: "fake_raw_data", blockHeight: -1, exchangeRate: AppController.exchangeRates.toString())
//
//              _ = CoreDataManager.shared.insertTransaction(transactionVM: self.transaction!)
//
//                DispatchQueue.main.async {
//                    self.fullscreenMessage = ""
//                    self.appController.pageSelected = 2
//                    self.showTransactionInfo = true
//                }
            }, onCanceled: {
                DispatchQueue.main.async {
                    self.fullscreenMessage = ""
                    self.bubbleMessage = "Cancel payment!"
                    self.showBubble.toggle()
                }
            })
        }.catch(){err in
            print("failed to generate transaction")
            DispatchQueue.main.async {
                self.fullscreenMessage = ""
                self.bubbleMessage = "Failed to generate transaction: (\(err))"
                self.showBubble = true
            }
        }
    }
            
    func closeMenu() {
        if self.keyboardActive {
            UIApplication.shared.endEditing()
        }
        withAnimation {
            if self.appController.interacts == .configLocalCurrency {
                
            }
            else if self.appController.interacts == .configFees {
                
            }
            self.appController.interacts = .none
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["en", "zh-Hant", "zh-Hans", "ja"], id: \.self) {localeIdentifier in
            ContentView()
                .environmentObject(AppController())
                .environment(\.locale, .init(identifier: localeIdentifier))
                .previewDisplayName(localeIdentifier)
        }
    }
}
