//
//  AppConfig.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/4/1.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI
import Foundation
import Combine
import Network

class BestFees {
    var low: Int
    var mid: Int
    var high: Int
    
    init() {
        self.low = 0
        self.mid = 0
        self.high = 0
    }
    
    init(low: Int, mid: Int, high: Int) {
        self.low = low
        self.mid = mid
        self.high = high
    }
    
    func copy(bestFees: BestFees) {
        self.low = bestFees.low
        self.mid = bestFees.mid
        self.high = bestFees.high
        
        if self.mid == self.high || self.mid == self.low {
            self.mid = Int((self.low + self.high) / 2)
        }
    }
    
    func toString() -> String {
        return "[low: \(low), mid: \(mid), high: \(high)]"
    }
}

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

    init(exchangeRates: String) {
        self.cny = 0
        self.eur = 0
        self.jpy = 0
        self.twd = 0
        self.usd = 0

        var str = exchangeRates.replacingOccurrences(of: "[", with: "")
        str = str.replacingOccurrences(of: "]", with: "")
        str = str.replacingOccurrences(of: " ", with: "")
        let rates = str.components(separatedBy: ",")

        for rate in rates {
            let val = Double(rate.components(separatedBy: ":")[1]) ?? 0
            if rate.contains("cny") {
                self.cny = val
            }
            if rate.contains("eur") {
                self.eur = val
            }
            if rate.contains("jpy") {
                self.jpy = val
            }
            if rate.contains("twd") {
                self.twd = val
            }
            if rate.contains("usd") {
                self.usd = val
            }
        }
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

class AppController: ObservableObject {
    let didChange = PassthroughSubject<AppController, Never>()
    let monitor = NWPathMonitor()

    static var shared = AppController()
    
    static let VERSION = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    static let BUILD_NUMBER = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
    
    static let REQUEST_TIMEOUT = 30.0         // seconds
    static let ESTIMATED_BLOCK_SIZE = 200   // bytes
    static let accentColorLight: Color = .blue
    static let accentColorDark: Color = .orange

    static var otkNpi = OtkNfcProtocolInterface()
    
    @State static var exchangeRates = ExchangeRates()
    @State static var bestFees = BestFees()

    private var editingAmountSend = false
    private var editingAmountSendFiat = false
    
    @Published var internetConnected = false { didSet {
        self.didChange.send(self)
    } }

    // default values
    @Published var currencySelection: Int = UserDefaults.standard.integer(forKey: "LocalCurrency") { didSet {
            setLocalCurrency(selection: currencySelection)
            self.amountSend = "\(self.amountSend)"
            self.didChange.send(self)
        } }
    @Published var feesSelection: Double = UserDefaults.standard.double(forKey: "FeesPriority") { didSet {
            setFeesPriority(selection: feesSelection)
            self.didChange.send(self)
        } }
    @Published var fees: Double = UserDefaults.standard.double(forKey: "Fees") { didSet {
            UserDefaults.standard.set(fees, forKey: "Fees")
            self.didChange.send(self)
        } }
    @Published var strFees: String = "\(AppTools.btcToFormattedString(UserDefaults.standard.double(forKey: "Fees")))" { didSet {
        if let value = Double(strFees) {
            fees = value
        }
        else {
            strFees = "0.00001"
            fees = 0.00001
        }
        self.didChange.send(self)
    } }
    @Published var feesIncluded: Bool = UserDefaults.standard.bool(forKey: "FeesIncluded") { didSet {
        setFeesIncluded(included: feesIncluded)
        self.didChange.send(self)
    } }
    @Published var useFixedAddress: Bool = UserDefaults.standard.bool(forKey: "UseFixedAddress") { didSet {
        setUseFixedAddress(use: useFixedAddress)
        setFixedAddress(addr: useFixedAddress ? payeeAddr : "")
        self.didChange.send(self)
    } }
    @Published var useAllFunds: Bool = false { didSet {
        self.amountSend = "0"
        self.didChange.send(self)
    }}
    @Published var authByPin: Bool = false { didSet {
        self.didChange.send(self)
    }}
    @Published var payee: String = "" { didSet {
        self.didChange.send(self)
    }}
    @Published var payer: String = "" { didSet {
        self.didChange.send(self)
    }}
    @Published var balance: Double = 0.0 { didSet {
        self.didChange.send(self)
    }}
    @Published var amountSend: String = "" { didSet {
        if !self.editingAmountSendFiat {
            self.editingAmountSend = true
            let amount = Double(amountSend) ?? 0.0
            if amount > 0 {
                self.amountSendFiat =  "\(AppTools.fiatToFormattedString(AppTools.btcToFiat(amount, currencySelection: self.currencySelection)))"
            }
            else {
                self.amountSendFiat = ""
            }
            self.editingAmountSend = false
        }
        self.didChange.send(self)
    } }
    @Published var amountRecv: String = "" { didSet {
        self.didChange.send(self)
    }}
    @Published var amountSendFiat: String = "" { didSet {
        if !self.editingAmountSend {
            self.editingAmountSendFiat = true
            let amount = Double(amountSendFiat) ?? 0.0
            if amount > 0 {
                self.amountSend =  "\(AppTools.btcToFormattedString(AppTools.fiatToBtc(amount, currencySelection: self.currencySelection)))"
            }
            else {
                self.amountSend = ""
            }
            self.editingAmountSendFiat = false
        }
        self.didChange.send(self)
    } }
    @Published var pageSelected: Int = 0 { didSet {
        AppController.otkNpi.request = OtkRequest()
        self.amountSend = ""
        self.useAllFunds = false
        self.authByPin = false
        self.requestHint = AppStrings.readGeneralInformation
    
        if !self.useFixedAddress {
            self.payeeAddr = ""
        }
        self.didChange.send(self)
    }}
    @Published var interacts: Interacts = .none { didSet {
        self.didChange.send(self)
    }}
    @Published var payeeAddr: String = UserDefaults.standard.string(forKey: "FixedAddress") ?? "" { didSet {
        self.didChange.send(self)
    }}
    @Published var requestHint: String = AppStrings.readGeneralInformation { didSet {
        self.didChange.send(self)
    }}
    @Published var requestId: UUID = UUID() { didSet {
        if AppController.otkNpi.request.command == .invalid {
            self.requestHint = AppStrings.readGeneralInformation
            self.authByPin = false
        }
        self.didChange.send(self)
    }}
    @Published var currentBlockHeight: Int64 = -1 { didSet {
        self.didChange.send(self)
    }}

    init() {
        UserDefaults.standard.register(defaults: ["LocalCurrency": 5])
        UserDefaults.standard.register(defaults: ["FeesPriority": 1.0])
        UserDefaults.standard.register(defaults: ["FeesIncluded": false])
        UserDefaults.standard.register(defaults: ["Fees": 0.00001])
        UserDefaults.standard.register(defaults: ["UseFixedAddress": false])
        UserDefaults.standard.register(defaults: ["FixedAddress": ""])
        
        updateBlockHeight()
        updateTxFees()
        updateExchangeRates()
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("Internet connected.")
                self.internetConnected = true
            } else {
                print("Internet connection lost!!")
                self.internetConnected = false
            }
            
            // whether connection is via cellular network
//            print(path.isExpensive)
        }
        
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    
    func calcConfirmations(_ blockHeight: Int64) -> Int {
        return blockHeight > 0 ? Int(self.currentBlockHeight - blockHeight + 1) : -1
    }

    @objc func updateBlockHeight() {
        var nextUpdate = 10.0  // seconds
        self.currentBlockHeight = Int64(UserDefaults.standard.integer(forKey: "LastBlockHeight"))

        _ = BlockChainInfoService.getLatestBlockHeight()
            .done({ height in
                print("Current Blockheight: \(height)")
                
                if height >= 0 {
                    UserDefaults.standard.set(height, forKey: "LastBlockHeight")
                    self.currentBlockHeight = height
                    nextUpdate = 300.0
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + nextUpdate) {
                   self.updateBlockHeight()
                }
            })
            .catch() {err in
                print(err)
                DispatchQueue.main.asyncAfter(deadline: .now() + nextUpdate) {
                   self.updateBlockHeight()
                }
            }
    }

    @objc func updateTxFees() {
        var nextUpdate = 10.0  // seconds

        _ = BlockChainInfoService.updateBestTxFees().done({ bestFees in
            AppController.bestFees.copy(bestFees: bestFees)
            print(AppController.bestFees.toString())

            if AppController.bestFees.high > 0 {
                self.setFeesPriority(selection: self.feesSelection)
                nextUpdate = 300.0
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + nextUpdate) {
               self.updateTxFees()
            }
        })
        .catch(){err in
            print(err)
            DispatchQueue.main.asyncAfter(deadline: .now() + nextUpdate) {
               self.updateTxFees()
            }
        }
    }

    @objc func updateExchangeRates() {
        var nextUpdate = 10.0  // seconds

        _ = WebServices.updateBtcExchangeRates()
        .done({ exchangeRates in
            AppController.exchangeRates.copy(exchangeRates: exchangeRates)
            print(AppController.exchangeRates.toString())

            if AppController.exchangeRates.usd > 0 {
                self.strFees = "\(AppTools.btcToFormattedString(self.fees))"
                nextUpdate = 300.0
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + nextUpdate) {
                       self.updateExchangeRates()
            }
        })
        .catch(){err in
            print(err)
            DispatchQueue.main.asyncAfter(deadline: .now() + nextUpdate) {
                       self.updateExchangeRates()
            }
        }
    }
    
    func cancelOtkRequest(continueAfterStarted: Bool) {
        if !continueAfterStarted || (continueAfterStarted && !AppController.otkNpi.readStarted) {
            AppController.otkNpi.cancelSession()
            AppController.otkNpi = OtkNfcProtocolInterface()
            self.requestHint = AppStrings.readGeneralInformation
            self.authByPin = false
        }
    }
    
    func setLocalCurrency(selection: Int) -> Void {
        UserDefaults.standard.set(selection, forKey: "LocalCurrency")
    }
    
    func getLocalCurrency() -> FiatCurrency {
        return currencySelection < FiatCurrency.allCases.count ? FiatCurrency.allCases[currencySelection] : FiatCurrency.USD
    }
    
    func setFeesPriority(selection: Double) {
        UserDefaults.standard.set(selection, forKey: "FeesPriority")
        switch selection {
            case 1.0:
                self.fees = BtcUtils.satoshiToBtc(satoshi:  Int64(AppController.bestFees.low * AppController.ESTIMATED_BLOCK_SIZE))
            case 2.0:
                self.fees = BtcUtils.satoshiToBtc(satoshi:  Int64(AppController.bestFees.mid * AppController.ESTIMATED_BLOCK_SIZE))
            case 3.0:
                self.fees = BtcUtils.satoshiToBtc(satoshi:  Int64(AppController.bestFees.high * AppController.ESTIMATED_BLOCK_SIZE))
            default:
                self.fees = UserDefaults.standard.double(forKey: "Fees")
        }

        self.strFees = "\(AppTools.btcToFormattedString(fees))"
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
    
    func getEstTime() -> String {
        var estTime = "5~15"
        if self.fees < BtcUtils.satoshiToBtc(satoshi:  Int64(AppController.bestFees.high * AppController.ESTIMATED_BLOCK_SIZE)) {
            estTime = "15~35"
        }
        
        if self.fees < BtcUtils.satoshiToBtc(satoshi:  Int64(AppController.bestFees.mid * AppController.ESTIMATED_BLOCK_SIZE)) {
            estTime = "35~60+"
        }
        
        return estTime
    }
    
    func getAmountSent() -> Double {
        let amount = Double(self.amountSend) ?? 0.0
        
        return self.useAllFunds ? self.balance : self.feesIncluded ? amount : amount + self.fees
    }
       
    func getAmountReceived() -> Double {
        return self.getAmountSent() - self.fees
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

    func getAccentColor(_ colorScheme: ColorScheme) -> Color {
        return colorScheme == .dark ? AppController.accentColorDark : AppController.accentColorLight
    }
}
