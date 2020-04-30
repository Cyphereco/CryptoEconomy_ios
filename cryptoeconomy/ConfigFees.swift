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

    @EnvironmentObject var appController: AppController
    @State var keyboardActive = false

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                VStack {
                    Image(systemName: "minus").imageScale(.large)
                    Text(AppStrings.setTransactionFees).font(.headline).padding([.horizontal, .bottom])
                    Text(self.feesPriorityDesc(feesSelection: self.appController.feesSelection)).padding([.horizontal, .top])
                    Slider(value: self.$appController.feesSelection, in: 0...3, step: 1).padding()
                    HStack {
                        Text("\(AppStrings.fees) = ")
                        if (self.appController.feesSelection == 0) {
                            TextField("0.0", text: self.$appController.strFees)
                            .multilineTextAlignment(.center)
                            .addUnderline()
                            .keyboardType(.decimalPad)
                            .setCustomDecoration(.foregroundAccent)
                            .frame(width: 100)
                            .padding(-4).padding(.top, 5).padding(.bottom, -5)
                            .introspectTextField { textField in
                                textField.becomeFirstResponder()
                            }
                        }
                        else {
                            Text(AppTools.btcToFormattedString(self.appController.fees))
                        }
                        Text(" BTC")
                    }
                    Button(action: {
                        withAnimation {
                            self.closeMenu()
                        }
                    }) {
                        Image("ok")
                    }.padding()
                }
                .setCustomDecoration(.backgroundNormal)
                .offset(y: self.isOpened ? 0 : geometry.size.height * 2)
                .animation(.easeInOut)
                .onTapGesture {
                    if self.keyboardActive {
                        UIApplication.shared.endEditing()
                    }
                }
            }
        }
        .setCustomDecoration(.accentColor)
        .keyboardResponsive()
        .isKeyboardActive(keyboardActive: self.$keyboardActive)
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
            .environmentObject(AppController())
    }
}
