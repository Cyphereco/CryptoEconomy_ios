//
//  ViewOpenTurnKeyInfo.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/4/9.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct ViewOpenTurnKeyInfo: View {
    @Binding var btcBalance: Double
    @EnvironmentObject var appController: AppController
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @State var showOtkInfo = false
    @State var showToastMessage = false
    @State var toastMessage = ""

    let otkNpi = AppController.otkNpi
    
    var pasteboard = UIPasteboard.general
 
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    showLockState(state: self.otkNpi.otkState.isLocked).foregroundColor(self.otkNpi.otkState.isLocked ? .red : .green)
                    showBatteryLevel(level: self.otkNpi.otkInfo.batteryPercentage).foregroundColor(self.otkNpi.otkInfo.batteryPercentage.contains("10%") ? .red : (colorScheme == .dark ? .white : .black))
                    Text(self.otkNpi.otkInfo.batteryPercentage)
                }.padding()
                VStack {
                    if self.btcBalance < 0 {
                        Text("Cannot update balance due to newwork connection problems, please try later!").font(.headline)
                    }
                    else {
                        Text("\(AppTools.btcToFormattedString(self.btcBalance)) BTC").font(.title)
                        Text("(~ \(AppTools.fiatToFormattedString(AppTools.btcToFiat(self.btcBalance, currencySelection: self.appController.getLocalCurrency().ordinal))) \(appController.getLocalCurrency().label))").font(.headline)
                    }
                }.padding()
                VStack {
                    ImageQRCode(text: self.otkNpi.otkData.btcAddress)
                    Text(self.otkNpi.otkData.btcAddress).multilineTextAlignment(.center).padding()
                    CopyButton(copyString: self.otkNpi.otkData.btcAddress){
                        self.toastMessage = AppStrings.btcAddress + AppStrings.copied
                        self.showToastMessage = true
                    }
                }.padding()
                Spacer()
                HStack(alignment: .top) {
                    Text("\(AppStrings.note):")
                    Text(self.otkNpi.otkInfo.note)
                        .frame(minWidth: 200)
                        .lineLimit(5)
                        .multilineTextAlignment(.leading)
                    Image("info").foregroundColor(AppController.getAccentColor(colorScheme:  self.colorScheme))
                        .onTapGesture {
                            self.showOtkInfo = true
                    }.padding(.top, -5)
                    .alert(
                        isPresented: self.$showOtkInfo,
                        content: {
                            Alert(title: Text(AppStrings.mintInfo),
                                  message: Text(self.otkNpi.readTag.info)
                            )
                        }
                    )
                }.padding(20)
                Divider().frame(height: 1).padding(.bottom, 10)
            }
            .padding(.horizontal, 20.0)
            .accentColor(AppController.getAccentColor(colorScheme:  self.colorScheme))
            .navigationBarTitle(Text(AppStrings.openturnkeyInfo), displayMode: .inline)
            .navigationBarItems(trailing:
                Image("clear")
                    .foregroundColor(AppController.getAccentColor(colorScheme:  self.colorScheme))
                    .onTapGesture {
                    self.presentationMode.wrappedValue.dismiss()
                })
                .toastMessage(message: self.$toastMessage, show: self.$showToastMessage)
        }
    }
    
//    func getQrCodeData(str: String) -> Data {
//        let filter = CIFilter(name: "CIQRCodeGenerator")
//        let data = str.data(using: .ascii, allowLossyConversion: false)
//        filter?.setValue(data, forKey: "inputMessage")
//        let image = filter?.outputImage
//        let uiimage = UIImage(ciImage: image!)
//        return uiimage.pngData()!
//    }
    
    func showLockState(state: Bool) -> Image{
        return state ? Image("lock") : Image("unlock")
    }
    
    func showBatteryLevel(level: String) -> Image {
        switch level {
            case "100%":
                return Image("battery100")
            case "90%":
                return Image("battery90")
            case "80%":
                return Image("battery80")
            case "70%":
                return Image("battery80")
            case "60%":
                return Image("battery60")
            case "50%":
                return Image("battery50")
            case "40%":
                return Image("battery50")
            case "30%":
                return Image("battery30")
            default:
                return Image("battery20")
        }
    }
}

struct ViewOpenTurnKeyInfo_Previews: PreviewProvider {
    static var previews: some View {
        ViewOpenTurnKeyInfo(btcBalance: .constant(0.0))
            .environmentObject(AppController())
    }
}
