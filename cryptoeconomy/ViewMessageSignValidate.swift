
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
    @State var textHeight: CGFloat = 24
    @State var keyboardActive = false
    
    @Environment(\.colorScheme) var colorScheme

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
                            TextView(placeholder: "Enter Message", text: self.$message, minHeight: self.textHeight, calculatedHeight: self.$textHeight)
                                .frame(height: self.textHeight < 176 ? self.textHeight : 176)
                                .addUnderline()
                                .padding(.horizontal)
                            Toggle(isOn: self.$useMasterKey){
                                HStack {
                                    Spacer()
                                    Text("Use Master Key").font(.footnote)
                                }
                            }.padding(.horizontal)
                            Spacer()
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
            .addKeyboardDismissButton()
        }
        .isKeyboardActive(keyboardActive: self.$keyboardActive)
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
