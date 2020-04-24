//
//  ListItemAddress.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/4/2.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct AddressQRCodeView: View {
    @Binding var showSheetView: Bool
    @State var alias: String = ""
    @State var address: String = ""
    private let pasteboard = UIPasteboard.general
    @State var showToastMessage = false
    @State var toastMessage = ""

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text(AppStrings.alias)
                    .font(.headline).padding([.horizontal, .top])
                Text("\(self.alias)").padding([.horizontal, .bottom])
                HStack {
                    Text(AppStrings.btcAddress)
                        .font(.headline)
                    CopyButton(copyString: self.address) {
                        withAnimation {
                            self.toastMessage = AppStrings.btcAddress + AppStrings.copied
                            self.showToastMessage = true
                        }
                    }
                }.padding([.horizontal, .top])
                Text(self.address).padding([.horizontal, .bottom])
                HStack {
                    Spacer()
                    ImageQRCode(text: self.address)
                    Spacer()
                }.padding()
                Spacer()
            }
            .navigationBarTitle(Text(AppStrings.btcQrCode), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                print("Dismissing sheet view...")
                self.showSheetView = false
            }) {
                Image("clear")
            })
                .toastMessage(message: self.$toastMessage, show: self.$showToastMessage)
        }
    }
}

struct ListItemAddress: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appController: AppController
    @ObservedObject var addressListVM: AddressListViewModel

    @State private var showDelAlert: Bool = false
    @State private var showQRCodeSheet: Bool = false
    @State var showAddressEditor = false

    var recordAddress: AddressViewModel
    @State var alertUseFixedAddress = false

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
                return Alert(title: Text("Delete this address?"),
                    primaryButton: .default(Text("delete"), action: {
                        if CoreDataManager.shared.deleteAddress(
                                addressVM: AddressViewModel(alias: self.recordAddress.alias,
                                                            address: self.recordAddress.address)) {
                            self.addressListVM.fetchAllAddresses()
                        }
                    }),
                    secondaryButton: .default(Text("cancel")))
            }

            Button(action: {
                self.showQRCodeSheet = true
            }) {Image("qrcode")}.buttonStyle(BorderlessButtonStyle()).padding(.horizontal, 10).padding(.trailing, 5)
            .sheet(isPresented: self.$showQRCodeSheet) {
                AddressQRCodeView(showSheetView: self.$showQRCodeSheet,
                                  alias: self.recordAddress.alias,
                                  address: self.recordAddress.address)
                    .accentColor(AppController.getAccentColor(colorScheme: self.colorScheme))
            }

            Button(action: {
                if !self.appController.useFixedAddress {
                    self.appController.pageSelected = 0
                    self.appController.payeeAddr = self.recordAddress.address
                }
                else {
                    self.alertUseFixedAddress = true
                }
            }){Image("send")}.buttonStyle(BorderlessButtonStyle())
            .alert(isPresented: self.$alertUseFixedAddress){
                Alert(title: Text("use_fixed_address"))
            }
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
