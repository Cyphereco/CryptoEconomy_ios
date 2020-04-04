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
    
    let setCurrency = NSLocalizedString("set_local_currency", comment:"")
    let setFees = NSLocalizedString("set_transaction_fees", comment:"")
    let feesIncluded = NSLocalizedString("fees_included", comment:"")
    let useFixAddress = NSLocalizedString("use_fix_address", comment:"")
    let userGuide = NSLocalizedString("user_guide", comment:"")
    let about = NSLocalizedString("about", comment:"")

    var body: some View {
        VStack {
            MenuItem(itemLabel: setCurrency, completion: {
                withAnimation {
                    self.showMenu = false
                    self.showConfigLocalCurrency = true
                }
            })
            MenuItem(itemLabel: setFees, completion: {
                withAnimation {
                    self.showMenu = false
                    self.showConfigFees = true
                }
            })
            MenuItemToggle(itemLabel: feesIncluded, onState: self.$appConfig.feesIncluded)
            MenuItemToggle(itemLabel: useFixAddress, onState: self.$appConfig.useFixAddress)
            MenuItem(itemLabel: userGuide, completion: {
                withAnimation {
                    self.showMenu = false
                }
            })
            MenuItem(itemLabel: about, completion: {
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
