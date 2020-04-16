//
//  ListItemAddress.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/4/2.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct AddressQRCodeView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var showSheetView: Bool
    @State var alias: String = ""
    @State var address: String = ""
    private let pasteboard = UIPasteboard.general

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Alias:")
                    .padding()
                    .font(.largeTitle)
                Text("\(self.alias)").padding()
                HStack {
                    Text("BTC Address:")
                        .font(.largeTitle)
                    Button(action: {
                        self.pasteboard.string = self.address
                    }) {Image("copy")}
                }.padding()
                Text("\(self.address)").padding()
                QRCodeGenerateView(inputString: "bitcoin:\(self.address)", width: 200, height: 200)
                Spacer()
            }
            .navigationBarTitle(Text("BTC QR Code"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                print("Dismissing sheet view...")
                self.showSheetView = false
            }) {
                Text("Done").bold()
            })
        }
    }
}

struct ListItemAddress: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appConfig: AppConfig
    @ObservedObject var addressListVM: AddressListViewModel

    @State private var showDelAlert: Bool = false
    @State private var showQRCodeSheet: Bool = false
    @State var showAddressEditor = false

    var recordAddress: AddressViewModel

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(self.recordAddress.alias).fontWeight(.bold).lineLimit(1)
                Text(self.recordAddress.address).lineLimit(1).padding(.leading, 20)
            }
            .onTapGesture {
                self.showAddressEditor = true
            }
            .sheet(isPresented: $showAddressEditor) {
                ViewAddressEditor(addressListVM: self.addressListVM, alias: self.recordAddress.alias, address: self.recordAddress.address)}
            Spacer()
            Button(action: {
                self.showDelAlert = true
            }) {Image("delete")}.buttonStyle(BorderlessButtonStyle())
            .alert(isPresented: self.$showDelAlert) {
                return Alert(title: Text("Are you sure to delete it?"),
                    primaryButton: .default(Text("YES"), action: {
                        if CoreDataManager.shared.deleteAddress(
                                addressVM: AddressViewModel(alias: self.recordAddress.alias,
                                                            address: self.recordAddress.address)) {
                            self.addressListVM.fetchAllAddresses()
                        }
                    }),
                    secondaryButton: .default(Text("NO")))
            }

            Button(action: {
                self.showQRCodeSheet = true
            }) {Image("qrcode")}.buttonStyle(BorderlessButtonStyle()).padding(.horizontal, 10).padding(.trailing, 5)
            .sheet(isPresented: self.$showQRCodeSheet) {
                AddressQRCodeView(showSheetView: self.$showQRCodeSheet,
                                  alias: self.recordAddress.alias,
                                  address: self.recordAddress.address)
            }

            Button(action: {
                self.appConfig.payeeAddr = self.recordAddress.address
                self.appConfig.pageSelected = 0
            }){Image("send")}.buttonStyle(BorderlessButtonStyle())
        }.padding(.horizontal, 5)
    }
}

struct ListItemAddress_Previews: PreviewProvider {
    static var previews: some View {
      PreviewWrapper()
    }

    struct PreviewWrapper: View {
        var recordAddress = AddressViewModel(alias: "Maicoin", address: "1QEma6prBJscNqw7s3t8EGFcx3zF7mzWab")
        var body: some View {
            ListItemAddress(addressListVM: AddressListViewModel(), recordAddress: self.recordAddress)
        }
    }
}
