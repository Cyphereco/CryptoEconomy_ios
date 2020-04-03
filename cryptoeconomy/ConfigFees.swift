//
//  ConfigFees.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/4/1.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct ConfigFees: View {
    @Binding var showConfigFees: Bool
    
    @State var desc = "Low (>= 60 minutes)"
    @State var strFees = "0.00004"
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appConfig: AppConfig

    var body: some View {
        VStack {
            Text("Set Transaction Fees").fontWeight(.bold).padding()
            Spacer()
            Text(desc).padding(.bottom, 10)
            Slider(value: self.$appConfig.feePriority, in: 0...3, step: 1, onEditingChanged: { data in
                if (self.appConfig.feePriority < FeesPriority.LOW.sliderValue) {
                    self.desc = "Custom"
                }
                else if (self.appConfig.feePriority < FeesPriority.MID.sliderValue) {
                    self.desc = "Low (>= 60 minutes)"
                }
                else if (self.appConfig.feePriority < FeesPriority.HIGH.sliderValue) {
                    self.desc = "Mid (15~35 minutes)"
                }
                else {
                    self.desc = "High (5~15 minutes)"
                }
                self.strFees = String(format: "%.8f", self.appConfig.getFees())

            }).padding().accentColor(AppConfig.getAccentColor(colorScheme: self.colorScheme))
            HStack {
                Text("Fees = ")
                if (self.appConfig.feePriority == 0) {
                    TextFieldWithBottomLine(textContent: self.$strFees, onEditingChanged: { text in
                        print(text)
                    }, textAlign: .center)
                        .frame(width: 100)
                        .padding(.top, 10)
                }
                else {
                    Text(String(format: "%.8f", self.appConfig.fees))
                }
                Text(" BTC")
            }
            Button(action: {
                withAnimation {
                    if (self.appConfig.feePriority == FeesPriority.CUSTOM.sliderValue) {
                        self.appConfig.fees = Double(self.strFees)!
                    }
                    self.showConfigFees = false
                }
            }) {
                Image("ok")
            }.padding().accentColor(AppConfig.getAccentColor(colorScheme: self.colorScheme))
            Spacer()
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
        .background(AppConfig.getMenuBackgroundColor(colorScheme: self.colorScheme))
    }
}

struct ConfigFees_Previews: PreviewProvider {
    static var previews: some View {
      PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @State var showConfigFees = false
        @State var feesPriority = 1.0
        @State var fees = 0.000008
        var body: some View {
            ConfigFees(showConfigFees: self.$showConfigFees)
        }
    }
}
