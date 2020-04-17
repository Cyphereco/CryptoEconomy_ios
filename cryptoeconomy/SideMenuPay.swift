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

            Toggle(AppStrings.useFixAddress, isOn: self.$appConfig.useFixAddress)
                .frame(maxWidth: 240)
                .padding(.horizontal).padding(.bottom, 5)

            RowButton(text: AppStrings.userGuide){
                withAnimation {
                    self.closeMenu()
                }
            }.foregroundColor(.primary).padding()

            RowButton(text: AppStrings.about){
                withAnimation {
                    self.closeMenu()
                }
            }.foregroundColor(.primary).padding()
        }.asSideMenu(isOpened: self.isOpened)
    }
}

struct SideMenuPay_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuPay(isOpened: true, closeMenu: {})
            .environmentObject(AppConfig())
    }
}
