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

    @State var onStateFeesIncluded = false
    @State var onStateUseFixAddress = false

    @State var useAllFunds: Bool = false
    @State var authByPin: Bool = false
    
    @State var localCurrency = 4
    
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationView {
            GeometryReader {geometry in
                ZStack(alignment: .trailing) {
                    VStack {
                        TextEstFeesInfo()
                            .padding([.top, .trailing], 20.0)
                        Spacer()
                        TextFieldBtcAddress()
                            .padding(.horizontal, 20.0)
                        Spacer()
                        TextFieldPayAmount()
                            .padding(.horizontal, 20.0)
                        Toggle(isOn: self.$useAllFunds){
                            Text("Use All Funds")
                                .font(.footnote)
                                .multilineTextAlignment(.trailing)
                        }
                        .padding(.leading, 210)
                        .padding(.trailing, 20.0)
                        Spacer()
                        Toggle(isOn: self.$authByPin){
                            Text("Authorization with PIN Code")
                                .font(.footnote)
                        }
                        .padding(.leading, 120)
                        .padding(.trailing, 20.0)
                        HStack {
                            Spacer()
                            Button(action: {
                                
                            }) {
                                HStack{
                                    Image("fingerprint")
                                    Text("Sign Payment")
                                        .font(.system(size: 20))
                                    .fontWeight(.bold)
                                }
                                .padding(12)
                                .background(AppConfig.getAccentColor(colorScheme: self.colorScheme))
                                .cornerRadius(24)
                                .foregroundColor(.white)
                            }
                            .padding(.trailing, 20.0)
                        }
                        Spacer()
                    }.disabled(self.showMenu || self.showConfigFees)
                    if (self.showMenu) {
                        SideMenuPay(showMenu: self.$showMenu,
                                    showConfigLocalCurrency: self.$showConfigLocalCurrency,
                                    showConfigFees: self.$showConfigFees,
                                    onStateFeesIncluded: self.$onStateUseFixAddress,
                                    onStateUseFixAddress: self.$onStateUseFixAddress)
                            .frame(width: geometry.size.width/2)
                            .transition(.move(edge: .top))
                    }
                    if (self.showConfigLocalCurrency) {
                        VStack {
                            Spacer()
                            ConfigLocalCurrency(showConfigLocalCurrency: self.$showConfigLocalCurrency, localCurrency: self.$localCurrency)
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
            .navigationBarTitle(Text("Pay"), displayMode: .inline)
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
            }.disabled(self.showConfigFees))
        }
    }
}

struct PagePay_Previews: PreviewProvider {
    static var previews: some View {
        PagePay()
    }
}
