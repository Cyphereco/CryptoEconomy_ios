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
    @State private var name = ""
    @Binding var address: String
    @ObservedObject var otkNpi = OtkNfcProtocolInterface()
    var pasteboard = UIPasteboard.general

    var body: some View {
        VStack {
            HStack(alignment: .bottom) {
                TextFieldWithBottomLine(hint: "recipient_address",
                                        textContent: $address,
                                        textAlign: .leading,
                                        readOnly: true)
                Button(action: {
                    self.address = ""
                }){Image("clear")}
            }
            HStack {
                Spacer()
                Button(action: {
                    // validate address before pasting
                    self.address = self.pasteboard.string ?? ""
                }){
                    Image("paste")}
                Button(action: {
                    self.otkNpi.beginScanning(completion: {
                        if !self.updateAddress(addr: self.otkNpi.otkData.btcAddress) {
                            Logger.shared.warning("Invalide BTC address")
                        }
                    })
                }){Image("read_nfc")}
                    .padding(.horizontal, 10.0)
                    .padding(.trailing, 4.0)
                Button(action: {
                    self.isShowingScanner = true
                }){Image("scan_qrcode")}
                .sheet(isPresented: self.$isShowingScanner) {
                    CodeScannerView(codeTypes: [.qr], simulatedData: "Some simulated data", completion: self.handleScan)
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
