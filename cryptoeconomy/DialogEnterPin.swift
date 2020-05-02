//
//  DialogEnterPin.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/4/23.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct DialogEnterPin: View {
    let showDialog: Bool
    let closeDialog: ()->Void

    @State var pin = ""
    var handler: (String) -> Void
    @State var keyboardActive = false

    var body: some View {
        ZStack {
            GeometryReader { _ in
                EmptyView()
            }
            .background(Color.gray.opacity(0.8))
            .opacity(self.showDialog ? 0.5 : 0.0)
            .animation(.easeInOut)
            .onTapGesture {
                if self.keyboardActive {
                    UIApplication.shared.endEditing()
                }
                self.closeDialog()
                self.pin = ""
            }

            GeometryReader { geometry in
                VStack {
                    Spacer()
                    PasscodeField(maxDigits: 8, label: AppStrings.authByPin, pin: self.$pin, showPin: false, isDisabled: false, handler: { pin, _  in
                        self.closeDialog()
                        self.handler(pin)
                        self.pin = ""
                    })
                    .frame(width: 320)
                    .disabled(!self.showDialog)
                    .opacity(self.showDialog ? 1 : 0)
                    .animation(.easeInOut)
                    Spacer()
                }
           }
        }.isKeyboardActive(keyboardActive: self.$keyboardActive)
    }
}

struct DialogEnterPin_Previews: PreviewProvider {
    static var previews: some View {
        DialogEnterPin(showDialog: true, closeDialog: {}, pin: "", handler: {pin in })
    }
}
