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
        
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appConfig: AppConfig
    
    let useAllFunds = NSLocalizedString("use_all_funds", comment: "")
    let authByPin = NSLocalizedString("authorization_with_pin_code", comment: "")

    var body: some View {
        NavigationView {
            GeometryReader {geometry in
                ZStack(alignment: .trailing) {
                    VStack(alignment: .trailing) {
                        TextEstFeesInfo(currencySelection: self.$appConfig.currencySelection, fees: self.$appConfig.fees)
                            .padding([.top, .trailing], 20.0)
                        Spacer()
                        TextFieldBtcAddress(address: "")
                            .padding(.horizontal, 20.0)
                        Spacer()
                        TextFieldPayAmount(localCurrency: self.$appConfig.currencySelection, strAmountBtc: "0.0", strAmountFiat: "0.0")
                            .padding(.horizontal, 20.0)
                        Toggle(isOn: self.$appConfig.useAllFunds){
                            HStack {
                                Spacer()
                                Text(self.useAllFunds).font(.footnote)
                            }
                        }.padding(.horizontal, 20.0)
                        Spacer()
                        Toggle(isOn: self.$appConfig.authByPin){
                            HStack {
                                Spacer()
                                Text(self.authByPin).font(.footnote)
                            }
                        }.padding(.horizontal, 20.0)
                        Button(action: {
                            
                        }) {
                            HStack{
                                Image("fingerprint")
                                Text("sign_payment")
                                    .font(.system(size: 20))
                                .fontWeight(.bold)
                            }
                            .frame(minWidth: 160)
                            .padding(12)
                            .background(AppConfig.getAccentColor(colorScheme: self.colorScheme))
                            .cornerRadius(24)
                            .foregroundColor(.white)
                        }
                        .padding(.trailing, 20.0)
                        Spacer()
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
                                .frame(height: geometry.size.height/2)
                                .cornerRadius(20)
                                .transition(.move(edge: .bottom))
                        }
                    }
                    if (self.showConfigFees) {
                        VStack {
                            Spacer()
                            ConfigFees(showConfigFees: self.$showConfigFees)
                                .frame(height: geometry.size.height/2)
                                .cornerRadius(20)
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
