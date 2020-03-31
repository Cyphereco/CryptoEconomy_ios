//
//  TextEstFeesInfo.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/3/30.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct TextEstFeesInfo: View {
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Estimatd Fees: (Low - Included)")
                    .font(.footnote)
            }
            HStack {
                Spacer()
                Text("0.0000 1000 / 0.05")
                    .font(.footnote)
            }
            HStack {
                Spacer()
                Text("BTC / USD")
                    .font(.footnote)
            }
        }
    }
}

struct TextEstFeesInfo_Previews: PreviewProvider {
    static var previews: some View {
        TextEstFeesInfo()
    }
}
