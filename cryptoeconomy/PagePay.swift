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
    @State var showToastMessage = false
    @State var toastMessage = ""

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
                            .padding(.horizontal, 20.0)
                        
                        Toggle(isOn: self.$appController.authByPin){
                            HStack {
                                Spacer()
                                Text(AppStrings.authByPin).font(.footnote)
                            }
                        }.padding(.horizontal, 20.0).padding(.top, 40).padding(.bottom, 10)
                        
                        Button(action: {
                            self.otkNpi.beginScanning(onCompleted: {
                                if !self.otkNpi.otkData.btcAddress.isEmpty {
                                    
                                    self.promptMessage = "Checking balance, please wait..."
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.75) {
                                        _ = BlockChainInfoService.getBalance(address: self.otkNpi.otkData.btcAddress).done({result in
                                                self.clearPrompt()
                                            if BtcUtils.satoshiToBtc(satoshi: result) > self.appController.getAmountSend() {
                                                self.appController.payer = self.otkNpi.otkData.btcAddress
                                                self.appController.payee = self.appController.payeeAddr
                                                self.showConfirmation = true
                                            }
                                            else {
                                                self.showToast("Balance not enough!")
                                            }
                                        }).catch({_ in
                                            self.clearPrompt()
                                            self.showToast("Balance cannot be updated at the momoent!")
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
            .toastMessage(message: self.$toastMessage, show: self.$showToastMessage)
        }
        .isKeyboardActive(keyboardActive: self.$keyboardActive)
    }
    
    func showPrompt(_ message: String) {
        self.promptMessage = message
    }
    
    func clearPrompt() {
        self.promptMessage = ""
    }
    func showToast(_ message: String) {
        self.toastMessage = message
        self.showToastMessage = true
    }
}

struct PagePay_Previews: PreviewProvider {
    static var previews: some View {
        PagePay(promptMessage: .constant(""), showConfirmation: .constant(false), confirmation: .constant(false)).environmentObject(AppController())
    }
}
