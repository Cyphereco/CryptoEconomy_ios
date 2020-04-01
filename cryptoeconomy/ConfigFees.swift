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
    @Binding var fees: Double
    @Binding var priority: Double
    
    @State var desc = "Low (>= 60 minutes)"
    @State var customFees = "0.00004"
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            Text("Set Transaction Fees").fontWeight(.bold).padding()
            Spacer()
            Text(desc).padding(.bottom, 10)
            Slider(value: $priority, in: 0...3, step: 1, onEditingChanged: { data in
                if (self.priority == 0) {self.desc = "Custom"}
                if (self.priority == 1) {
                    self.fees = 0.000008
                    self.desc = "Low (>= 60 minutes)"
                }
                if (self.priority == 2) {
                    self.fees = 0.00001
                    self.desc = "Mid (15~35 minutes)"
                }
                if (self.priority == 3) {
                    self.fees = 0.00002
                    self.desc = "High (5~15 minutes)"
                }
            }).padding().accentColor(AppConfig.getAccentColor(colorScheme: self.colorScheme))
            HStack {
                Text("Fees = ")
                if (priority == 0) {
                    TextFieldWithBottomLine(hint: customFees, textContent: self.customFees, onEditingChanged: { text in
                        print(text)
                    }, textAlign: .center)
                        .frame(width: 100)
                        .padding(.top, 10)
                }
                else {
                    Text("\(fees)")
                }
                Text(" BTC")
            }
            Button(action: {
                withAnimation {
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
            ConfigFees(showConfigFees: self.$showConfigFees, fees: self.$fees, priority: self.$feesPriority)
        }
    }
}
