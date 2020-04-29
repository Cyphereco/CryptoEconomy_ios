//
//  TextFieldPayAmount.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/3/30.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct TextFieldPayAmount: View {
    @EnvironmentObject var appController: AppController

    var body: some View {
        VStack(alignment: .trailing) {
            Text("amount").fontWeight(.bold)
            HStack(alignment: .center) {
                Button(action: {
                    self.appController.amountSend = ""
                    self.appController.amountSendFiat = ""
                }){Image("clear")}
                    .padding(.top, -36.0)
                VStack(alignment: .trailing) {
                    TextField("0.0", text: self.$appController.amountSend)
                        .selectAllTextOnFocus()
                        .multilineTextAlignment(.trailing)
                        .addUnderline()
                        .font(.custom("", size: 24))
                    Text("BTC")
                }
                Text(" = ").padding(.top, -30)
                VStack(alignment: .trailing) {
                    TextField("0.0", text: self.$appController.amountSendFiat)
                    .selectAllTextOnFocus()
                    .multilineTextAlignment(.trailing)
                    .addUnderline()
                    .font(.custom("", size: 24))
                    Text(self.appController.getLocalCurrency().label)
                }
                .padding(.leading, 4.0)
            }.keyboardType(.decimalPad)
        }
    }
}

struct TextFieldPayAmount_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldPayAmount().environmentObject(AppController())
    }
}
