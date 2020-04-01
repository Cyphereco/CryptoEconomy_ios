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
            MenuItem(itemLabel: "Set PIN Code", completion: {
                self.requestHint = ("Set PIN Code")
                withAnimation {
                    self.showMenu = false
                }
            })
            MenuItem(itemLabel: "Show Full Public Key Information", completion: {
                self.requestHint = ("Show Full Public Key Information")
                withAnimation {
                    self.showMenu = false
                }
            })
            MenuItem(itemLabel: "Write Note", completion: {
                self.requestHint = ("Write Note")
                withAnimation {
                    self.showMenu = false
                }
            })
            MenuItem(itemLabel: "Message Sign/Validate", completion: {
                self.requestHint = ("Message Sign/Validate")
                withAnimation {
                    self.showMenu = false
                }
            })
            MenuItem(itemLabel: "Choose Key", completion: {
                self.requestHint = ("Choose Key")
                withAnimation {
                    self.showMenu = false
                }
            })
            MenuItem(itemLabel: "Unlock", completion: {
                self.requestHint = ("Unlock")
                withAnimation {
                    self.showMenu = false
                }
            })
            MenuItem(itemLabel: "Reset", completion: {
                self.requestHint = ("Reset")
                withAnimation {
                    self.showMenu = false
                }
            })
            MenuItem(itemLabel: "Export Key", completion: {
                self.requestHint = ("Export Key")
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
      PreviewWrapper()
    }

    struct PreviewWrapper: View {
      @State var showMenu = false
      @State var requestHint: String = "Read General Information"
      var body: some View {
        SideMenuOpenTurnKey(showMenu: self.$showMenu, requestHint: self.$requestHint)
      }
    }
}
