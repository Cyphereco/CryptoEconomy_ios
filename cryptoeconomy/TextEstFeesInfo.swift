//
//  TextEstFeesInfo.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/3/30.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct TextEstFeesInfo: View {
    @Binding var localCurrency: Int
    @Binding var fees: Double
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Estimatd Fees: (Low - Included)")
                    .font(.footnote)
            }
            HStack {
                Spacer()
                Text("\(self.fees) / \(AppTools.btcToFiat(btc: self.fees, localCurrency: self.localCurrency))")
                    .font(.footnote)
            }
            HStack {
                Spacer()
                Text("BTC / \(AppConfig.fiatCurrencies[self.localCurrency])")
                    .font(.footnote)
            }
        }
    }
}

struct TextEstFeesInfo_Previews: PreviewProvider {
    static var previews: some View {
        TextEstFeesInfo(localCurrency: .constant(4), fees: .constant(0.00001))
    }
}
