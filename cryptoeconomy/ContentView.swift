//
//  ContentView.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/3/28.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appConfig: AppConfig
    @EnvironmentObject var appData: AppData
    
    var body: some View {
        TabView(selection: $selection){
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
        }.accentColor(AppConfig.getAccentColor(colorScheme: self.colorScheme))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["en", "zh-Hant", "zh-Hans", "ja"], id: \.self) {localeIdentifier in
            ContentView().environmentObject(AppConfig())
                .environmentObject(AppData())
                .environment(\.locale, .init(identifier: localeIdentifier))
                .previewDisplayName(localeIdentifier)
        }
    }
}
