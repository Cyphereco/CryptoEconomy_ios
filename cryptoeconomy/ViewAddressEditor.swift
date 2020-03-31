//
//  ViewAddressEditor.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/3/30.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct ViewAddressEditor: View {
    var body: some View {
        NavigationView {
            VStack {
                TextFieldWithBottomLine(hint: "Alias", textAlign: .leading)
                TextFieldBtcAddress()
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
                            .background(Color.init(red: 0.5, green: 0.75, blue: 1))
                        .cornerRadius(24)
                        .foregroundColor(.black)
                    }
                }.padding(.top, 20.0)
            }.padding(.horizontal, 20.0)
            .navigationBarTitle(Text("Address Editor"), displayMode: .inline)        }
    }
}

struct ViewAddressEditor_Previews: PreviewProvider {
    static var previews: some View {
        ViewAddressEditor()
    }
}
