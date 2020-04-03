//
//  AppConfig.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/4/1.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI
import Foundation

enum FeesPriority: CaseIterable {
    case CUSTOM
    case LOW
    case MID
    case HIGH
    
    var sliderValue: Double {
        return Double(self.ordinal)
    }
    
    var ordinal: Int {
        switch self {
        case .CUSTOM:
            return 0
        case .LOW:
            return 1
        case .MID:
            return 2
        default:
            return 3
        }
    }

    var label: String {
        switch self {
        case .CUSTOM:
            return "Custom"
        case .LOW:
            return "Low"
        case .HIGH:
            return "High"
        default:
            return "Mid"
        }
    }
}

enum FiatCurrency: CaseIterable{
    case CNY
    case EUR
    case JPY
    case TWD
    case USD
    
    var ordinal: Int {
        switch self {
        case .CNY:
            return 0
        case .EUR:
            return 1
        case .JPY:
            return 2
        case .TWD:
            return 3
        default:
            return 4
        }
    }
    
    var label: String {
        switch self {
        case .CNY:
            return "CNY"
        case .EUR:
            return "EUR"
        case .JPY:
            return "JPY"
        case .TWD:
            return "TWD"
        default:
            return "USD"
        }
    }
}

class AppConfig: ObservableObject {
    // fake fees for demo/test, should be updated with online fees
    var priorityFees = [0.000008, 0.00001, 0.00002]

    // fake rates for demo/test, should be updated with online rates
    static var fiatRates = [48352.46, 6301.76, 736225.0, 206318.37, 6825.40]

    // default values
    @Published var localCurrency = FiatCurrency.USD.ordinal
    @Published var feePriority = FeesPriority.MID.sliderValue
    @Published var fees = 0.00001
    
    func getFeesPriority() -> FeesPriority {
        if (feePriority < FeesPriority.LOW.sliderValue) {
            return .CUSTOM
        }
        else if (feePriority < FeesPriority.MID.sliderValue) {
            return .LOW
        }
        else if (feePriority < FeesPriority.HIGH.sliderValue) {
            return .MID
        }
        else {
            return .HIGH
        }
    }
    
    func getFees() -> Double {
        if (getFeesPriority() == FeesPriority.CUSTOM) {
            return fees
        }
        else {
            fees = priorityFees[getFeesPriority().ordinal - 1]
        }
        return fees
    }
    
    static let accentColorLight: Color = .blue
    static let accentColorDark: Color = .orange
    static let colorScaleLight: Double = 240/255
    static let colorScaleDark: Double = 32/255
    static let fiatCurrencies = ["CNY", "EUR", "JPY", "TWD", "USD"]
    
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
