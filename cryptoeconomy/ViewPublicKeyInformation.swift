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
    @State var showOtkInfo = false
    @State var message = ""
    @State var showToast = false
    @State var QRCodeData = ""
    @State var QRCodeTitle = ""

    let otkNpi = AppController.otkNpi
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(AppStrings.master_public_key).font(.headline)
                    Spacer()
                    CopyButton(copyString: self.otkNpi.otkData.masterKey){
                        self.message = AppStrings.master_public_key + AppStrings.copied
                        self.showToast = true
                    }
                    Button(action: {
                        self.QRCodeTitle = AppStrings.master_public_key
                        self.QRCodeData = self.otkNpi.otkData.masterKey
                    }){
                        Image("qrcode")
                    }
                }.padding([.horizontal, .top])
                Text(self.otkNpi.otkData.masterKey)
                    .lineLimit(5)
                    .multilineTextAlignment(.leading)
                    .addUnderline()
                    .padding(.horizontal)
                HStack {
                    Text(AppStrings.derivative_public_key).font(.headline)
                    Spacer()
                    CopyButton(copyString: self.otkNpi.otkData.derivativeKey){
                        self.message = AppStrings.derivative_public_key + AppStrings.copied
                        self.showToast = true
                    }
                    Button(action: {
                        self.QRCodeTitle = AppStrings.derivative_public_key
                        self.QRCodeData = self.otkNpi.otkData.derivativeKey
                    }){
                        Image("qrcode")
                    }
                }.padding(.horizontal)
                Text(self.otkNpi.otkData.derivativeKey)
                    .lineLimit(5)
                    .multilineTextAlignment(.leading)
                    .addUnderline()
                    .padding(.horizontal)
                HStack {
                    Text(AppStrings.derivative_key_paths).font(.headline)
                    Spacer()
                    CopyButton(copyString: self.otkNpi.otkData.derivativePath){
                        self.message = AppStrings.derivative_key_paths + AppStrings.copied
                        self.showToast = true
                    }
                    Button(action: {
                        self.QRCodeTitle = AppStrings.derivative_key_paths
                        self.QRCodeData = self.otkNpi.otkData.derivativePath
                    }){
                        Image("qrcode")
                    }
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
            .blur(radius: self.QRCodeData.count > 0 ? 0.8 : 0)
            .padding(.horizontal, 20.0)
            .setCustomDecoration(.accentColor)
            .toastMessage(message: self.$message, show: self.$showToast)

            GeometryReader { _ in
                EmptyView()
            }
            .background(Color.gray.opacity(0.6))
            .opacity(self.QRCodeData.count > 0 ? 0.5 : 0.0)
            .animation(.easeInOut)
            .onTapGesture {
                self.QRCodeData = ""
            }

            if self.QRCodeData.count > 0 {
                VStack(alignment: .center) {
                    Text(self.QRCodeTitle).font(.headline).padding()
                    Text(self.QRCodeData).lineLimit(10).multilineTextAlignment(.leading).frame(maxWidth: 260, maxHeight: 150)
                    ImageQRCode(text: self.QRCodeData).padding()
                }.frame(minWidth: 300, minHeight: 480)
                .setCustomDecoration(.backgroundNormal)
                .setCustomDecoration(.foregroundNormal)
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
            }
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
