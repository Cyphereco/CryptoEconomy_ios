//
//  AppTools.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/4/3.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import Foundation

struct AppTools {
    static func fiatToFormattedString(_ fiat: Double) -> String {
        return fiat > 1000 ? (fiat > 1000000 ? String(format: "%.0f", fiat) : String(format: "%.2f", fiat)) : String(format: "%.3f", fiat)
    }
    
    static func btcToFormattedString(_ btc: Double) -> String {
        return btc > 10 ? (btc > 100 ? String(format: "%.2f", btc) : String(format: "%.4f", btc)) : String(format: "%.8f", btc)
    }
    
    static func getExchangeRate(currency: Int) -> Double {
        switch currency {
            case FiatCurrency.CNY.ordinal:
                return AppConfig.exchageRates.cny
            case FiatCurrency.EUR.ordinal:
                return AppConfig.exchageRates.eur
            case FiatCurrency.JPY.ordinal:
                return AppConfig.exchageRates.jpy
            case FiatCurrency.TWD.ordinal:
                return AppConfig.exchageRates.twd
            default:
                return AppConfig.exchageRates.usd
        }
    }
    
    static func btcToFiat(_ btc: Double, currencySelection: Int) -> Double {
        return btc * getExchangeRate(currency: currencySelection)
    }

    static func fiatToBtc(_ fiat: Double, currencySelection: Int) -> Double {
        return fiat / getExchangeRate(currency: currencySelection)
    }

    static func calcConfirmations(_ blockHeight: Int64) -> Int {
//        return Int(getCurrentBlockHeight() - blockHeight)
        return Int(blockHeight)
    }
    
    static func timeToStringDate(_ time: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: time)
    }
    
    static func timeToStringTime(_ time: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: time)
    }
}
