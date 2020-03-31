//
//  TextFieldPayAmount.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/3/30.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct TextFieldPayAmount: View {
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Amount")
            }
            HStack {
                Button(action: {}){Image("clear")}
                    .padding(.top, -36.0)
                VStack {
                    TextFieldWithBottomLine(hint: "0.0", textContent: "0.0", textAlign: .trailing)
                    HStack {
                        Spacer()
                        Text("BTC")
                    }
                }
                Text(" = ")
                VStack {
                    TextFieldWithBottomLine(hint: "0.0", textContent: "0.0", textAlign: .trailing)
                    HStack {
                        Spacer()
                        Text("USD")
                    }
                }
                .padding(.leading, 4.0)
            }
            HStack {
                Spacer()
                
            }
        }
    }
}

struct TextFieldPayAmount_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldPayAmount()
    }
}
