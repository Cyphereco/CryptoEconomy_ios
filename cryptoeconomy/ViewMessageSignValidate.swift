
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

    @State var message = ""
    @State var useMasterKey = false
    let otkNpi = AppController.otkNpi
    @State var messageHeight: CGFloat = 24
    @State var keyboardActive = false
    
    @State var signedMessage = ""
    @State var signedMessageHeight: CGFloat = 24
    
    @EnvironmentObject var appController: AppController
    @Environment(\.colorScheme) var colorScheme
    private let pasteboard = UIPasteboard.general
    @State private var isShowingScanner = false
    @State var showToastMessage = false
    @State var toastMessage = ""
    @State private var showQRCodeSheet: Bool = false

    @State var QRCodeData = ""
    @State var QRCodeTitle = ""

    var body: some View {
        GeometryReader{ geometry in
            ZStack {
                GeometryReader {_ in
                    EmptyView()
                }
                .background(Color.white.opacity(0.001))
                
                VStack (alignment: .leading){
                    HStack {
                        HStack {
                            Spacer()
                            Text(AppStrings.sign)
                            Spacer()
                        }
                        .onTapGesture{
                            self.tabPage = 0
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
                            if self.keyboardActive {
                                UIApplication.shared.endEditing()
                            }
                        }
                    }.padding(.top)
                    
                    self.line.frame(width: geometry.size.width/2)
                        .offset(x: self.tabPage == 0 ? 0 : geometry.size.width/2)
                        .offset(x: -self.dragOffset.width)
                        .animation(.default)

                    
                    ZStack(alignment: .center) {
                        // Sign Message page
                        VStack (alignment: .leading) {
                            Text("Message to Be Signed").font(.headline).padding(.horizontal)
//                            BetterTextField(placeholder: "Enter Message", text: self.$message, width: 350, height: self.$textHeight)
//                                .isEditable(true)
//                                .isScrollable(true)
//                                .textColor(self.colorScheme == .dark ? .white : .black)
                            TextView(placeholder: "Enter Message", text: self.$message, minHeight: self.messageHeight, calculatedHeight: self.$messageHeight, editable: true)
                                .frame(height: self.messageHeight < 120 ? self.messageHeight : 120)
                                .addUnderline()
                                .padding(.horizontal)

                            Toggle(isOn: self.$useMasterKey){
                                HStack {
                                    Spacer()
                                    Text("Use Master Key").font(.footnote)
                                }
                            }.padding(.horizontal)

                            if !self.signedMessage.isEmpty {
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

                                TextView(placeholder: "", text: self.$signedMessage, minHeight: self.signedMessageHeight, calculatedHeight: self.$signedMessageHeight, editable: false)
                                    .frame(height: self.signedMessageHeight < 132 ? self.signedMessageHeight : 132)
                                    .addUnderline()
                                    .padding(.horizontal)
                            }
                            Spacer()
                            Toggle(isOn: self.$appController.authByPin){
                                HStack {
                                    Spacer()
                                    Text(AppStrings.authByPin).font(.footnote)
                                }
                            }.padding(.horizontal)
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
                                    .opacity(self.message.isEmpty ? 0.3 : 1)
                                    .setCustomDecoration(.roundedButton)
                                }
                                .disabled(self.message.isEmpty)
                            }.padding([.horizontal, .bottom])
                        }
                        .frame(width: geometry.size.width)
                        .offset(x: self.tabPage == 0 ? 0 : -geometry.size.width)
                        .animation(.default)

                        // Validate Signature page
                        VStack {
                            Spacer()
                            Text("Validate signature")
                            Spacer()
                        }
                        .frame(width: geometry.size.width)
                        .background(Color.orange)
                        .offset(x: self.tabPage == 1 ? 0 : geometry.size.width)
                        .animation(.default)
                    }
                    .offset(x: self.dragOffset.width)
                    .setCustomDecoration(.accentColor)
                }
                
                GeometryReader { _ in
                    EmptyView()
                }
                .background(Color.gray.opacity(0.6))
                .opacity(self.QRCodeData.count > 0 ? 0.5 : 0.0)
                .animation(.easeInOut)
                .onTapGesture {
                    self.QRCodeData = ""
                }

                if !self.QRCodeData.isEmpty {
                    VStack(alignment: .center) {
                        Text(self.QRCodeTitle).font(.headline).padding()
                        Text(self.QRCodeData).lineLimit(10).multilineTextAlignment(.leading).frame(maxWidth: 260, maxHeight: 150)
                        ImageQRCode(text: self.QRCodeData).padding()
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
                    }
                    if self.tabPage == 0 && gesture.translation.width < -100 {
                        self.tabPage = 1
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
    
    var line: some View {
        VStack {
            Divider().setCustomDecoration(.backgroundReversed)
        }.padding(.horizontal)
    }
}

struct TabPagesView_Previews: PreviewProvider {
    static var previews: some View {
        ViewMessageSignValidate()
    }
}
