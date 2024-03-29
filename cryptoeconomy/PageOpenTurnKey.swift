//
//  PageOpenTurnKey.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/3/29.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct PageOpenTurnKey: View {
    @State var requestHint: String = AppStrings.readGeneralInformation
    @EnvironmentObject var appController: AppController

    @State var executingRequest = false
    @State var showResult = false
    @State var otkBtcBalance = 0.0
    @State var message = ""
    @State var showBubble = false
    @State var showDialogEnterPin = false
    @State var pin  = ""
    @State var showAlert = false
    @State var messageTitle = ""
    @State var messageContent = ""

    let otkNpi = AppController.otkNpi
    @State var keyboardActive = false

    var body: some View {
        ZStack {
            NavigationView {
                GeometryReader {geometry in
                    ZStack(alignment: .trailing) {
                        VStack{
                            HStack(alignment: .center, spacing: 20) {
                                Spacer()
                            }.frame(minWidth: .zero, idealWidth: .none, maxWidth: .infinity, minHeight: 80, idealHeight: .none, maxHeight: 100, alignment: .center)
                            
                            Image("cyphereco_label").resizable().scaledToFit().frame(width: 100, height: 100)
                            
                            Text(AppStrings.openturnkey)
                                .fontWeight(.bold)
                            
                            Text("(" + self.appController.requestHint + ")").padding()
                            
                            VStack(alignment: .center, spacing: 20) {
                                if (self.otkNpi.request.command != .invalid &&
                                    self.otkNpi.request.command != .reset) {
                                    if (self.otkNpi.request.command == .unlock || self.appController.authByPin) {
                                        Image(systemName: "ellipsis").font(.system(size: 19)).padding(4)
                                    }
                                    
                                    if (self.otkNpi.request.command != .unlock && !self.appController.authByPin) {
                                        Image("fingerprint")
                                    }

                                    if (self.otkNpi.request.command != .exportKey && self.otkNpi.request.command != .setPin && self.otkNpi.request.command != .unlock) {
                                        HStack {
                                            Text(AppStrings.authByPin).font(.footnote)
                                            Toggle("", isOn: self.$appController.authByPin)
                                                .labelsHidden()
                                        }
                                    }
                                    else {
                                        Spacer().frame(height: 29)
                                    }
                                }
                                else {
                                    Spacer().frame(height: 88)
                                }
                                
                                Button(action: {
                                    // change requestId so it will not be canceled
                                    self.appController.requestId = UUID()
                                    if self.appController.authByPin || self.otkNpi.request.command == .unlock {
                                        self.showDialogEnterPin = true
                                    }
                                    else {
                                        self.makeRequest()
                                    }
                                }) {
                                    HStack(alignment: .center){
                                        Image("nfc_request")
                                        .frame(minWidth: 70, minHeight: 70)
                                        .setCustomDecoration(.roundedButton)
                                    }
                                    .clipShape(Circle())
                                }
                                .sheet(isPresented: self.$showResult, onDismiss: {
                                    self.otkNpi.reset()
                                }) {
                                    if self.otkNpi.readCompleted {
                                        if self.otkNpi.otkState.execState == .success {
                                            if self.otkNpi.otkState.command == .exportKey {
                                                ViewExportWifKey().environmentObject(self.appController)
                                                    .addSheetTitle(AppStrings.exportKey)
                                            }
                                            else if self.otkNpi.otkState.command == .showKey {
                                                ViewPublicKeyInformation().environmentObject(self.appController)
                                                    .addSheetTitle(AppStrings.showKey)
                                            }
                                        }
                                        else if self.otkNpi.otkState.execState == .invalid && self.otkNpi.otkState.command == .invalid {
                                            ViewOpenTurnKeyInfo(btcBalance: self.$otkBtcBalance).environmentObject(self.appController)
                                                .addSheetTitle(AppStrings.openturnkeyInfo)
                                        }
                                    }
                                }

                                Spacer()
                            }.frame(minWidth: .zero, idealWidth: .none, maxWidth: .infinity, minHeight: 80, idealHeight: .none, maxHeight: 160, alignment: .center)
                        }
                    }
                }
                .disabled(self.executingRequest)
                .onTapBackground({
                    if self.keyboardActive {
                        UIApplication.shared.endEditing()
                    }
                })
                .navigationBarTitle(Text(AppStrings.openturnkey), displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    withAnimation {
                        self.appController.cancelOtkRequest(continueAfterStarted: false)
                        self.appController.interacts = .menuOpenTurnKey
                    }
                }) {
                    Image("menu")
                })
                .bubbleMessage(message: self.$message, show: self.$showBubble)
                .alert(
                    isPresented: $showAlert,
                    content: {
                        Alert(title: Text(self.messageTitle),
                              message: Text(self.messageContent),
                              dismissButton: .default(Text(AppStrings.i_understood))
                        )
                    }
                )
            }
            
            DialogEnterPin(showDialog: self.showDialogEnterPin, closeDialog: {
                withAnimation {
                    self.showDialogEnterPin = false
                }
            }, pin: "", handler: {pin in
                self.otkNpi.request.pin = pin
                self.makeRequest()
            })
        }.isKeyboardActive(keyboardActive: self.$keyboardActive)
    }
    
    func makeRequest() {
        self.executingRequest = true
        self.otkNpi.beginScanning(onCompleted: {
            if (self.otkNpi.readCompleted) {
                print(self.otkNpi)
                let execState = self.otkNpi.otkState.execState
                let command = self.otkNpi.otkState.command
                
                if execState == .success {
                    if command == .reset {
                        self.messageTitle = AppStrings.reset_command_sent
                        self.messageContent = AppStrings.reset_step_intro
                        self.showAlert = true
                    }
                    else if command == .unlock || command == .setKey || command == .setNote || command == .setPin {
                        self.showToast(command.desc + "\n" + AppStrings.request_success)
                    }
                    else if command == .exportKey || command == .showKey {
                        self.showResult = true
                        self.executingRequest = false
                    }
                }
                if execState == .fail {
                    if self.otkNpi.otkState.failureReason == .auth_failed &&
                        self.otkNpi.otkData.pinAuthSuspensionRetry > 0 {
                        self.showToast("\(AppStrings.request_fail): \(command.desc)" + "\n\(AppStrings.pin_auth_suspended)\n\(AppStrings.retry_after)" +
                            " \(self.otkNpi.otkData.pinAuthSuspensionRetry) \(AppStrings.reboot)")
                    }
                    else {
                        self.showToast("\(AppStrings.request_fail): \(command.desc)" + "\n\(self.otkNpi.otkState.failureReason.desc)")
                    }
                }
                else {
                    if command == .invalid {
                        // no request, just otk info
                        _ = BlockChainInfoService.getBalance(address: self.otkNpi.otkData.btcAddress).done({result in
                            if (result >= 0) {
                                self.otkBtcBalance = BtcUtils.satoshiToBtc(satoshi: result)
                            }
                        }).catch({_ in
                            self.otkBtcBalance =  -1
                        })
                        self.showResult = true
                        self.executingRequest = false
                    }
                }
            }
            self.otkNpi.request.command = .invalid
            self.appController.requestId = UUID()
            self.executingRequest = false
        }, onCanceled: {
            self.appController.cancelOtkRequest(continueAfterStarted: false)
            self.executingRequest = false
        })
    }
    
    func showToast(_ message: String) {
        self.appController.cancelOtkRequest(continueAfterStarted: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.message = message
            self.showBubble = true
            self.executingRequest = false
        }
    }
}

struct PageOpenTurnKey_Previews: PreviewProvider {
    static var previews: some View {
        PageOpenTurnKey().environmentObject(AppController())
    }
}
