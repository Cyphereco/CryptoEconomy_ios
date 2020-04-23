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
        var otkRequest = OtkRequest()
        
        return VStack {
            RowButton(text: AppStrings.setPinCode){
                otkRequest.command = .setPin
                self.setOtkRequest(otkRequest, hint: AppStrings.setPinCode)
                self.closeMenu()
            }.foregroundColor(.primary).padding()
            
            RowButton(text: AppStrings.showKey){
                otkRequest.command = .showKey
                self.setOtkRequest(otkRequest, hint: AppStrings.showKey)
                self.closeMenu()
            }.foregroundColor(.primary).padding()
            
            RowButton(text: AppStrings.writeNote){
                otkRequest.command = .setNote
                self.setOtkRequest(otkRequest, hint: AppStrings.writeNote)
                self.closeMenu()
            }.foregroundColor(.primary).padding()
            
            RowButton(text: AppStrings.msgSignVerify){
                self.setOtkRequest(otkRequest, hint: AppStrings.msgSignVerify)
                self.closeMenu()
            }.foregroundColor(.primary).padding()
            
            RowButton(text: AppStrings.chooseKey){
                otkRequest.command = .setKey
                self.setOtkRequest(otkRequest, hint: AppStrings.chooseKey)
                self.closeMenu()
            }.foregroundColor(.primary).padding()
            
            RowButton(text: AppStrings.unlock){
                otkRequest.command = .unlock
                self.setOtkRequest(otkRequest, hint: AppStrings.unlock)
                self.closeMenu()
            }.foregroundColor(.primary).padding()
            
            RowButton(text: AppStrings.reset){
                otkRequest.command = .reset
                self.setOtkRequest(otkRequest, hint: AppStrings.reset)
                self.closeMenu()
            }.foregroundColor(.primary).padding()
            
            RowButton(text: AppStrings.exportKey){
                otkRequest.command = .exportKey
                self.setOtkRequest(otkRequest, hint: AppStrings.exportKey)
                self.closeMenu()
            }.foregroundColor(.primary).padding()
            
        }.asSideMenu(isOpened: self.isOpened)
    }
    
    func setOtkRequest(_ request: OtkRequest, hint: String) {
        // cancel existing request if any
        if AppController.otkNpi.request.command != .invalid {
            self.appController.cancelOtkRequest(continueAfterStarted: false)
        }
        
        // set new request
        AppController.otkNpi.request = request
        self.appController.requestHint = hint
        
        let cachedReuqet = request
        
//        // set a timeout cancel, if scan not started in time
//        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
//            if AppController.otkNpi.request.command == cachedReuqet.command {
//                self.appController.cancelOtkRequest(continueAfterStarted: true)
//            }
//        }
    }
}

struct SideMenuOpenTurnKey_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuOpenTurnKey(isOpened: true, closeMenu: {})
    }
}
