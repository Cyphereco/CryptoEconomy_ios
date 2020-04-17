//
//  ConfigFees.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/4/1.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct ConfigFees: View {
    let isOpened: Bool
    let closeMenu: ()->Void

    @State var strFees = "0.00001"
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appConfig: AppConfig

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                VStack {
                    Image(systemName: "minus").imageScale(.large)
                    Text(AppStrings.setTransactionFees).font(.headline).padding([.horizontal, .bottom])
                    Text(self.feesPriorityDesc(feesSelection: self.appConfig.feesSelection)).padding([.horizontal, .top])
                    Slider(value: self.$appConfig.feesSelection, in: 0...3, step: 1, onEditingChanged: { data in
                        self.strFees = AppTools.btcToFormattedString(self.appConfig.getFees())
                    }).padding()
                    HStack {
                        Text("\(AppStrings.fees) = ")
                        if (self.appConfig.feesSelection == 0) {
                            TextFieldWithBottomLine(hint: "",
                                                    textContent: self.$strFees,
                                                    textAlign: .center,
                                                    readOnly: false,
                                onEditingChanged: { text in
                                print(text)
                            })
                            .foregroundColor(AppConfig.getAccentColor(colorScheme: self.colorScheme))
                            .frame(width: 100)
                            .padding(.top, 10)
                        }
                        else {
                            Text(AppTools.btcToFormattedString(self.appConfig.fees))
                        }
                        Text(" BTC")
                    }
                    Button(action: {
                        withAnimation {
                            if (self.appConfig.feesSelection == FeesPriority.CUSTOM.sliderValue) {
                                self.appConfig.fees = Double(self.strFees)!
                            }
                            self.closeMenu()
                        }
                    }) {
                        Image("ok")
                    }.padding()
                }
                .background(self.colorScheme == .dark ? Color.black : Color.white)
                .offset(y: self.isOpened ? 0 : geometry.size.height)
                .animation(.easeInOut)
            }
        }.accentColor(AppConfig.getAccentColor(colorScheme: self.colorScheme))
    }
    
    func feesPriorityDesc(feesSelection: Double) -> String {
        if (feesSelection < FeesPriority.LOW.sliderValue) {
            return "\(AppStrings.custom)"
        }
        else if (feesSelection < FeesPriority.MID.sliderValue) {
            return "\(AppStrings.low) (>= 60 \(AppStrings.minutes))"
        }
        else if (feesSelection < FeesPriority.HIGH.sliderValue) {
            return "\(AppStrings.mid) (15~35 \(AppStrings.minutes))"
        }
        else {
            return "\(AppStrings.high) (5~15 \(AppStrings.minutes))"
        }
    }
}

struct ConfigFees_Previews: PreviewProvider {
    static var previews: some View {
        ConfigFees(isOpened: true, closeMenu: {})
            .environmentObject(AppConfig())
    }
}
