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
    
    @Binding var onStateFeesIncluded: Bool
    @Binding var onStateUseFixAddress: Bool
    
    let light: Double = 224/255
    let dark: Double = 128/255

    var body: some View {
        VStack {
            MenuItem(itemLabel: "Local Currency (USD)", completion: {
                withAnimation {
                    self.showMenu = false
                }
            })
            MenuItem(itemLabel: "Transaction Fee (Low (>60 minutes))", completion: {
                withAnimation {
                    self.showMenu = false
                }
            })
            MenuItemToggle(itemLabel: "Fees Included", onState: self.onStateFeesIncluded)
            MenuItemToggle(itemLabel: "Use Fix Address", onState: self.onStateUseFixAddress)
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
        .background(colorScheme == .dark ? Color(red: dark, green: dark, blue: dark) :
            Color(red: light, green: light, blue: light))
    }
}

struct SideMenuPay_Previews: PreviewProvider {
    static var previews: some View {
      PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @State var showMenu = false
        @State var onStateFeesIncluded = false
        @State var onStateUseFixAddress = false
        var body: some View {
            SideMenuPay(showMenu: self.$showMenu, onStateFeesIncluded: self.$onStateUseFixAddress, onStateUseFixAddress: self.$onStateUseFixAddress)
        }
    }
}
