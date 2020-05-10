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
    @State var showAlert = false
    @State var messageTitle  = ""
    @State var messageContent = ""
    @State var otkRequest = OtkRequest()
    @State var keyboardActive = false
    
    @State var showSetPinDialog = false
    @State var showWriteNoteDialog = false

    var body: some View {
        ZStack {
            VStack {
                RowButton(text: AppStrings.setPinCode){
                    self.otkRequest.command = .setPin

                    self.messageTitle = AppStrings.warning
                    self.messageContent = AppStrings.pin_code_warning_message
                    self.showAlert = true
                    self.closeMenu()
                }.setCustomDecoration(.foregroundNormal).padding()
                
                RowButton(text: AppStrings.showKey){
                    self.otkRequest.command = .showKey

                    self.messageTitle = AppStrings.warning
                    self.messageContent = AppStrings.full_pubkey_info_warning
                    self.showAlert = true
                    self.closeMenu()
                }.setCustomDecoration(.foregroundNormal).padding()
                
                RowButton(text: AppStrings.writeNote){
                    self.otkRequest.command = .setNote
                    self.setOtkRequest(self.otkRequest, hint: AppStrings.writeNote)
                    self.showWriteNoteDialog = true
                    self.closeMenu()
                }.setCustomDecoration(.foregroundNormal).padding()
                
                RowButton(text: AppStrings.message_sign_validate){
                    self.otkRequest.command = .invalid
                    self.showSheet = true
                    self.closeMenu()
                }.setCustomDecoration(.foregroundNormal).padding()
                
                RowButton(text: AppStrings.choose_key){
                    self.otkRequest.command = .setKey

                    self.messageTitle = AppStrings.warning
                    self.messageContent = AppStrings.choose_key_warning_message
                    self.showAlert = true
                    self.closeMenu()
                }.setCustomDecoration(.foregroundNormal).padding()
                
                RowButton(text: AppStrings.unlock){
                    self.otkRequest.command = .unlock

                    self.messageTitle = AppStrings.warning
                    self.messageContent = AppStrings.unlock_warning
                    self.showAlert = true
                    self.closeMenu()
                }.setCustomDecoration(.foregroundNormal).padding()
                
                RowButton(text: AppStrings.reset){
                    self.otkRequest.command = .reset

                    self.messageTitle = AppStrings.warning
                    self.messageContent = AppStrings.reset_warning_message
                    self.showAlert = true
                    self.closeMenu()
                }.setCustomDecoration(.foregroundNormal).padding()
                
                RowButton(text: AppStrings.exportKey){
                    self.otkRequest.command = .exportKey

                    self.messageTitle = AppStrings.warning
                    self.messageContent = AppStrings.export_wif_warning_message
                    self.showAlert = true
                    self.closeMenu()
                }.setCustomDecoration(.foregroundNormal).padding()
                
            }.asSideMenu(isOpened: self.isOpened)
            .sheet(isPresented: self.$showSheet, onDismiss: {
                if self.keyboardActive {
                    UIApplication.shared.endEditing()
                }
                if self.otkRequest.command == .setKey {
                    if self.otkRequest.data.isEmpty {
                        self.appController.cancelOtkRequest(continueAfterStarted: false)
                    }
                    else {
                        self.setOtkRequest(self.otkRequest, hint: AppStrings.choose_key)
                    }
                }
                else {
                    self.appController.cancelOtkRequest(continueAfterStarted: false)
                }
            }){
                if self.otkRequest.command == .setKey {
                    ViewChooseKey(otkRequest: self.$otkRequest, closeSheet: {
                        self.showSheet = false
                    }).addSheetTitle(AppStrings.choose_key)
                }
                else {
                    ViewMessageSignValidate()
                        .environmentObject(self.appController)
                        .addSheetTitle(AppStrings.message_sign_validate)
                }
            }
            .alert(
                isPresented: $showAlert,
                content: {
                    Alert(title: Text(self.messageTitle),
                          message: Text(self.messageContent),
                          primaryButton: .cancel(Text(AppStrings.cancel)),
                          secondaryButton: .default(
                            Text(AppStrings.i_understood),
                            action: {
                                var hint = AppStrings.readGeneralInformation
                                switch self.otkRequest.command {
                                    case .setPin:
                                        hint = AppStrings.setPinCode
                                        self.showSetPinDialog = true
                                        break
                                    case .showKey:
                                        hint = AppStrings.showKey
                                        break
                                    case .setKey:
                                        self.showSheet = true
                                        break
                                    case .unlock:
                                        hint = AppStrings.unlock
                                        break
                                    case .reset:
                                        hint = AppStrings.reset
                                        break
                                    case .exportKey:
                                        hint = AppStrings.exportKey
                                        break
                                    case .invalid: break
                                    case .sign: break
                                    case .setNote: break
                                    case .cancel: break
                                }
                                self.setOtkRequest(self.otkRequest, hint: hint)
                          }
                        )
                    )
                }
            )
            .isKeyboardActive(keyboardActive: self.$keyboardActive)

            DialogSetPin(showDialog: self.showSetPinDialog, closeDialog: {
                self.appController.cancelOtkRequest(continueAfterStarted: false)
                self.showSetPinDialog = false
            }, handler: {pin in
                self.otkRequest.command = .setPin
                self.otkRequest.data = pin
                self.setOtkRequest(self.otkRequest, hint: AppStrings.setPinCode)
            })
            
            DialogWriteNote(showDialog: self.showWriteNoteDialog, closeDialog: {
                self.appController.cancelOtkRequest(continueAfterStarted: false)
                self.showWriteNoteDialog = false
            }, handler: {note in
                self.otkRequest.command = .setNote
                self.otkRequest.data = note
                self.setOtkRequest(self.otkRequest, hint: AppStrings.writeNote)
            })
        }
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
        SideMenuOpenTurnKey(isOpened: true, closeMenu: {}).environmentObject(AppController())
    }
}
