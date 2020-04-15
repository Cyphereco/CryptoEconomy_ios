//
//  PagePay.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/3/30.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct PagePay: View {
    @State var showMenu: Bool = false
    @State var showConfigLocalCurrency: Bool = false
    @State var showConfigFees: Bool = false
    @State var address: String = ""
        
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appConfig: AppConfig
    
    let useAllFunds = NSLocalizedString("use_all_funds", comment: "")
    let authByPin = NSLocalizedString("authorization_with_pin_code", comment: "")
    @ObservedObject var otkNpi = OtkNfcProtocolInterface()

    var body: some View {
        NavigationView {
            GeometryReader {geometry in
                ZStack(alignment: .trailing) {
                    VStack(alignment: .trailing) {
                        TextEstFeesInfo(currencySelection: self.$appConfig.currencySelection, fees: self.$appConfig.fees)
                            .padding([.top, .trailing], 20.0)
                        Spacer()
                        TextFieldBtcAddress(address: self.$appConfig.payeeAddr)
                            .padding(.horizontal, 20.0)
                        Toggle(isOn: self.$appConfig.useAllFunds){
                            HStack {
                                Spacer()
                                Text(self.useAllFunds).font(.footnote)
                            }
                        }.padding(.horizontal, 20.0).padding(.top, 50)
                        TextFieldPayAmount(localCurrency: self.$appConfig.currencySelection, strAmountBtc: "0.0", strAmountFiat: "0.0").keyboardType(.decimalPad)
                            .padding(.horizontal, 20.0)
                        Toggle(isOn: self.$appConfig.authByPin){
                            HStack {
                                Spacer()
                                Text(self.authByPin).font(.footnote)
                            }
                        }.padding(.horizontal, 20.0).padding(.top, 40).padding(.bottom, 10)
                        Button(action: {
                            self.otkNpi.beginScanning(completion: {})
                        }) {
                            HStack{
                                if (self.appConfig.authByPin) {
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
                            .background(AppConfig.getAccentColor(colorScheme: self.colorScheme))
                            .cornerRadius(24)
                            .foregroundColor(.white)
                        }
                        .padding(.trailing, 20.0)
                        .padding(.bottom, 40)
                    }.disabled(self.showMenu || self.showConfigLocalCurrency || self.showConfigFees)
                    if (self.showMenu) {
                        SideMenuPay(showMenu: self.$showMenu,
                                    showConfigLocalCurrency: self.$showConfigLocalCurrency,
                                    showConfigFees: self.$showConfigFees)
                            .frame(width: geometry.size.width/2)
                            .transition(.move(edge: .top))
                    }
                    if (self.showConfigLocalCurrency) {
                        VStack {
                            Spacer()
                            ConfigLocalCurrency(showConfigLocalCurrency: self.$showConfigLocalCurrency)
                                .cornerRadius(20)
                                .frame(height: geometry.size.height/2)
                                .transition(.move(edge: .bottom))
                        }
                    }
                    if (self.showConfigFees) {
                        VStack {
                            Spacer()
                            ConfigFees(showConfigFees: self.$showConfigFees)
                                .cornerRadius(20)
                                .frame(height: geometry.size.height/2)
                                .transition(.move(edge: .bottom))
                        }
                    }
                }
            }
            .navigationBarTitle(Text("pay"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                withAnimation {
                    self.showMenu.toggle()
                }
            }) {
                if (showMenu) {
                    Image("menu_collapse")
                }
                else {
                    Image("menu_expand")
                }
            }.disabled(self.showConfigFees || self.showConfigLocalCurrency))
        }
    }
}

struct PagePay_Previews: PreviewProvider {
    static var previews: some View {
        PagePay().environmentObject(AppConfig())
    }
}
