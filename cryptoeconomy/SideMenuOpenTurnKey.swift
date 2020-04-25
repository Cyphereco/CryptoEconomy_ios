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
    @EnvironmentObject var appController: AppController
    
    @State var showSheet = false
    @State var promptMessage = false
    @State var messageTitle  = ""
    @State var messageContent = ""
    @State var otkRequest = OtkRequest()

    var body: some View {
        VStack {
            RowButton(text: AppStrings.setPinCode){
                self.otkRequest.command = .setPin
                self.otkRequest.data = "99999999"

                self.messageTitle = "Warning!"
                self.messageContent = "set pin code with fingerprint authorization."
                self.promptMessage = true
                self.closeMenu()
            }.setCustomDecoration(.foregroundNormal).padding()
            
            RowButton(text: AppStrings.showKey){
                var otkRequest = OtkRequest()
                otkRequest.command = .showKey
                self.setOtkRequest(otkRequest, hint: AppStrings.showKey)
                self.closeMenu()
            }.setCustomDecoration(.foregroundNormal).padding()
            
            RowButton(text: AppStrings.writeNote){
                var otkRequest = OtkRequest()
                otkRequest.command = .setNote
                otkRequest.data = "This is OpenTurnKey"
                self.setOtkRequest(otkRequest, hint: AppStrings.writeNote)
                self.closeMenu()
            }.setCustomDecoration(.foregroundNormal).padding()
            
            RowButton(text: AppStrings.msgSignVerify){
                self.showSheet = true
                self.closeMenu()
            }.setCustomDecoration(.foregroundNormal).padding()
            
            RowButton(text: AppStrings.chooseKey){
                var otkRequest = OtkRequest()
                otkRequest.command = .setKey
                otkRequest.data = "2,4,6,8,10"
                self.setOtkRequest(otkRequest, hint: AppStrings.chooseKey)
                self.closeMenu()
            }.setCustomDecoration(.foregroundNormal).padding()
            
            RowButton(text: AppStrings.unlock){
                var otkRequest = OtkRequest()
                otkRequest.command = .unlock
                self.setOtkRequest(otkRequest, hint: AppStrings.unlock)
                self.closeMenu()
            }.setCustomDecoration(.foregroundNormal).padding()
            
            RowButton(text: AppStrings.reset){
                var otkRequest = OtkRequest()
                otkRequest.command = .reset
                self.setOtkRequest(otkRequest, hint: AppStrings.reset)
                self.closeMenu()
            }.setCustomDecoration(.foregroundNormal).padding()
            
            RowButton(text: AppStrings.exportKey){
                var otkRequest = OtkRequest()
                otkRequest.command = .exportKey
                self.setOtkRequest(otkRequest, hint: AppStrings.exportKey)
                self.closeMenu()
            }.setCustomDecoration(.foregroundNormal).padding()
            
        }.asSideMenu(isOpened: self.isOpened)
        .sheet(isPresented: self.$showSheet){
            ViewMessageSignValidate()
                .addSheetTitle(AppStrings.msgSignVerify)
        }
        .alert(
            isPresented: $promptMessage,
            content: {
                Alert(title: Text(self.messageTitle),
                      message: Text(self.messageContent),
                      primaryButton: .default(
                        Text("cancel"),
                        action: {
                        }
                    ),
                      secondaryButton: .default(
                        Text("I Understood!"),
                        action: {
                            self.setOtkRequest(self.otkRequest, hint: AppStrings.setPinCode)
                      }
                    )
                )
            }
        )
    }
    
    func setOtkRequest(_ request: OtkRequest, hint: String) {
        // cancel existing request if any
        if AppController.otkNpi.request.command != .invalid {
            self.appController.cancelOtkRequest(continueAfterStarted: false)
        }
        
        // set new request, use uuid as identifier for cancel 
        let requestId = UUID()
        AppController.otkNpi.request = request
        self.appController.requestHint = hint
        self.appController.requestId = requestId
        
        // set a timeout cancel, if scan not started in time
        DispatchQueue.main.asyncAfter(deadline: .now() + AppController.REQUEST_TIMEOUT) {
            if self.appController.requestId == requestId {
                self.appController.cancelOtkRequest(continueAfterStarted: true)
            }
        }
    }
}

struct SideMenuOpenTurnKey_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuOpenTurnKey(isOpened: true, closeMenu: {})
    }
}
