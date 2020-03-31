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
    var textAlign: TextAlignment = .center
    var body: some View {
        VStack {
            TextField(hint, text: $textContent).multilineTextAlignment(textAlign)
            Divider()
        }
    }
}

struct TextFieldWithBottomLine_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldWithBottomLine()
    }
}
