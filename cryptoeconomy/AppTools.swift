//
//  AppTools.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/4/3.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import Foundation

struct AppTools {
    static func btcToFiat(btc: Double, currencySelection: Int) -> Double {
        return btc * AppConfig.fiatRates[currencySelection]
    }

    static func fiatToBtc(fiat: Double, currencySelection: Int) -> Double {
        return fiat / AppConfig.fiatRates[currencySelection]
    }

    static func calcConfirmations(blockHeight: Int64) -> Int {
//        return Int(getCurrentBlockHeight() - blockHeight)
        return Int(blockHeight)
    }
    
    static func timeToStringDate(time: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: time)
    }
    
    static func timeToStringTime(time: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: time)
    }
}
