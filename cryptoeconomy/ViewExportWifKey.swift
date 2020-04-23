//
//  ViewExportWifKey.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/4/22.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct ViewExportWifKey: View {
    @EnvironmentObject var appController: AppController
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @State var showOtkInfo = false
    @State var message = ""
    @State var showToast = false

    let otkNpi = AppController.otkNpi

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Wallet Import Format Key").font(.headline)
                    Spacer()
                    CopyButton(copyString: self.otkNpi.otkData.wifKey){
                        self.message = "Wallet Import Format Key" + AppStrings.copied
                        self.showToast = true
                    }
                }.padding()
                Text(self.otkNpi.otkData.wifKey)
                    .lineLimit(5)
                    .multilineTextAlignment(.leading)
                    .padding()
                ImageQRCode(text: self.otkNpi.otkData.wifKey).frame(width: 150, height: 150)
                Spacer()
            }
            .padding(.horizontal, 20.0)
            .accentColor(AppController.getAccentColor(colorScheme:  self.colorScheme))
            .navigationBarTitle("Export Key", displayMode: .inline)
            .navigationBarItems(trailing:
                Image("clear")
                    .foregroundColor(AppController.getAccentColor(colorScheme:  self.colorScheme))
                    .onTapGesture {
                    self.presentationMode.wrappedValue.dismiss()
                })
                .toastMessage(message: self.$message, show: self.$showToast)
        }
    }
}

struct ViewExportWifKey_Previews: PreviewProvider {
    static var previews: some View {
        ViewExportWifKey()
    }
}
