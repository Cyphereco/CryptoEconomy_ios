//
//  TextFieldWithBottmLine.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/3/30.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct TextFieldWithBottomLine: View {
    var hint: String = ""
    @Binding var textContent: String
    var textAlign: TextAlignment = .center
    @State var onEditingChanged: (_: String)->Void = {_ in }

    var body: some View {
        VStack {
            TextField(NSLocalizedString(hint, comment: ""), text: $textContent, onEditingChanged: {_ in
                self.onEditingChanged(self.textContent)
            }).multilineTextAlignment(textAlign).padding(.vertical, -10)
            Divider()
        }
    }
}

struct TextFieldWithBottomLine_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldWithBottomLine(hint: "Type something", textContent: .constant(""))
    }
}
