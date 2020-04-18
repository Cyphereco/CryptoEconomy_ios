//
//  TextFieldPayAmount.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/3/30.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct TextFieldPayAmount: View {
    @EnvironmentObject var appConfig: AppConfig
    private let textFieldObserver = TextFieldObserver()

    var body: some View {
        VStack(alignment: .trailing) {
            Text("amount").fontWeight(.bold)
            HStack(alignment: .center) {
                Button(action: {
                    self.appConfig.amountSend = ""
                    self.appConfig.amountSendFiat = ""
                }){Image("clear")}
                    .padding(.top, -36.0)
                VStack(alignment: .trailing) {
                    TextFieldWithBottomLine(hint: "0.0", textContent: self.$appConfig.amountSend, textAlign: .trailing, readOnly: false, onEditingChanged: {_ in
                    })
                    .introspectTextField { textField in
                        textField.addTarget(
                            self.textFieldObserver,
                            action: #selector(TextFieldObserver.textFieldDidBeginEditing),
                            for: .editingDidBegin
                        )}
                    Text("BTC")
                }
                Text(" = ").padding(.top, -30)
                VStack(alignment: .trailing) {
                    TextFieldWithBottomLine(hint: "0.0", textContent: self.$appConfig.amountSendFiat, textAlign: .trailing, readOnly: false, onEditingChanged: {_ in
                    })
                    .introspectTextField { textField in
                        textField.addTarget(
                            self.textFieldObserver,
                            action: #selector(TextFieldObserver.textFieldDidBeginEditing),
                            for: .editingDidBegin
                        )}
                    Text(self.appConfig.getLocalCurrency().label)
                }
                .padding(.leading, 4.0)
            }.keyboardType(.decimalPad)
        }
    }
}

struct TextFieldPayAmount_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldPayAmount().environmentObject(AppConfig())
    }
}
