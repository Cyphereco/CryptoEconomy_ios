//
//  ContentView.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/3/28.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    let totalTabs = 4
    @GestureState  var dragOffset = CGSize.zero
    @EnvironmentObject var appController: AppController

    var body: some View {
        ZStack {
            TabView(selection: self.$appController.pageSelected){
                PagePay()
                    .tabItem {
                        VStack {
                            Image("pay")
                            Text("pay")
                        }
                    }
                    .tag(0)
                PageOpenTurnKey()
                    .tabItem {
                        VStack {
                            Image("cyphereco_icon")
                            Text("OpenTurnKey")
                        }
                    }
                    .tag(1)
                PageHistory()
                    .tabItem {
                        VStack {
                            Image("history")
                            Text("history")
                        }
                    }
                    .tag(2)
                PageAddresses()
                    .tabItem {
                        VStack {
                            Image("addressbook")
                            Text("addresses")
                        }
                    }
                    .tag(3)
            }
            .blur(radius: self.appController.interacts != .none ? 0.8 : 0)
            .animation(.easeInOut)
            .setCustomDecoration(.accentColor)
            .swipableTabs(currentTab: self.$appController.pageSelected, totalTabs: self.totalTabs)
            
            GeometryReader { _ in
                EmptyView()
            }
            .background(Color.gray.opacity(0.6))
            .opacity(self.appController.interacts != .none ? 0.5 : 0.0)
            .animation(.easeInOut)
            .onTapGesture {
                self.closeMenu()
            }
            .gesture(DragGesture()
                .updating(self.$dragOffset, body: { (value, state, transaction) in
                    state = value.translation
                })
                .onEnded { gesture in
                    if self.appController.interacts == .menuPay || self.appController.interacts == .menuOpenTurnKey {
                        if gesture.translation.width > 100 {
                            withAnimation {
                                self.closeMenu()
                            }
                        }
                    }
                    else if self.appController.interacts == .configLocalCurrency || self.appController.interacts == .configFees {
                        if gesture.translation.height > 100 {
                            withAnimation {
                                self.closeMenu()
                            }
                        }
                    }
                })
            
            SideMenuPay(isOpened: self.appController.interacts == .menuPay, closeMenu: {
                self.closeMenu()
            })
            .offset(x: dragOffset.width > 0 ? dragOffset.width : 0)

            SideMenuOpenTurnKey(isOpened: self.appController.interacts == .menuOpenTurnKey, closeMenu: {
                self.closeMenu()
            })
            .offset(x: dragOffset.width > 0 ? dragOffset.width : 0)

            ConfigLocalCurrency(isOpened: self.appController.interacts == .configLocalCurrency, closeMenu: {
                withAnimation {
                    self.closeMenu()
                }
            })
            .disabled(self.appController.interacts != .configLocalCurrency)
            .offset(y: dragOffset.height > 0 ? dragOffset.height : 0)

            ConfigFees(isOpened: self.appController.interacts == .configFees, closeMenu: {
                withAnimation {
                    self.closeMenu()
                }
            })
            .disabled(self.appController.interacts != .configFees)
            .offset(y: dragOffset.height > 0 ? dragOffset.height : 0)
        }
    }
    
    init() {
        
    }
        
    func closeMenu() {
        UIApplication.shared.endEditing()
        withAnimation {
            if self.appController.interacts == .configLocalCurrency {
                
            }
            else if self.appController.interacts == .configFees {
                
            }
            self.appController.interacts = .none
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["en", "zh-Hant", "zh-Hans", "ja"], id: \.self) {localeIdentifier in
            ContentView()
                .environmentObject(AppController())
                .environment(\.locale, .init(identifier: localeIdentifier))
                .previewDisplayName(localeIdentifier)
        }
    }
}
