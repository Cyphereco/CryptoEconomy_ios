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
    
    var body: some View {
        TabView(selection: self.$appConfig.pageSelected){
            PagePay()
                .swipableTabs(currentTab: self.$appConfig.pageSelected, totalTabs: self.totalTabs)
                .tabItem {
                    VStack {
                        Image("pay")
                        Text("pay")
                    }
                }
                .tag(0)
            PageOpenTurnKey()
                .swipableTabs(currentTab: self.$appConfig.pageSelected, totalTabs: self.totalTabs)
                .tabItem {
                    VStack {
                        Image("cyphereco_icon")
                        Text("OpenTurnKey")
                    }
                }
                .tag(1)
            PageHistory()
                .swipableTabs(currentTab: self.$appConfig.pageSelected, totalTabs: self.totalTabs)
                .tabItem {
                    VStack {
                        Image("history")
                        Text("history")
                    }
                }
                .tag(2)
            PageAddresses()
                .swipableTabs(currentTab: self.$appConfig.pageSelected, totalTabs: self.totalTabs)
                .tabItem {
                    VStack {
                        Image("addressbook")
                        Text("addresses")
                    }
                }
                .tag(3)
        }.accentColor(AppConfig.getAccentColor(colorScheme: self.colorScheme))
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
