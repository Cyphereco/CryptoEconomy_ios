//
//  SideMenuPayPage.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/3/31.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct SideMenuPay: View {
    let isOpened: Bool
    let closeMenu: () -> Void
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appConfig: AppConfig
    @State var alertEmptyAddress = false
    @State var alertAbout = false
    
        
    var body: some View {
        VStack {
            RowButton(text: AppStrings.setCurrency){
                withAnimation {
                   self.closeMenu()
                   self.appConfig.interacts = .configLocalCurrency
               }
            }.foregroundColor(.primary).padding()

            RowButton(text: AppStrings.setFees){
                withAnimation {
                    self.closeMenu()
                    self.appConfig.interacts = .configFees
                }
            }.foregroundColor(.primary).padding()

            Toggle(AppStrings.feesIncluded, isOn: self.$appConfig.feesIncluded)
                .frame(alignment: .trailing)
                .frame(maxWidth: 240)
                .padding(.horizontal).padding(.bottom, 15)

            ZStack {
                Toggle(AppStrings.useFixedAddress, isOn: self.$appConfig.useFixedAddress)
                    .frame(maxWidth: 240)
                    .padding(.horizontal).padding(.bottom, 5)
                    .disabled(self.appConfig.payeeAddr.count < 1)
             
                if(self.appConfig.payeeAddr.count < 1) {
                    Color.white.opacity(0.001)
                    .frame(maxHeight: 44)
                    .onTapGesture {
                        if self.appConfig.payeeAddr.count < 1 {
                            self.alertEmptyAddress = true
                        }
                    }
                    .alert(isPresented: self.$alertEmptyAddress){
                        Alert(title: Text("Recipient address is empty!"))
                    }
                }
            }

            RowButton(text: AppStrings.userGuide){
                withAnimation {
                    self.closeMenu()
                    if let url = URL(string: "https://www.openturnkey.com/guide") {
                        UIApplication.shared.open(url)
                    }
                }
            }.foregroundColor(.primary).padding()

            RowButton(text: AppStrings.about){
                withAnimation {
                    self.closeMenu()
                    self.alertAbout = true
                }
            }.foregroundColor(.primary).padding()
            .alert(isPresented: self.$alertAbout){
                Alert(title: Text("Version") + Text(": \(AppConfig.version)"))
            }

        }.asSideMenu(isOpened: self.isOpened)
    }
}

struct SideMenuPay_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuPay(isOpened: true, closeMenu: {})
            .environmentObject(AppConfig())
    }
}
