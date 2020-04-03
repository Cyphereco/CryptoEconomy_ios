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
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appConfig: AppConfig

    var body: some View {
        VStack {
            Text("Set Local Currency").fontWeight(.bold).padding()
            Spacer()
            VStack {
                Spacer()
                Picker("Set Local Fiat Currency", selection: self.$appConfig.localCurrency) {
                    ForEach(0 ..< FiatCurrency.allCases.count) {
                        Text(FiatCurrency.allCases[$0].label)
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
        ConfigLocalCurrency(showConfigLocalCurrency: .constant(false))
    }
}
