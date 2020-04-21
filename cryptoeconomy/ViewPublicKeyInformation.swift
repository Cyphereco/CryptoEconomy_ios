//
//  ViewPublicKeyInformation.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/4/21.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct ViewPublicKeyInformation: View {
    @EnvironmentObject var appController: AppController
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @State var showOtkInfo = false
    @State var message = ""
    @State var showToast = false

    let otkNpi = AppController.otkNpi
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    Text("Master Public Key").font(.headline)
                    Spacer()
                    CopyButton(copyString: self.otkNpi.otkData.masterKey){
                        self.message = "Master Public Key" + AppStrings.copied
                        self.showToast = true
                    }
                    Image("qrcode")
                }.padding(.horizontal)
                Text(self.otkNpi.otkData.masterKey)
                    .lineLimit(5)
                    .multilineTextAlignment(.leading)
                    .addUnderline()
                    .padding(.horizontal)
                HStack {
                    Text("Derivative Public Key").font(.headline)
                    Spacer()
                    CopyButton(copyString: self.otkNpi.otkData.derivativeKey){
                        self.message = "Derivative Public Key" + AppStrings.copied
                        self.showToast = true
                    }
                    Image("qrcode")
                }.padding(.horizontal)
                Text(self.otkNpi.otkData.derivativeKey)
                    .lineLimit(5)
                    .multilineTextAlignment(.leading)
                    .addUnderline()
                    .padding(.horizontal)
                HStack {
                    Text("Derivative Path:").font(.headline)
                    Spacer()
                    CopyButton(copyString: self.otkNpi.otkData.derivativePath){
                        self.message = "Derivative Path" + AppStrings.copied
                        self.showToast = true
                    }
                    Image("qrcode")
                }.padding(.horizontal)
                VStack {
                    HStack {
                        Text("L1")
                        Text(getKeyPath(self.otkNpi.otkData.derivativePath, 1))
                            .addUnderline()
                    }.padding(.horizontal)
                    HStack {
                        Text("L2")
                        Text(getKeyPath(self.otkNpi.otkData.derivativePath, 2))
                            .addUnderline()
                    }.padding(.horizontal)
                    HStack {
                        Text("L3")
                        Text(getKeyPath(self.otkNpi.otkData.derivativePath, 3))
                            .addUnderline()
                    }.padding(.horizontal)
                    HStack {
                        Text("L4")
                        Text(getKeyPath(self.otkNpi.otkData.derivativePath, 4))
                            .addUnderline()
                    }.padding(.horizontal)
                    HStack {
                        Text("L5")
                        Text(getKeyPath(self.otkNpi.otkData.derivativePath, 5))
                            .addUnderline()
                    }.padding(.horizontal)
                }
                Spacer()
            }
            .padding(.horizontal, 20.0)
            .accentColor(AppController.getAccentColor(colorScheme:  self.colorScheme))
            .navigationBarTitle("Public Key Information", displayMode: .inline)
            .navigationBarItems(trailing:
                Image("clear")
                    .foregroundColor(AppController.getAccentColor(colorScheme:  self.colorScheme))
                    .onTapGesture {
                    self.presentationMode.wrappedValue.dismiss()
                })
                .toastMessage(message: self.$message, show: self.$showToast)
        }
    }
    
    func getKeyPath(_ strPath: String, _ level: Int) -> String {
        let indexes = strPath.replacingOccurrences(of: "m/", with: "").components(separatedBy: "/")
        let l = level - 1
        if l < 0 || l > indexes.count - 1 {
            return "invalid"
        }
        return indexes[l]
        
    }
}

struct ViewPublicKeyInformation_Previews: PreviewProvider {
    static var previews: some View {
        ViewPublicKeyInformation()
        .environmentObject(AppController())
    }
}
