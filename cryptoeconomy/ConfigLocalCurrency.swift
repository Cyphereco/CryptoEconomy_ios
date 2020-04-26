//
//  ConfigLocalCurrency.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/4/1.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct ConfigLocalCurrency: View {
    let isOpened: Bool
    let closeMenu: ()->Void

    @EnvironmentObject var appController: AppController

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                VStack {
                    Image(systemName: "minus").imageScale(.large)
                    Text("set_local_currency").font(.headline).padding(.bottom, 40)
                    Picker("set_local_currency", selection: self.$appController.currencySelection) {
                        ForEach(0 ..< FiatCurrency.allCases.count) {
                            Text(FiatCurrency.allCases[$0].label)
                        }
                    }.labelsHidden().fixedSize().frame(height: 60)
                    Button(action: {
                        withAnimation {
                            self.closeMenu()
                        }
                    }) {
                        Image("ok")
                    }.padding(.top, 40).padding(.bottom)
                }
                .frame(maxWidth: .infinity)
                .setCustomDecoration(.backgroundNormal)
                .offset(y: self.isOpened ? 0 : geometry.size.height)
                .animation(.easeInOut)
            }
        }
        .setCustomDecoration(.accentColor)
    }
}

struct ConfigLocalCurrency_Previews: PreviewProvider {
    static var previews: some View {
        ConfigLocalCurrency(isOpened: true, closeMenu: {}).environmentObject(AppController())
    }
}
