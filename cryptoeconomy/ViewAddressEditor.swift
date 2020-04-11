//
//  ViewAddressEditor.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/3/30.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct ViewAddressEditor: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @State var alias: String
    @State var address = ""

    var body: some View {
        NavigationView {
            VStack {
                TextFieldWithBottomLine(hint: "alias", textContent: $alias, textAlign: .leading, readOnly: false).padding()
                TextFieldBtcAddress(address: $address).padding()
                HStack {
                    Spacer()
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack(alignment: .center){
                            Text("cancel")
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                        }
                        .frame(minWidth: 80)
                        .padding(12)
                        .cornerRadius(24)
                    }
                    Button(action: {
                        // address duiplication check and save to db
                    }) {
                        HStack(alignment: .center){
                            Text("save")
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                        }
                        .frame(minWidth: 80)
                        .padding(12)
                        .background(AppConfig.getAccentColor(colorScheme: self.colorScheme))
                        .cornerRadius(24)
                        .foregroundColor(.white)
                    }
                }.padding(.top, 20.0)
            }.padding(.horizontal, 20.0)
            .navigationBarTitle(Text("edit_address"), displayMode: .inline)
        }
    }
}

struct ViewAddressEditor_Previews: PreviewProvider {
    static var previews: some View {
        ViewAddressEditor(alias: "")
    }
}
