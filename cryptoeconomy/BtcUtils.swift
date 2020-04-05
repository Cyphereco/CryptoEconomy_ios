//
//  BtcUtils.swift
//  cryptoeconomy
//
//  Created by JJ Cherng on 2020/4/2.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import Foundation

class BtcUtils {
    /*
     * Convert satoshi to BTC
     */
    static func satoshiToBtc(satoshi: Int64) -> Double {
        return (Double(satoshi) / 100000000.0)
    }
    
    /*
     * Convert BTC to satoshi
     */
    static func BtcToSatoshi(btc: Double) -> Int64 {
        return Int64(truncating: NSNumber(value: (btc * 100000000.0)))
    }
}
