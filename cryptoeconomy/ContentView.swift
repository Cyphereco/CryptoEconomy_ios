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
    @State var showTransactionInfo = false
    @ObservedObject var transactionList = TransactionListViewModel()
    @State private var transaction: TransactionViewModel? = nil

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
                self.transaction = TransactionViewModel(time: Date(), hash: "fake_hash", payer: self.appController.payer, payee: self.appController.payee, amountSent: self.appController.getAmountToBeSent(), amountRecv: self.appController.getAmountReceived(), rawData: "fake_raw_data", blockHeight: -1, exchangeRate: AppController.exchangeRates.toString())
                
                if CoreDataManager.shared.insertTransaction(transactionVM: self.transaction!)
                {
                }
                else {
                }

                self.showPaymentConfirmation = false
                self.fullscreenMessage = "Processing transaction..."
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.fullscreenMessage = ""
                    self.appController.pageSelected = 2
                    self.showTransactionInfo = true
                }
            }, onCancel: {
                self.toastMessage = "Payment canceled!"
                self.showToast = true
                self.showPaymentConfirmation = false
            })
        }
        .sheet(isPresented: $showTransactionInfo){
            ViewTransactionInformation(dismiss: {self.showTransactionInfo = false}, transactionList: self.transactionList, transaction: self.transaction!)
                .addSheetTitle(AppStrings.transactionInfo)
        }
        .isKeyboardActive(keyboardActive: self.$keyboardActive)
        .fullScreenPrompt(message: self.$fullscreenMessage)
        .toastMessage(message: self.$toastMessage, show: self.$showToast)
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
