//
//  ViewAddressEditor.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/3/30.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct ViewAddressEditor: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var addressListVM: AddressListViewModel
    @State var alias: String
    @State var address: String

    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    var body: some View {
        NavigationView {
            BackgroundView {
                VStack {
                    TextFieldWithBottomLine(hint: "alias",
                                            textContent: self.$alias,
                                            textAlign: .leading,
                                            readOnly: false).padding()
                    TextFieldBtcAddress(address: self.$address).padding()
                    HStack {
                        Spacer()
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack(alignment: .center){
                                Text("cancel")
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                            }
                            .frame(minWidth: 80)
                            .padding(12)
                            .cornerRadius(24)
                        }
                        Button(action: {
                            if (!self.alias.isEmpty) && (!self.address.isEmpty) {
                                if CoreDataManager.shared.insertAddress(
                                        addressVM: AddressViewModel(alias: self.alias,
                                                                    address: self.address)) {
                                    self.addressListVM.fetchAllAddresses()
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                                else {
                                    self.showAlert = true
                                    self.alertMessage = "Cannot add to database!!!"
                                }
                            }
                            else {
                                self.showAlert = true
                                self.alertMessage = "Input is empty!!!"
                            }
                        }) {
                            HStack(alignment: .center){
                                Text("save")
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                            }
                            .frame(minWidth: 80)
                            .padding(12)
                            .background(AppConfig.getAccentColor(colorScheme: self.colorScheme))
                            .cornerRadius(24)
                            .foregroundColor(.white)
                        }
                        .alert(isPresented: self.$showAlert) {
                            return Alert(title: Text(self.alertMessage))
                        }
                    }.padding(.top, 20.0)
                }.padding(.horizontal, 20.0)
                
            }
            .onTapGesture {
                UIApplication.shared.endEditing()
            }

            .navigationBarTitle(Text("edit_address"), displayMode: .inline)
        }.accentColor(AppConfig.getAccentColor(colorScheme: self.colorScheme))
    }
}

struct ViewAddressEditor_Previews: PreviewProvider {
    static var previews: some View {
        ViewAddressEditor(addressListVM: AddressListViewModel(), alias: "", address: "")
    }
}
