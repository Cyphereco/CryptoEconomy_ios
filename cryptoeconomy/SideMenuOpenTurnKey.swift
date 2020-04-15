//
//  SideMenuOpenTurnKey.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/3/31.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct SideMenuOpenTurnKey: View {
    @Binding var showMenu: Bool
    @Binding var requestHint: String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            MenuItem(itemLabel: AppStrings.setPinCode, completion: {
                self.requestHint = AppStrings.setPinCode
                withAnimation {
                    self.showMenu = false
                }
            })
            MenuItem(itemLabel: AppStrings.showKey, completion: {
                self.requestHint = AppStrings.showKey
                withAnimation {
                    self.showMenu = false
                }
            })
            MenuItem(itemLabel: AppStrings.writeNote, completion: {
                self.requestHint = AppStrings.writeNote
                withAnimation {
                    self.showMenu = false
                }
            })
            MenuItem(itemLabel: AppStrings.msgSignVerify, completion: {
                self.requestHint = AppStrings.msgSignVerify
                withAnimation {
                    self.showMenu = false
                }
            })
            MenuItem(itemLabel: AppStrings.chooseKey, completion: {
                self.requestHint = AppStrings.chooseKey
                withAnimation {
                    self.showMenu = false
                }
            })
            MenuItem(itemLabel: AppStrings.unlock, completion: {
                self.requestHint = AppStrings.unlock
                withAnimation {
                    self.showMenu = false
                }
            })
            MenuItem(itemLabel: AppStrings.reset, completion: {
                self.requestHint = AppStrings.reset
                withAnimation {
                    self.showMenu = false
                }
            })
            MenuItem(itemLabel: AppStrings.exportKey, completion: {
                self.requestHint = AppStrings.exportKey
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

struct SideMenuOpenTurnKey_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuOpenTurnKey(showMenu: .constant(false), requestHint: .constant("Read General Information"))
    }
}
