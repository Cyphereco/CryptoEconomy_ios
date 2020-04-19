//
//  AppConfig.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/4/1.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI
import Foundation

class ExchangeRates {
    var cny: Double
    var eur: Double
    var jpy: Double
    var twd: Double
    var usd: Double
    
    init() {
        self.cny = 0
        self.eur = 0
        self.jpy = 0
        self.twd = 0
        self.usd = 0
    }
    
    init(cny: Double, eur: Double, jpy: Double, twd: Double, usd: Double) {
        self.cny = cny
        self.eur = eur
        self.jpy = jpy
        self.twd = twd
        self.usd = usd
    }
    
    func copy(exchangeRates: ExchangeRates) {
        self.cny = exchangeRates.cny
        self.eur = exchangeRates.eur
        self.jpy = exchangeRates.jpy
        self.twd = exchangeRates.twd
        self.usd = exchangeRates.usd
    }
    
    func toString() -> String {
        return "[cny: \(cny), eur: \(eur), jpy: \(jpy), twd: \(twd), usd: \(usd)]"
    }
}

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
            return AppStrings.custom
        case .LOW:
            return AppStrings.low
        case .MID:
            return AppStrings.mid
        default:
            return AppStrings.high
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
enum Interacts: CaseIterable{
    case none
    case menuPay
    case menuOpenTurnKey
    case configLocalCurrency
    case configFees
}

class AppConfig: ObservableObject {
    static let version = "1.0"
    
    @State static var exchangeRates = ExchangeRates()
    
    // fake fees for demo/test, should be updated with online fees
    var priorityFees = [0.000008, 0.00001, 0.00002]
    
    private var editLock = false

    // default values
    @Published var currencySelection: Int = UserDefaults.standard.integer(forKey: "LocalCurrency") { didSet { setLocalCurrency(selection: currencySelection) } }
    @Published var feesSelection: Double = UserDefaults.standard.double(forKey: "FeesPriority") { didSet {
            setFeesPriority(selection: feesSelection)
        } }
    @Published var fees: Double = UserDefaults.standard.double(forKey: "Fees") { didSet {
            UserDefaults.standard.set(fees, forKey: "Fees")
        } }
    @Published var strFees: String = "\(AppTools.btcToFormattedString(UserDefaults.standard.double(forKey: "Fees")))" { didSet {
        if let value = Double(strFees) {
            fees = value
        }
        else {
            strFees = "0.00001"
            fees = 0.00001
        }
    } }
    @Published var feesIncluded: Bool = UserDefaults.standard.bool(forKey: "FeesIncluded") { didSet { setFeesIncluded(included: feesIncluded) } }
    @Published var useFixedAddress: Bool = UserDefaults.standard.bool(forKey: "UseFixedAddress") { didSet {
            setUseFixedAddress(use: useFixedAddress)
            setFixedAddress(addr: useFixedAddress ? payeeAddr : "")
        } }
    @Published var useAllFunds: Bool = false
    @Published var authByPin: Bool = false
    @Published var payee: String = ""
    @Published var payer: String = ""
    @Published var amountSend: String = "" { didSet {
            if let amount = Double(amountSend) {
                if !editLock {
                    editLock = true
                    self.amountSendFiat = amount > 0 ? "\(AppTools.fiatToFormattedString(AppTools.btcToFiat(amount, currencySelection: self.currencySelection)))" : "0"
                }
                else {
                    editLock = false
                }
            }
            else {
                amountSend = "0"
            }
        } }
    @Published var amountRecv: String = ""
    @Published var amountSendFiat: String = "" { didSet {
            if let amount = Double(amountSendFiat) {
                    if !editLock {
                        editLock = true
                        self.amountSend = amount > 0 ? "\(AppTools.btcToFormattedString(AppTools.fiatToBtc(amount, currencySelection: self.currencySelection)))" : "0"
                    }
                    else {
                        editLock = false
                }
            }
            else {
                amountSendFiat = "0"
            }
        } }
    @Published var pageSelected: Int = 0
    @Published var interacts: Interacts = .none
    @Published var payeeAddr: String = UserDefaults.standard.string(forKey: "FixedAddress") ?? ""
    @Published var requestHint: String = AppStrings.readGeneralInformation
    @Published var requestCommand: String = ""
    
    init() {
        UserDefaults.standard.register(defaults: ["LocalCurrency": 5])
        UserDefaults.standard.register(defaults: ["FeesPriority": 1.0])
        UserDefaults.standard.register(defaults: ["FeesIncluded": false])
        UserDefaults.standard.register(defaults: ["Fees": 0.00001])
        UserDefaults.standard.register(defaults: ["UseFixedAddress": false])
        UserDefaults.standard.register(defaults: ["FixedAddress": ""])
        
        updateExchangeRates()
    }
    
    @objc func updateExchangeRates() {
        _ = BlockChainInfoService.updateBtcExchangeRates().done({ exchangeRates in
            AppConfig.exchangeRates.copy(exchangeRates: exchangeRates)
            print(AppConfig.exchangeRates.toString())

            if AppConfig.exchangeRates.usd > 0 {
                self.strFees = "\(AppTools.btcToFormattedString(self.fees))"
                _ = Timer.scheduledTimer(timeInterval: 300.0, target: self, selector: #selector(self.updateExchangeRates), userInfo: nil, repeats: true)
            }
            else {
                Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { timer in
                    if AppConfig.exchangeRates.usd > 0 {
                        timer.invalidate()
                    }
                    else {
                        self.updateExchangeRates()
                    }
                }
            }
        })
    }
    
    func setLocalCurrency(selection: Int) -> Void {
        UserDefaults.standard.set(selection, forKey: "LocalCurrency")
    }
    
    func getLocalCurrency() -> FiatCurrency {
        return FiatCurrency.allCases[currencySelection]
    }
    
    func setFeesPriority(selection: Double) {
        UserDefaults.standard.set(selection, forKey: "FeesPriority")
        if (getFeesPriority() != FeesPriority.CUSTOM) {
            fees = priorityFees[getFeesPriority().ordinal - 1]
            strFees = "\(AppTools.btcToFormattedString(fees))"
        }
    }
    
    func getFeesPriority() -> FeesPriority {
        if (feesSelection < FeesPriority.LOW.sliderValue) {
            return .CUSTOM
        }
        else if (feesSelection < FeesPriority.MID.sliderValue) {
            return .LOW
        }
        else if (feesSelection < FeesPriority.HIGH.sliderValue) {
            return .MID
        }
        else {
            return .HIGH
        }
    }
       
    func setFeesIncluded(included: Bool) {
        UserDefaults.standard.set(included, forKey: "FeesIncluded")
    }
    
    func setUseFixedAddress(use: Bool) {
        UserDefaults.standard.set(use, forKey: "UseFixedAddress")
    }
    
    func setFixedAddress(addr: String) {
        UserDefaults.standard.set(addr, forKey: "FixedAddress")
    }
    
    static let accentColorLight: Color = .blue
    static let accentColorDark: Color = .orange
    static let colorScaleLight: Double = 224/255
    static let colorScaleDark: Double = 32/255
    
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
