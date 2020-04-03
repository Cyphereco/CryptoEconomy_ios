//
//  SideMenuPayPage.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/3/31.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct SideMenuPay: View {
    @Binding var showMenu: Bool
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var showConfigLocalCurrency: Bool
    @Binding var showConfigFees: Bool
    
    @EnvironmentObject var appConfig: AppConfig

    var body: some View {
        VStack {
            MenuItem(itemLabel: "Set Local Currency", completion: {
                withAnimation {
                    self.showMenu = false
                    self.showConfigLocalCurrency = true
                }
            })
            MenuItem(itemLabel: "Set Transaction Fees", completion: {
                withAnimation {
                    self.showMenu = false
                    self.showConfigFees = true
                }
            })
            MenuItemToggle(itemLabel: "Fees Included", onState: self.$appConfig.feesIncluded)
            MenuItemToggle(itemLabel: "Use Fix Address", onState: self.$appConfig.useFixAddress)
            MenuItem(itemLabel: "User Guide", completion: {
                withAnimation {
                    self.showMenu = false
                }
            })
            MenuItem(itemLabel: "About", completion: {
                withAnimation {
                    self.showMenu = false
                }
            })
            Spacer()
        }
        .padding(.top, 20)
        .frame(maxWidth: .infinity, alignment: .trailing)
        .background(AppConfig.getMenuBackgroundColor(colorScheme: self.colorScheme))
    }
}

struct SideMenuPay_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuPay(showMenu: .constant(false),
                    showConfigLocalCurrency: .constant(false),
                    showConfigFees: .constant(false))
            .environmentObject(AppConfig())
    }
}
