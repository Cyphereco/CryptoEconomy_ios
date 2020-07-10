//
//  PagePay.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/3/30.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct PagePay: View {
    @Binding var promptMessage: String
    @Binding var showConfirmation: Bool
    @Binding var confirmation: Bool
    
    @EnvironmentObject var appController: AppController
    
    @ObservedObject var otkNpi = OtkNfcProtocolInterface()
    @State var alertUseFixedAddress = false
    @State var keyboardActive = false
    @State var showBubble = false
    @State var bubbleMessage = ""
    @Binding var showToast: Bool
    @Binding var toastMessage: String

    var body: some View {
        NavigationView {
            GeometryReader {geometry in
                ZStack(alignment: .trailing) {
                    VStack(alignment: .trailing) {
                        TextEstFeesInfo()
                            .padding([.top, .trailing], 20.0)
                        
                        Spacer()
                        
                        TextFieldBtcAddress(address: self.$appController.payeeAddr)
                            .padding()
                            .disabled(self.appController.useFixedAddress)
                            .onTapGesture {
                                if self.appController.useFixedAddress {
                                    self.alertUseFixedAddress = true
                                }
                            }
                            .alert(isPresented: self.$alertUseFixedAddress){
                                Alert(title: Text("use_fixed_address"))
                            }

                        Toggle(isOn: self.$appController.useAllFunds){
                            HStack {
                                Spacer()
                                Text(AppStrings.useAllFunds).font(.footnote)
                            }
                        }.padding(.horizontal, 20.0).padding(.top, 30)
                        
                        TextFieldPayAmount()
                            .disabled(self.appController.useAllFunds)
                            .padding(.horizontal, 20.0)
                        
                        Toggle(isOn: self.$appController.authByPin){
                            HStack {
                                Spacer()
                                Text(AppStrings.authByPin).font(.footnote)
                            }
                        }.padding(.horizontal, 20.0).padding(.top, 40).padding(.bottom, 10)
                        
                        Button(action: {
                            if !self.appController.internetConnected {
                                self.toastMessage = AppStrings.connot_connect_to_network
                                self.showToast = true
                                return
                            }
                            
                            if self.appController.payeeAddr.isEmpty {
                                self.toastMessage = AppStrings.recipient_address_cannot_be_empty
                                self.showToast = true
                                return
                            }
                            
                            if !self.appController.useAllFunds {
                                if self.appController.feesIncluded && self.appController.getAmountReceived() < 0.0 {
                                    self.toastMessage = AppStrings.amount_is_less_than_transaction_fees
                                    self.showToast = true
                                    return
                                }
                                
                                if self.appController.amountSend.isEmpty || (Double(self.appController.amountSend) ?? 0.0) == 0.0 {
                                    self.toastMessage = AppStrings.send_amount_is_not_entered
                                    self.showToast = true
                                    return
                                }
                           }
                            
                            self.otkNpi.beginScanning(onCompleted: {
                                if !self.otkNpi.otkData.btcAddress.isEmpty {
                                    
                                    self.appController.balance = 0
                                    self.promptMessage = AppStrings.checking_balance
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.75) {
                                        _ = BlockChainInfoService.getBalance(address: self.otkNpi.otkData.btcAddress).done({result in
                                            
                                            self.clearPrompt()
                                            
                                            self.appController.balance = BtcUtils.satoshiToBtc(satoshi: result)
                                            
                                            if !self.appController.useAllFunds &&
                                                 self.appController.balance < self.appController.getAmountSent() {
                                                self.showBubble(AppStrings.balance_not_enough)
                                                return
                                            }
                                            else if self.appController.balance < self.appController.fees {
                                                self.showBubble(AppStrings.balance_not_enough)
                                                return
                                            }
                                            
                                            self.appController.payer = self.otkNpi.otkData.btcAddress
                                            self.appController.payee = self.appController.payeeAddr
                                            self.showConfirmation = true
                                        }).catch({_ in
                                            self.clearPrompt()
                                            self.showBubble(AppStrings.cannot_get_balance)
                                        })
                                    }
                                }
                            }, onCanceled: {})
                        }) {
                            HStack{
                                if (self.appController.authByPin) {
                                    Image(systemName: "ellipsis").font(.system(size: 19)).padding(4)
                                }
                                else {
                                    Image("fingerprint")
                                }
                                Text("sign_payment")
                                    .font(.system(size: 20))
                                .fontWeight(.bold)
                            }
                            .padding(12)
                            .setCustomDecoration(.roundedButton)
                        }
                        .padding(.trailing, 20.0)
                        .padding(.bottom, 40)
                    }
                }
            }
            .onTapBackground({
                if self.keyboardActive {
                    UIApplication.shared.endEditing()
                }
            })
            .navigationBarTitle(Text(AppStrings.pay), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                withAnimation {
                    self.appController.interacts = .menuPay
                }
            }) {
                Image("menu")
            })
            .bubbleMessage(message: self.$bubbleMessage, show: self.$showBubble)
        }
        .isKeyboardActive(keyboardActive: self.$keyboardActive)
    }
    
    func clearPrompt() {
        self.promptMessage = ""
    }
    
    func showBubble(_ message: String) {
        self.bubbleMessage = message
        self.showBubble = true
    }
}

struct PagePay_Previews: PreviewProvider {
    static var previews: some View {
        PagePay(promptMessage: .constant(""), showConfirmation: .constant(false), confirmation: .constant(false), showToast: .constant(false), toastMessage: .constant("")).environmentObject(AppController())
    }
}
