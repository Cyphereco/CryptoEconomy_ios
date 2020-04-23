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
    private let textFieldObserver = TextFieldObserver()

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
                        .multilineTextAlignment(.trailing)
                        .addUnderline()
                        .font(.custom("", size: 24))
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
                    TextField("0.0", text: self.$appController.amountSendFiat)
                    .multilineTextAlignment(.trailing)
                    .addUnderline()
                    .font(.custom("", size: 24))
                    .introspectTextField { textField in
                        textField.addTarget(
                            self.textFieldObserver,
                            action: #selector(TextFieldObserver.textFieldDidBeginEditing),
                            for: .editingDidBegin
                        )}
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
