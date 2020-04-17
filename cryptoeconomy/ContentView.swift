//
//  ContentView.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/3/28.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appConfig: AppConfig
    
    let totalTabs = 4
    @GestureState  var dragOffset = CGSize.zero

    var body: some View {
        ZStack {
            TabView(selection: self.$appConfig.pageSelected){
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
            .blur(radius: self.appConfig.interacts != .none ? 0.8 : 0)
            .animation(.easeInOut)
            .accentColor(AppConfig.getAccentColor(colorScheme: self.colorScheme))
            .swipableTabs(currentTab: self.$appConfig.pageSelected, totalTabs: self.totalTabs)
            
            GeometryReader { _ in
                EmptyView()
            }
            .background(Color.gray.opacity(0.6))
            .opacity(self.appConfig.interacts != .none ? 0.5 : 0.0)
            .animation(.easeInOut)
            .onTapGesture {
                self.closeMenu()
            }
            .gesture(DragGesture()
                .updating(self.$dragOffset, body: { (value, state, transaction) in
                    state = value.translation
                })
                .onEnded { gesture in
                    if self.appConfig.interacts == .menuPay || self.appConfig.interacts == .menuOpenTurnKey {
                        if gesture.translation.width > 100 {
                            withAnimation {
                                self.closeMenu()
                            }
                        }
                    }
                    else if self.appConfig.interacts == .configLocalCurrency || self.appConfig.interacts == .configFees {
                        if gesture.translation.height > 100 {
                            withAnimation {
                                self.closeMenu()
                            }
                        }
                    }
                })
            
            SideMenuPay(isOpened: self.appConfig.interacts == .menuPay, closeMenu: {
                self.closeMenu()
            })
            .offset(x: dragOffset.width > 0 ? dragOffset.width : 0)
            .animation(.easeInOut)

            SideMenuOpenTurnKey(isOpened: self.appConfig.interacts == .menuOpenTurnKey, closeMenu: {
                self.closeMenu()
            })
            .offset(x: dragOffset.width > 0 ? dragOffset.width : 0)
            .animation(.easeInOut)

            ConfigLocalCurrency(isOpened: self.appConfig.interacts == .configLocalCurrency, closeMenu: {
                withAnimation {
                    self.closeMenu()
                }
            })
            .offset(y: dragOffset.height > 0 ? dragOffset.height : 0)
            .animation(.easeInOut)

            ConfigFees(isOpened: self.appConfig.interacts == .configFees, closeMenu: {
                withAnimation {
                    self.closeMenu()
                }
            })
            .offset(y: dragOffset.height > 0 ? dragOffset.height : 0)
            .animation(.easeInOut)
        }
    }
    
    func closeMenu() {
        withAnimation {
            self.appConfig.interacts = .none
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["en", "zh-Hant", "zh-Hans", "ja"], id: \.self) {localeIdentifier in
            ContentView()
                .environmentObject(AppConfig())
                .environment(\.locale, .init(identifier: localeIdentifier))
                .previewDisplayName(localeIdentifier)
        }
    }
}
