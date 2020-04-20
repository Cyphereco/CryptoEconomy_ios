//
//  SideMenuOpenTurnKey.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/3/31.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct SideMenuOpenTurnKey: View {
    let isOpened: Bool
    let closeMenu: ()->Void
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appController: AppController

    var body: some View {
        VStack {
            RowButton(text: AppStrings.setPinCode){
                self.setOtkRequest(command: "166", hint: AppStrings.setPinCode)
                self.closeMenu()
            }.foregroundColor(.primary).padding()
            
            RowButton(text: AppStrings.showKey){
                self.setOtkRequest(command: "162", hint: AppStrings.showKey)
                self.closeMenu()
            }.foregroundColor(.primary).padding()
            
            RowButton(text: AppStrings.writeNote){
                self.setOtkRequest(command: "167", hint: AppStrings.writeNote)
                self.closeMenu()
            }.foregroundColor(.primary).padding()
            
            RowButton(text: AppStrings.msgSignVerify){
                self.setOtkRequest(command: "160", hint: AppStrings.msgSignVerify)
                self.closeMenu()
            }.foregroundColor(.primary).padding()
            
            RowButton(text: AppStrings.chooseKey){
                self.setOtkRequest(command: "165", hint: AppStrings.chooseKey)
                self.closeMenu()
            }.foregroundColor(.primary).padding()
            
            RowButton(text: AppStrings.unlock){
                self.setOtkRequest(command: "161", hint: AppStrings.unlock)
                self.closeMenu()
            }.foregroundColor(.primary).padding()
            
            RowButton(text: AppStrings.reset){
                self.setOtkRequest(command: "168", hint: AppStrings.reset)
                self.closeMenu()
            }.foregroundColor(.primary).padding()
            
            RowButton(text: AppStrings.exportKey){
                self.setOtkRequest(command: "169", hint: AppStrings.exportKey)
                self.closeMenu()
            }.foregroundColor(.primary).padding()
            
        }.asSideMenu(isOpened: self.isOpened)
    }
    
    func setOtkRequest(command: String, hint: String) {
        AppController.otkNpi.requestCommand.commandCode = command
        self.appController.requestHint = hint
    }
}

struct SideMenuOpenTurnKey_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuOpenTurnKey(isOpened: true, closeMenu: {})
    }
}
