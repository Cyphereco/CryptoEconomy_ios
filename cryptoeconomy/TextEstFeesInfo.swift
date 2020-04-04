//
//  TextEstFeesInfo.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/3/30.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct TextEstFeesInfo: View {
    @Binding var currencySelection: Int
    @Binding var fees: Double
    @EnvironmentObject var appConfig: AppConfig
    
    let estimatd_fees = NSLocalizedString("estimated_fees", comment:"")
    let included = NSLocalizedString("included", comment:"")
    let excluded = NSLocalizedString("excluded", comment:"")

    var body: some View {
        VStack(alignment: .trailing) {
            HStack {
                Spacer()
                Text("\(estimatd_fees): (\(self.appConfig.getFeesPriority().label) - \(self.appConfig.feesIncluded ? included : excluded))")
                    .font(.footnote).fontWeight(.bold)
            }
            HStack {
                VStack(alignment: .trailing) {
                    Text("\(self.appConfig.fees) /")
                    Text("BTC").font(.footnote).padding(.trailing, 10)
                }
                VStack(alignment: .trailing) {
                    Text("\(AppTools.btcToFiat(btc: self.fees, currencySelection: self.currencySelection))")
                    Text("\(self.appConfig.getLocalCurrency().label)")
                        .font(.footnote)
                }
            }
        }
    }
}

struct TextEstFeesInfo_Previews: PreviewProvider {
    static var previews: some View {
        TextEstFeesInfo(currencySelection: .constant(4), fees: .constant(0.00001)).environmentObject(AppConfig())
    }
}
