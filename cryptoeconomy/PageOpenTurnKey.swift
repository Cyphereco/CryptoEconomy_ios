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
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appController: AppController

    @State var showOpenTurnKeyInfo = false
    @State var otkBtcBalance = 0.0
    
    let otkNpi = AppController.otkNpi

    var body: some View {
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

                                if (self.otkNpi.request.command != .exportKey && self.otkNpi.request.command != .unlock) {
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
                                self.otkNpi.beginScanning(completion: {
                                    if (self.otkNpi.otkDetected) {
                                        print(self.otkNpi)
                                        self.showOpenTurnKeyInfo = true
                                        _ = BlockChainInfoService.getBalance(address: self.otkNpi.otkData.btcAddress).done({result in
                                            if (result > 0) {
                                                self.otkBtcBalance = Double(result) / 100000000
                                            }
                                        })
                                    }
                                })
                                self.requestHint = AppStrings.readGeneralInformation
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
                                .background(AppController.getAccentColor(colorScheme: self.colorScheme))
                                .cornerRadius(24)
                                .foregroundColor(.white)
                            }
                            .sheet(isPresented: self.$showOpenTurnKeyInfo, onDismiss: {
                                self.otkNpi.reset()
                            }) {
                                ViewOpenTurnKeyInfo(btcBalance: self.$otkBtcBalance).environmentObject(AppController())
                            }
                            
                            Spacer()
                        }.frame(minWidth: .zero, idealWidth: .none, maxWidth: .infinity, minHeight: 80, idealHeight: .none, maxHeight: 160, alignment: .center)
                    }
                }
            }
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
        }
    }
}

struct PageOpenTurnKey_Previews: PreviewProvider {
    static var previews: some View {
        PageOpenTurnKey().environmentObject(AppController())
    }
}
