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
    @State var textContent: String = ""
    @State var onEditingChanged: (_: String)->Void = {_ in }
    var textAlign: TextAlignment = .center
    var body: some View {
        VStack {
            TextField(hint, text: $textContent, onEditingChanged: {_ in
                self.onEditingChanged(self.textContent)
            }).multilineTextAlignment(textAlign).padding(-10)
            Divider()
        }
    }
}

struct TextFieldWithBottomLine_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldWithBottomLine()
    }
}
