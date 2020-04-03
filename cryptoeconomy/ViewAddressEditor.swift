//
//  ViewAddressEditor.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/3/30.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct ViewAddressEditor: View {
    @Environment(\.colorScheme) var colorScheme
    @State var alias: String

    var body: some View {
        NavigationView {
            VStack {
                TextFieldWithBottomLine(hint: "Alias", textContent: $alias, textAlign: .leading).padding()
                TextFieldBtcAddress(address: "").padding()
                HStack {
                    Spacer()
                    Button(action: {
                        
                    }) {
                        HStack{
                            Text("   Save   ")
                                .font(.system(size: 20))
                            .fontWeight(.bold)
                        }
                        .padding(12)
                        .background(AppConfig.getAccentColor(colorScheme: self.colorScheme))
                        .cornerRadius(24)
                        .foregroundColor(.white)
                    }
                }.padding(.top, 20.0)
            }.padding(.horizontal, 20.0)
            .navigationBarTitle(Text("Edit Address"), displayMode: .inline)        }
    }
}

struct ViewAddressEditor_Previews: PreviewProvider {
    static var previews: some View {
        ViewAddressEditor(alias: "")
    }
}
