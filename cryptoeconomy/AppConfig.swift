//
//  AppConfig.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/4/1.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI
import Foundation

class AppConfig {
    var localCurrency = 4
    var feePriority = 1.0
    var fees = 0.000008
    
    static let accentColorLight: Color = .blue
    static let accentColorDark: Color = .orange
    static let colorScaleLight: Double = 240/255
    static let colorScaleDark: Double = 32/255
    static let fiatCurrencies = ["CNY", "EUR", "JPY", "TWD", "USD"]
    
    static var fiatRates = [48352.46, 6301.76, 736225.0, 206318.37, 6825.40]

    static func getAccentColor(colorScheme: ColorScheme) -> Color {
        return colorScheme == .dark ? accentColorDark : accentColorLight
    }
    
    static func getMenuBackgroundColor(colorScheme: ColorScheme) -> Color {
        if (colorScheme == .dark) {
            return Color(red: colorScaleDark, green: colorScaleDark, blue: colorScaleDark)
        }
        return Color(red: colorScaleLight, green: colorScaleLight, blue: colorScaleLight)
    }
}
