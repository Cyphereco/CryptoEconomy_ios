//
//  ContentView.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/3/28.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct SwipableTabs: ViewModifier {
    @Binding var currentTab: Int
    let totalTabs: Int
    
    func body(content: Content) -> some View {
        ZStack {
            GeometryReader {_ in
                EmptyView()
            }
            .background(Color.white.opacity(0.001))
            
            content
        }
        .gesture(DragGesture()
            .onEnded { gesture in
                if gesture.translation.width > 100 {
                    withAnimation {
                        if self.currentTab > 0 {
                            self.currentTab -= 1
                        }
                    }
                }
                else if gesture.translation.width < -100 {
                    withAnimation {
                        if self.currentTab < self.totalTabs - 1 {
                            self.currentTab += 1
                        }
                    }
                }
            })
    }
}

extension View {
    func swipableTabs(currentTab: Binding<Int>, totalTabs: Int) -> some View {
        self.modifier(SwipableTabs(currentTab: currentTab, totalTabs: totalTabs))
    }
}

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
            .accentColor(AppConfig.getAccentColor(colorScheme: self.colorScheme))
            .swipableTabs(currentTab: self.$appConfig.pageSelected, totalTabs: self.totalTabs)
            
            GeometryReader { _ in
                EmptyView()
            }
            .background(Color.gray.opacity(0.6))
            .opacity(self.appConfig.showMenu ? 0.5 : 0.0)
            .animation(Animation.easeIn.delay(0.1))
            .onTapGesture {
                self.appConfig.showMenu = false
            }
            .gesture(DragGesture()
                .updating(self.$dragOffset, body: { (value, state, transaction) in
                    state = value.translation
                })
                .onEnded { gesture in
                    if self.appConfig.showMenu {
                        if gesture.translation.width > 100 {
                            withAnimation {
                                self.appConfig.showMenu = false
                            }
                        }
                    }
                })
            
            SideMenuOpenTurnKey(isOpened: self.appConfig.showMenu, closeMenu: {
                withAnimation {
                    self.appConfig.showMenu = false
                }
            })
            .offset(x: dragOffset.width > 0 ? dragOffset.width : 0)
            .animation(.easeInOut)
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
