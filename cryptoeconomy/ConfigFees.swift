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
    
    @State var strFees = "0.00001"
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appConfig: AppConfig

    var body: some View {
        VStack {
            Text("Set Transaction Fees").fontWeight(.bold).padding()
            Spacer()
            Text(feesPriorityDesc(feesSelection: self.appConfig.feesSelection)).padding(.bottom, 10)
            Slider(value: self.$appConfig.feesSelection, in: 0...3, step: 1, onEditingChanged: { data in
                self.strFees = String(format: "%.8f", self.appConfig.getFees())
            }).padding().accentColor(AppConfig.getAccentColor(colorScheme: self.colorScheme))
            HStack {
                Text("Fees = ")
                if (self.appConfig.feesSelection == 0) {
                    TextFieldWithBottomLine(textContent: self.$strFees, onEditingChanged: { text in
                        print(text)
                    }, textAlign: .center)
                        .foregroundColor(AppConfig.getAccentColor(colorScheme: self.colorScheme))
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
                    if (self.appConfig.feesSelection == FeesPriority.CUSTOM.sliderValue) {
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
    
    func feesPriorityDesc(feesSelection: Double) -> String {
        if (feesSelection < FeesPriority.LOW.sliderValue) {
            return "Custom"
        }
        else if (feesSelection < FeesPriority.MID.sliderValue) {
            return "Low (>= 60 minutes)"
        }
        else if (feesSelection < FeesPriority.HIGH.sliderValue) {
            return "Mid (15~35 minutes)"
        }
        else {
            return "High (5~15 minutes)"
        }
    }
}

struct ConfigFees_Previews: PreviewProvider {
    static var previews: some View {
        ConfigFees(showConfigFees: .constant(false)).environmentObject(AppConfig())
    }
}
