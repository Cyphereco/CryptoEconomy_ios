//
//  TextFieldBtcAddress.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/3/30.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI
import CodeScanner

struct TextFieldBtcAddress: View {
    @Binding var address: String
    @ObservedObject var otkNpi = OtkNfcProtocolInterface()
    @State private var isShowingScanner = false

    private let pasteboard = UIPasteboard.general

    var body: some View {
        VStack {
            HStack(alignment: .bottom) {
                if self.address.count == 0 {
                    TextField(AppStrings.btcAddress, text: .constant(""))
                    .frame(minHeight: 44)
                    .lineLimit(5)
                    .multilineTextAlignment(.leading)
                    .addUnderline()
                    .padding(.bottom, -10)
                }
                else {
                    Text(self.address)
                    .frame(minHeight: 44)
                    .lineLimit(5)
                    .multilineTextAlignment(.leading)
                    .addUnderline()
                    .padding(.bottom, -10)
                }
                Button(action: {
                    self.address = ""
                }){Image("clear")}
            }
            HStack {
                Spacer()
                Button(action: {
                    if let pasteString = self.pasteboard.string {
                        if !self.updateAddress(addr: pasteString) {
                            Logger.shared.warning("Invalide BTC address")
                        }
                    }
                }){Image("paste")}

                Button(action: {
                    self.otkNpi.beginScanning(onCompleted: {
                        if !self.updateAddress(addr: self.otkNpi.otkData.btcAddress) {
                            Logger.shared.warning("Invalide BTC address")
                        }
                    }, onCanceled: {})
                }){Image("read_nfc")}
                    .padding(.horizontal, 10.0)
                    .padding(.trailing, 4.0)
                Button(action: {
                    self.isShowingScanner = true
                }){Image("scan_qrcode")}
                .sheet(isPresented: self.$isShowingScanner) {
                    ZStack {
                        CodeScannerView(codeTypes: [.qr], simulatedData: "Some simulated data", completion: self.handleScan)

                        ZStack {
                            GeometryReader { _ in
                                EmptyView()
                            }
                            .background(Color.black)

                            GeometryReader { _ in
                                EmptyView()
                            }
                            .frame(width: 250, height: 250)
                            .background(Color.white.opacity(0.2))
                        }
                        .opacity(0.4)
                        
                        VStack {
                            VStack {
                                Image(systemName: "minus").imageScale(.large)
                                HStack {
                                    Spacer()
                                    Text(AppStrings.scanningQrCode).font(.headline).padding([.leading, .trailing, .bottom])
                                    Spacer()
                                }
                            }.background(Color.gray)
                            Spacer()
                            Button(action: {
                                self.isShowingScanner = false
                            }){
                                Image(systemName: "multiply.circle.fill")
                                .font(.largeTitle)
                                .padding()
                            }
                        }
                    }
                    .setCustomDecoration(.accentColor)
                }
                Spacer().fixedSize().frame(width: 40, height: 0, alignment: .leading)
            }
        }
    }

    private func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.isShowingScanner = false
        switch result {
            case .success(let data):
                if !self.updateAddress(addr: data) {
                    Logger.shared.warning("Invalide BTC address")
                }
            case .failure(let error):
                Logger.shared.warning("Scanning failed \(error)")
        }
    }

    private func updateAddress(addr: String) -> Bool {
        if BtcUtils.isValidateAddress(addressStr: addr) {
            self.address = BtcUtils.removePrefixFromAddress(addressStr: addr)
            return true
        }
        return false
    }
}

struct TextFieldBtcAddress_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldBtcAddress(address: .constant(""))
    }
}
