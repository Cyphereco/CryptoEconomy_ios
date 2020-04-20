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

    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appController: AppController
    private let textFieldObserver = TextFieldObserver()

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
                            TextFieldWithBottomLine(hint: "",
                                                    textContent: self.$appController.strFees,
                                                    textAlign: .center,
                                                    readOnly: false)
                            .keyboardType(.decimalPad)
                            .foregroundColor(AppController.getAccentColor(colorScheme: self.colorScheme))
                            .frame(width: 100)
                            .padding(.top, 10)
                            .introspectTextField { textField in
                                textField.addTarget(
                                    self.textFieldObserver,
                                    action: #selector(TextFieldObserver.textFieldDidBeginEditing),
                                    for: .editingDidBegin
                                )}
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
                .background(self.colorScheme == .dark ? Color.black : Color.white)
                .offset(y: self.isOpened ? 0 : geometry.size.height)
                .animation(.easeInOut)
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
            }
       }.accentColor(AppController.getAccentColor(colorScheme: self.colorScheme))
        .keyboardResponsive()
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
