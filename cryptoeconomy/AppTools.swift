//
//  AppTools.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/4/3.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import Foundation

struct AppTools {
    static func btcToFiat(btc: Double, localCurrency: Int) -> Double {
        return btc * AppConfig.fiatRates[localCurrency]
    }

    static func fiatToBtc(fiat: Double, localCurrency: Int) -> Double {
        return fiat / AppConfig.fiatRates[localCurrency]
    }
}
