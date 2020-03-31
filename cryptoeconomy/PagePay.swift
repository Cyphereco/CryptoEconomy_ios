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
    @State var useAllFunds: Bool = false
    @State var authByPin: Bool = false
    @State var onStateFeesIncluded = false
    @State var onStateUseFixAddress = false
    
    var body: some View {
        NavigationView {
            GeometryReader {geometry in
                ZStack(alignment: .trailing) {
                    VStack {
                        TextEstFeesInfo()
                            .padding([.top, .trailing], 20.0)
                        Spacer()
                        TextFieldBtcAddress()
                            .padding(.horizontal, 16.0)
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
                                    .background(Color.init(red: 0.5, green: 0.75, blue: 1))
                                .cornerRadius(24)
                                .foregroundColor(.black)
                            }
                            .padding(.trailing, 20.0)
                        }
                        Spacer()
                    }.disabled(self.showMenu)
                    if (self.showMenu) {
                        SideMenuPay(showMenu: self.$showMenu, onStateFeesIncluded: self.$onStateUseFixAddress, onStateUseFixAddress: self.$onStateUseFixAddress)
                            .frame(width: geometry.size.width/2)
                            .transition(.move(edge: .top))
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
            })
        }
    }
}

struct PagePay_Previews: PreviewProvider {
    static var previews: some View {
        PagePay()
    }
}
