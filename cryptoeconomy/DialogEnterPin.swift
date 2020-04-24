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
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                PasscodeField(maxDigits: 8, label: "Authorization with PIN Code", pin: "", showPin: false, isDisabled: false, handler: { pin, _  in
                    self.handler(pin)
                    self.closeDialog()
                })
                .frame(width: 320)
                .disabled(!self.showDialog)
                .opacity(self.showDialog ? 1 : 0)
                .animation(.easeInOut)
                Spacer()
            }
       }
    }
}

struct DialogEnterPin_Previews: PreviewProvider {
    static var previews: some View {
        DialogEnterPin(showDialog: true, closeDialog: {}, pin: "", handler: {pin in })
    }
}
