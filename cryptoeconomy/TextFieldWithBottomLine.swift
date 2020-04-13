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
    var readOnly: Bool
    @State var onEditingChanged: (_: String)->Void = {_ in }

    var body: some View {
        VStack {
            if (readOnly && textContent.count > 0) {
                Text(textContent)
                    .multilineTextAlignment(textAlign)
                    .lineLimit(3)
                    .padding(.vertical, -10)
            }
            else {
                TextField(NSLocalizedString(hint, comment: ""), text: $textContent, onEditingChanged: {_ in
                    self.onEditingChanged(self.textContent)
                })
                .multilineTextAlignment(textAlign)
                .padding(.vertical, -10)
                .disabled(self.readOnly)
            }
            Divider()
        }
    }
}

struct TextFieldWithBottomLine_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldWithBottomLine(hint: "Type something", textContent: .constant("123"), textAlign: .leading, readOnly: true, onEditingChanged: {text in})
    }
}
