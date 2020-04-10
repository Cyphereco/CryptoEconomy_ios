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

    let labelFees = NSLocalizedString("fees", comment: "")
    let labelCustom = NSLocalizedString("custom", comment: "")
    let labelLow = NSLocalizedString("low", comment: "")
    let labelMid = NSLocalizedString("mid", comment: "")
    let labelHigh = NSLocalizedString("high", comment: "")
    let labelMin = NSLocalizedString("minutes", comment: "")

    var body: some View {
        VStack {
            Text("set_transaction_fees").fontWeight(.bold).padding()
            Spacer()
            Text(feesPriorityDesc(feesSelection: self.appConfig.feesSelection)).padding(.bottom, 10)
            Slider(value: self.$appConfig.feesSelection, in: 0...3, step: 1, onEditingChanged: { data in
                self.strFees = AppTools.btcToFormattedString(self.appConfig.getFees())
            }).padding().accentColor(AppConfig.getAccentColor(colorScheme: self.colorScheme))
            HStack {
                Text("\(labelFees) = ")
                if (self.appConfig.feesSelection == 0) {
                    TextFieldWithBottomLine(hint: "",
                                            textContent: self.strFees,
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
            return "\(self.labelCustom)"
        }
        else if (feesSelection < FeesPriority.MID.sliderValue) {
            return "\(self.labelLow) (>= 60 \(self.labelMin))"
        }
        else if (feesSelection < FeesPriority.HIGH.sliderValue) {
            return "\(self.labelMid) (15~35 \(self.labelMin))"
        }
        else {
            return "\(self.labelHigh) (5~15 \(self.labelMin))"
        }
    }
}

struct ConfigFees_Previews: PreviewProvider {
    static var previews: some View {
        ConfigFees(showConfigFees: .constant(false)).environmentObject(AppConfig())
    }
}
