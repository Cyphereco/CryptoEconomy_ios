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
    @State var showToast = false
    @State var showDialogEnterPin = false
    @State var pin  = ""

    let otkNpi = AppController.otkNpi

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
                            
                            Text("OpenTurnKey")
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
                                        
                                        Text(AppStrings.makeRequest)
                                            .font(.system(size: 20))
                                            .fontWeight(.bold)
                                            .padding(.trailing, 10)
                                    }
                                    .frame(minWidth: 200)
                                    .padding(12)
                                    .setCustomDecoration(.roundedButton)
                                }
                                .sheet(isPresented: self.$showResult, onDismiss: {
                                    self.otkNpi.reset()
                                }) {
                                    if self.otkNpi.otkState.command == .exportKey {
                                        ViewExportWifKey().environmentObject(self.appController)
                                            .addSheetTitle(AppStrings.exportKey)
                                    }
                                    else if self.otkNpi.otkState.command == .showKey {
                                        ViewPublicKeyInformation().environmentObject(self.appController)
                                            .addSheetTitle(AppStrings.showKey)
                                    }
                                    else {
                                        ViewOpenTurnKeyInfo(btcBalance: self.$otkBtcBalance).environmentObject(self.appController)
                                            .addSheetTitle(AppStrings.openturnkeyInfo)
                                    }
                                }

                                Spacer()
                            }.frame(minWidth: .zero, idealWidth: .none, maxWidth: .infinity, minHeight: 80, idealHeight: .none, maxHeight: 160, alignment: .center)
                        }
                    }
                }
                .disabled(self.executingRequest)
                .onTapBackground({
                    UIApplication.shared.endEditing()
                })
                .navigationBarTitle(Text("OpenTurnKey"), displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    withAnimation {
                        self.appController.interacts = .menuOpenTurnKey
                    }
                }) {
                    Image("menu")
                })
                .toastMessage(message: self.$message, show: self.$showToast)
            }
            
            GeometryReader { _ in
                EmptyView()
            }
            .background(Color.gray.opacity(0.8))
            .opacity(self.showDialogEnterPin && self.otkNpi.request.command != .invalid ? 0.5 : 0.0)
            .animation(.easeInOut)
            .onTapGesture {
                UIApplication.shared.endEditing()
                self.showDialogEnterPin = false
            }

            DialogEnterPin(showDialog: self.showDialogEnterPin, closeDialog: {
                withAnimation {
                    self.showDialogEnterPin = false
                }
            }, pin: "", handler: {pin in
                print(pin)
                self.otkNpi.request.pin = pin
                self.makeRequest()
            })
        }
    }
    
    func makeRequest() {
        self.executingRequest = true
        self.otkNpi.beginScanning(onCompleted: {
            if (self.otkNpi.readCompleted) {
                print(self.otkNpi)
                let execState = self.otkNpi.otkState.execState
                let command = self.otkNpi.otkState.command
                let hint = self.appController.requestHint
                
                if execState == .success {
                    if command == .reset || command == .unlock || command == .setKey || command == .setNote || command == .setPin {
                        self.showToast(hint + "executed success.")
                    }
                    else if command == .exportKey || command == .showKey {
                        self.showResult = true
                        self.executingRequest = false
                    }
                }
                if execState == .fail {
                    self.showToast(hint + "executed fail.")
                }
                else {
                    if command == .invalid {
                        // no request, just otk info
                        _ = BlockChainInfoService.getBalance(address: self.otkNpi.otkData.btcAddress).done({result in
                            if (result > 0) {
                                self.otkBtcBalance = Double(result) / 100000000
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
            self.showToast = true
            self.executingRequest = false
        }
    }
}

struct PageOpenTurnKey_Previews: PreviewProvider {
    static var previews: some View {
        PageOpenTurnKey().environmentObject(AppController())
    }
}
