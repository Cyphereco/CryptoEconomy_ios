
//
//  TabView.swift
//  UITrial
//
//  Created by Quark on 2020/4/24.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct ViewMessageSignValidate: View {
    @State var tabPage = 0
    @GestureState  var dragOffset = CGSize.zero

    @State var messageToBeSigned = ""
    @State var messageToBeSignedHeight: CGFloat = 24

    @State var useMasterKey = false

    let otkNpi = AppController.otkNpi

    @State var keyboardActive = false
    
    @State var signedMessage = ""
    @State var signedMessageHeight: CGFloat = 24
    
    @EnvironmentObject var appController: AppController
    @Environment(\.colorScheme) var colorScheme

    @State var showToastMessage = false
    @State var toastMessage = ""

    @State var QRCodeData = ""
    @State var QRCodeTitle = ""
    
    private let pasteboard = UIPasteboard.general

    @State private var isShowingScanner = false
    @State private var showQRCodeSheet: Bool = false

    @State var messageToBeValidated = "Enter Message"
    @State var messageToBeValidatedHeight: CGFloat = 24
    
    @State var signatureIsValid = false
    @State var signatureIsInvalid = false

    var body: some View {
        GeometryReader{ geometry in
            ZStack {
                // Set bottom layer background to gesture detection
                GeometryReader {_ in
                    EmptyView()
                }
                .background(Color.white.opacity(0.001))
                
                // main UI
                VStack (alignment: .leading){
                    // title tabs
                    HStack {
                        HStack {
                            Spacer()
                            Text(AppStrings.sign)
                            Spacer()
                        }
                        .onTapGesture{
                            self.tabPage = 0
                            
                            if self.messageToBeValidated.isEmpty {
                                self.messageToBeValidated = "Enter Message"
                            }
                            
                            if self.keyboardActive {
                                UIApplication.shared.endEditing()
                            }
                        }
                        
                        HStack {
                            Spacer()
                            Text(AppStrings.validate)
                            Spacer()
                        }
                        .onTapGesture{
                            self.tabPage = 1
                            
                            if self.messageToBeValidated == "Enter Message" {
                                self.messageToBeValidated = ""
                            }
                            
                            if self.keyboardActive {
                                UIApplication.shared.endEditing()
                            }
                        }
                    }.padding(.top)
                    
                    // tab selection underline to indicate which tab is selected
                    self.line.frame(width: geometry.size.width/2)
                        .offset(x: self.tabPage == 0 ? 0 : geometry.size.width/2)
                        .offset(x: -self.dragOffset.width)
                        .animation(.default)

                    // tab pages of message sign and validate
                    ZStack(alignment: .center) {
                        // tab page message sign
                        VStack (alignment: .leading) {
                            // header
                            HStack {
                                Text("Message to Be Signed").font(.headline)
                            }.padding(.horizontal)

                            // message to be signed
                            TextView(placeholder: "Enter Message", text: self.$messageToBeSigned, minHeight: self.messageToBeSignedHeight, calculatedHeight: self.$messageToBeSignedHeight, editable: true)
                                .frame(height: self.messageToBeSignedHeight < 120 ? self.messageToBeSignedHeight : 120)
                                .addUnderline()
                                .padding(.horizontal)

                            // option for use master key to sign message
                            Toggle(isOn: self.$useMasterKey){
                                HStack {
                                    Spacer()
                                    Text("Use Master Key").font(.footnote)
                                }
                            }.padding(.horizontal)

                            // signed message result
                            if !self.signedMessage.isEmpty {
                                // header and copy/qrcode buttons
                                HStack {
                                    Text("Signed Message").font(.headline)
                                    
                                    Spacer()
                                    
                                    CopyButton(copyString: self.signedMessage){
                                        self.toastMessage = "Signed Message" + AppStrings.copied
                                        self.showToastMessage = true
                                    }
                                    
                                    Button(action: {
                                        self.QRCodeTitle = "Signed Message"
                                        self.QRCodeData = self.signedMessage
                                    }){Image("qrcode")}.padding(.horizontal)
                                }.padding(.horizontal)

                                // singed message, not editable
                                TextView(placeholder: "", text: self.$signedMessage, minHeight: self.signedMessageHeight, calculatedHeight: self.$signedMessageHeight, editable: false)
                                    .frame(height: self.signedMessageHeight < 132 ? self.signedMessageHeight : 132)
                                    .addUnderline()
                                    .padding(.horizontal)
                            }
                            
                            Spacer()
                            
                            // option for authoriztion by pin code
                            Toggle(isOn: self.$appController.authByPin){
                                HStack {
                                    Spacer()
                                    Text(AppStrings.authByPin).font(.footnote)
                                }
                            }.padding(.horizontal)
                            
                            Spacer()
                            
                            // sign message button
                            HStack {
                                Spacer()
                                Button(action: {
                                    self.otkNpi.beginScanning(onCompleted: {
                                        if (self.otkNpi.readCompleted) {
                                            // process signature to signed message format
                                            self.signedMessage = self.otkNpi.readTag.info + self.otkNpi.readTag.state + self.otkNpi.readTag.data
                                        }
                                    }, onCanceled: {})
                                }) {
                                    HStack{
                                        if (self.appController.authByPin) {
                                            Image(systemName: "ellipsis").font(.system(size: 19)).padding(4)
                                        }
                                        else {
                                            Image("fingerprint")
                                        }
                                        Text("Sign Message")
                                            .font(.system(size: 20))
                                        .fontWeight(.bold)
                                    }
                                    .padding(12)
                                    .opacity(self.messageToBeSigned.isEmpty ? 0.3 : 1)
                                    .setCustomDecoration(.roundedButton)
                                }
                                .disabled(self.messageToBeSigned.isEmpty)
                            }.padding([.horizontal, .bottom])
                        }
                        .frame(width: geometry.size.width)
                        .offset(x: self.tabPage == 0 ? 0 : -geometry.size.width)
                        .animation(.default)

                        // tab page message validate
                        VStack (alignment: .leading) {
                            // header and paste/scan button
                            HStack {
                                Text("Message to Be Validated").font(.headline)
                                
                                Spacer()
                                
                                Button(action: {
                                    if let pasteString = self.pasteboard.string {
                                        self.signatureIsValid = false
                                        self.signatureIsInvalid = false
                                        self.messageToBeValidated = pasteString
                                    }
                                }){Image("paste")}

                                Button(action: {
                                    self.signatureIsValid = false
                                    self.signatureIsInvalid = false
                                    self.isShowingScanner = true
                                }){Image("scan_qrcode")}.padding(.horizontal)
                                .sheet(isPresented: self.$isShowingScanner) {
                                    QRCodeScanner(closeScanner: {
                                        self.isShowingScanner = false
                                    }, completion: {result in
                                        self.isShowingScanner = false
                                        switch result {
                                            case .success(let data):
                                                self.messageToBeValidated = data
                                            case .failure(let error):
                                                Logger.shared.warning("Scanning failed \(error)")
                                        }
                                    })
                                    .setCustomDecoration(.accentColor)
                                }
                            }.padding(.horizontal)

                            // text input field for message to be validated
                            TextView(placeholder: "Enter Message", text: self.$messageToBeValidated, minHeight: self.messageToBeValidatedHeight, calculatedHeight: self.$messageToBeValidatedHeight, editable: true, onEditingChanged: {
                                    self.signatureIsValid = false
                                    self.signatureIsInvalid = false
                                })
                                .frame(height: self.messageToBeValidatedHeight < 240 ? self.messageToBeValidatedHeight : 240)
                                .addUnderline()
                                .padding(.horizontal)

                            Spacer()
                            
                            // signature validation result
                            HStack {
                                Spacer()
                                if self.signatureIsValid {
                                    VStack (alignment: .center) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 72))
                                            .foregroundColor(.green)
                                            .padding()
                                        Text("Signature is valid.").font(.headline).foregroundColor(.green)
                                    }
                                }
                                else if self.signatureIsInvalid {
                                    VStack (alignment: .center) {
                                        Image(systemName: "exclamationmark.circle.fill")
                                            .font(.system(size: 72))
                                            .foregroundColor(.red)
                                            .padding()
                                        Text("Signature is invalid!").font(.headline).foregroundColor(.red)
                                    }
                                }
                                Spacer()
                            }

                            Spacer()
                            
                            // message validation button
                            HStack {
                                Spacer()
                                Button(action: {
                                    if self.messageToBeValidated == self.signedMessage {
                                        self.signatureIsValid = true
                                    }
                                    else {
                                        self.signatureIsInvalid = true
                                    }
                                }) {
                                    HStack{
                                        Image("validate")
                                        Text("Validate Message")
                                            .font(.system(size: 20))
                                        .fontWeight(.bold)
                                    }
                                    .padding(12)
                                    .opacity(self.messageToBeValidated.isEmpty ? 0.3 : 1)
                                    .setCustomDecoration(.roundedButton)
                                }
                                .disabled(self.messageToBeValidated.isEmpty)
                            }.padding([.horizontal, .bottom])
                        }
                        .frame(width: geometry.size.width)
                        .offset(x: self.tabPage == 1 ? 0 : geometry.size.width)
                        .animation(.default)
                    }
                    .offset(x: self.dragOffset.width)
                    .setCustomDecoration(.accentColor)
                }
                
                // Set front shaded cover to freeze under UI when QR code displayed and dismiss QR code on tapping
                GeometryReader { _ in
                    EmptyView()
                }
                .background(Color.gray.opacity(0.6))
                .opacity(self.QRCodeData.count > 0 ? 0.5 : 0.0)
                .animation(.easeInOut)
                .onTapGesture {
                    self.QRCodeData = ""
                }

                // show signed message QR Code
                if !self.QRCodeData.isEmpty {
                    VStack(alignment: .center) {
                        Text(self.QRCodeTitle).font(.headline).padding()
                        ImageQRCode(text: self.QRCodeData).padding()
                        Button(action: {
                            self.QRCodeData = ""
                        }){
                            Image(systemName: "xmark.circle.fill").font(.title)
                        }.padding()
                    }.frame(minWidth: 300, minHeight: 480)
                    .setCustomDecoration(.backgroundNormal)
                    .setCustomDecoration(.foregroundNormal)
                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
                }
            }
            .gesture(DragGesture()
                .updating(self.$dragOffset, body: { (value, state, transaction) in
                   state = value.translation
                })
                .onEnded { gesture in
                    if self.tabPage == 1 && gesture.translation.width > 100 {
                        self.tabPage = 0
                        if self.messageToBeValidated.isEmpty {
                            self.messageToBeValidated = "Enter Message"
                        }
                    }
                    if self.tabPage == 0 && gesture.translation.width < -100 {
                        self.tabPage = 1
                        if self.messageToBeValidated == "Enter Message" {
                            self.messageToBeValidated = ""
                        }
                    }
                    if self.keyboardActive {
                        UIApplication.shared.endEditing()
                    }
                })
            .onTapGesture {
                if self.keyboardActive {
                    UIApplication.shared.endEditing()
                }
            }
        }
        .addKeyboardDismissButton()
        .isKeyboardActive(keyboardActive: self.$keyboardActive)
        .toastMessage(message: self.$toastMessage, show: self.$showToastMessage)
    }
    
    // tab selectionn indication line
    var line: some View {
        VStack {
            Divider().setCustomDecoration(.backgroundReversed)
        }.padding(.horizontal)
    }
}

struct TabPagesView_Previews: PreviewProvider {
    static var previews: some View {
        ViewMessageSignValidate().environmentObject(AppController())
    }
}
