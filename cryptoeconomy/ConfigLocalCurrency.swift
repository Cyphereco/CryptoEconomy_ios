//
//  ConfigLocalCurrency.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/4/1.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct ConfigLocalCurrency: View {
    @Binding var showConfigLocalCurrency: Bool
    @Binding var appConfig: AppConfig
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {
            Text("Set Local Currency").fontWeight(.bold).padding()
            Spacer()
            VStack {
                Spacer()
                Picker("Set Local Fiat Currency", selection: self.$appConfig.localCurrency) {
                    ForEach(0 ..< AppConfig.fiatCurrencies.count) {
                        Text(AppConfig.fiatCurrencies[$0]).tag($0)
                    }
                }.labelsHidden()
                Spacer()
            }.fixedSize().frame(height: 100)
            Spacer()
            Button(action: {
                withAnimation {
                    self.showConfigLocalCurrency = false
                }
            }) {
                Image("ok")
                }.accentColor(AppConfig.getAccentColor(colorScheme: self.colorScheme)).padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .background(AppConfig.getMenuBackgroundColor(colorScheme: self.colorScheme))
    }
}

struct ConfigLocalCurrency_Previews: PreviewProvider {
    static var previews: some View {
      PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @State var showConfigLocalCurrency = false
        @State var localCurrency = 4
        var body: some View {
            ConfigLocalCurrency(showConfigLocalCurrency: self.$showConfigLocalCurrency, appConfig: .constant(AppConfig()))
        }
    }
}
