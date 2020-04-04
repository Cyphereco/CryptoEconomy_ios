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
    
    let setPinCode = NSLocalizedString("set_pin_code", comment:"")
    let showKey = NSLocalizedString("show_full_public_key_information", comment:"")
    let writeNote = NSLocalizedString("write_note", comment:"")
    let msgSignVerify = NSLocalizedString("message_sign_validate", comment:"")
    let chooseKey = NSLocalizedString("choose_key", comment:"")
    let unlock = NSLocalizedString("unlock", comment:"")
    let reset = NSLocalizedString("reset", comment:"")
    let exportKey = NSLocalizedString("export_key", comment:"")

    var body: some View {
        VStack {
            MenuItem(itemLabel: setPinCode, completion: {
                self.requestHint = self.setPinCode
                withAnimation {
                    self.showMenu = false
                }
            })
            MenuItem(itemLabel: showKey, completion: {
                self.requestHint = self.showKey
                withAnimation {
                    self.showMenu = false
                }
            })
            MenuItem(itemLabel: writeNote, completion: {
                self.requestHint = self.writeNote
                withAnimation {
                    self.showMenu = false
                }
            })
            MenuItem(itemLabel: msgSignVerify, completion: {
                self.requestHint = self.msgSignVerify
                withAnimation {
                    self.showMenu = false
                }
            })
            MenuItem(itemLabel: chooseKey, completion: {
                self.requestHint = self.chooseKey
                withAnimation {
                    self.showMenu = false
                }
            })
            MenuItem(itemLabel: unlock, completion: {
                self.requestHint = self.unlock
                withAnimation {
                    self.showMenu = false
                }
            })
            MenuItem(itemLabel: reset, completion: {
                self.requestHint = self.reset
                withAnimation {
                    self.showMenu = false
                }
            })
            MenuItem(itemLabel: exportKey, completion: {
                self.requestHint = self.exportKey
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
