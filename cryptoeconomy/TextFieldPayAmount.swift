//
//  TextFieldPayAmount.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/3/30.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct TextFieldPayAmount: View {
    @Binding var localCurrency: Int
    @State var strAmountBtc: String
    @State var strAmountFiat: String
    @EnvironmentObject var appConfig: AppConfig

    var body: some View {
        VStack(alignment: .trailing) {
            Text("Amount").fontWeight(.bold)
            HStack(alignment: .center) {
                Button(action: {}){Image("clear")}
                    .padding(.top, -36.0)
                VStack(alignment: .trailing) {
                    TextFieldWithBottomLine(hint: "0.0", textContent: $strAmountBtc, textAlign: .trailing)
                    Text("BTC")
                }
                Text(" = ").padding(.top, -30)
                VStack(alignment: .trailing) {
                    TextFieldWithBottomLine(hint: "0.0", textContent: $strAmountFiat, textAlign: .trailing)
                    Text(self.appConfig.getLocalCurrency().label)
                }
                .padding(.leading, 4.0)
            }
        }
    }
}

struct TextFieldPayAmount_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldPayAmount(localCurrency: .constant(FiatCurrency.USD.ordinal), strAmountBtc: "0.0", strAmountFiat: "0.0").environmentObject(AppConfig())
    }
}
