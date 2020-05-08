//
//  ViewAddressEditor.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/3/30.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct ViewAddressEditor: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var addressListVM = AddressListViewModel()
    @State var alias: String
    @State var address: String

    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State var keyboardActive = false

    var body: some View {
        VStack {
            TextField(AppStrings.alias, text: self.$alias).addUnderline().padding()
            TextFieldBtcAddress(address: self.$address).padding()
            HStack {
                Spacer()
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    HStack(alignment: .center){
                        Text(AppStrings.cancel)
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                    }
                    .frame(minWidth: 80)
                    .padding(12)
                    .cornerRadius(24)
                }
                Button(action: {
                    if (self.alias.isEmpty) {
                        self.alias = self.address.prefix(4) + "****" + self.address.suffix(4)
                    }
                    
                    if CoreDataManager.shared.insertAddress(
                            addressVM: AddressViewModel(alias: self.alias,address: self.address))
                    {
                        self.addressListVM.fetchAllAddresses()
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    else {
                        self.showAlert = true
                        self.alertMessage = "Database error! Add address failed."
                    }
                }) {
                    HStack(alignment: .center){
                        Text("save")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                    }
                    .frame(minWidth: 80)
                    .padding(12)
                    .opacity(self.address.isEmpty ? 0.3 : 1)
                    .setCustomDecoration(.roundedButton)
                }
                .disabled(self.address.isEmpty)
                .alert(isPresented: self.$showAlert) {
                    return Alert(title: Text(self.alertMessage))
                }
            }.padding(.top, 20.0)
        }
        .padding(.horizontal, 20.0)
        .onTapBackground({
            if self.keyboardActive {
                UIApplication.shared.endEditing()
            }
        })
        .setCustomDecoration(.accentColor)
        .addSheetTitle(AppStrings.editAddress)
        .isKeyboardActive(keyboardActive: self.$keyboardActive)
    }
}

struct ViewAddressEditor_Previews: PreviewProvider {
    static var previews: some View {
        ViewAddressEditor(addressListVM: AddressListViewModel(), alias: "", address: "")
    }
}
