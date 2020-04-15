//
//  SideMenuOpenTurnKey.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/3/31.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct OtkCommand: ViewModifier {
    let command: String
    let hint: String
    let completion: () -> Void
    @EnvironmentObject var appConfig: AppConfig

    func body(content: Content) -> some View {
        content
        .onTapGesture {
            withAnimation {
                self.appConfig.requestCommand = self.command
                self.appConfig.requestHint = self.hint
                self.completion()
            }
        }
    }
}

extension View {
    func otkCommand(command: String, hint: String, completion: @escaping ()->Void) -> some View {
        self.modifier(OtkCommand(command: command, hint: hint, completion: completion))
    }
}

struct SideMenuOpenTurnKey: View {
    let isOpened: Bool
    let closeMenu: ()->Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Spacer()
                VStack (alignment: .leading) {
                    Text(AppStrings.setPinCode).padding()
                        .otkCommand(command: "166", hint: AppStrings.setPinCode, completion: {self.closeMenu()})
                    Text(AppStrings.showKey).padding()
                        .otkCommand(command: "162", hint: AppStrings.showKey, completion: {self.closeMenu()})
                    Text(AppStrings.writeNote).padding()
                        .otkCommand(command: "165", hint: AppStrings.writeNote, completion: {self.closeMenu()})
                    Text(AppStrings.msgSignVerify).padding()
                        .otkCommand(command: "160", hint: AppStrings.msgSignVerify, completion: {self.closeMenu()})
                    Text(AppStrings.chooseKey).padding()
                        .otkCommand(command: "167", hint: AppStrings.chooseKey, completion: {self.closeMenu()})
                    Text(AppStrings.unlock).padding()
                        .otkCommand(command: "161", hint: AppStrings.unlock, completion: {self.closeMenu()})
                    Text(AppStrings.reset).padding()
                        .otkCommand(command: "168", hint: AppStrings.reset, completion: {self.closeMenu()})
                    Text(AppStrings.exportKey).padding()
                        .otkCommand(command: "169", hint: AppStrings.exportKey, completion: {self.closeMenu()})
                }
                .background(self.colorScheme == .dark ? Color.black : Color.white)
                .offset(x: self.isOpened ? 0 : geometry.size.width * 2)
                .animation(.easeInOut)
            }
            Spacer()
        }
    }
}

struct SideMenuOpenTurnKey_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuOpenTurnKey(isOpened: true, closeMenu: {})
    }
}
