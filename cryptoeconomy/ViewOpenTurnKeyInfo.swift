//
//  ViewOpenTurnKeyInfo.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/4/9.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct ViewOpenTurnKeyInfo: View {
    @Binding var otkNpi : OtkNfcProtocolInterface
    @Binding var btcBalance: Double
    var fiatBalance: Double = 0.0
    @EnvironmentObject var appConfig: AppConfig
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @State var showOtkInfo = false
    @State var showToastMessage = false
    
    var pasteboard = UIPasteboard.general
 
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    HStack {
                        Spacer()
                        showLockState(state: otkNpi.otkState.isLocked).foregroundColor(otkNpi.otkState.isLocked ? .red : .green)
                        showBatteryLevel(level: otkNpi.otkInfo.batteryPercentage).foregroundColor(otkNpi.otkInfo.batteryPercentage.contains("10%") ? .red : (colorScheme == .dark ? .white : .black))
                        Text(otkNpi.otkInfo.batteryPercentage)
                    }.padding()
                    VStack {
                        Text("\(AppTools.btcToFormattedString(self.btcBalance)) BTC").font(.title)
                        Text("(~ \(AppTools.fiatToFormattedString(self.fiatBalance)) \(appConfig.getLocalCurrency().label))").font(.footnote)
                    }.padding()
                    VStack {
                        Image(uiImage: UIImage(data: getQrCodeData(str: otkNpi.otkData.btcAddress))!).resizable().frame(width: 100, height: 100)
                        Text(self.otkNpi.otkData.btcAddress).multilineTextAlignment(.center).padding()
                        Button(action: {
                            withAnimation {
                                self.pasteboard.string = self.otkNpi.otkData.btcAddress
                                self.showToastMessage = true
                            }
                        }){
                            Image("copy")
                        }
                    }.padding()
                    Spacer()
                    HStack {
                        Text("\(AppStrings.note):")
                        TextFieldWithBottomLine(textContent: .constant(otkNpi.otkInfo.note), textAlign: .leading, readOnly: true)
                        Image("info").foregroundColor(AppConfig.getAccentColor(colorScheme:  self.colorScheme))
                            .onTapGesture {
                                self.showOtkInfo = true
                        }
                        .alert(
                            isPresented: self.$showOtkInfo,
                            content: {
                                Alert(title: Text(AppStrings.mintInfo),
                                      message: Text(self.otkNpi.readTag.info)
                                )
                            }
                        )
                    }.padding(20)
                }
                .padding(.horizontal, 20.0)
                .navigationBarTitle(Text(AppStrings.openturnkeyInfo), displayMode: .inline)
                .navigationBarItems(trailing:
                    Image("clear")
                        .foregroundColor(AppConfig.getAccentColor(colorScheme:  self.colorScheme))
                        .onTapGesture {
                        self.presentationMode.wrappedValue.dismiss()
                    })
            }
            if (self.showToastMessage) {
                ViewToastMessage(message: "Copied", delay: 2, show: self.$showToastMessage)
            }
        }
    }
    
    func getQrCodeData(str: String) -> Data {
        let filter = CIFilter(name: "CIQRCodeGenerator")
        let data = str.data(using: .ascii, allowLossyConversion: false)
        filter?.setValue(data, forKey: "inputMessage")
        let image = filter?.outputImage
        let uiimage = UIImage(ciImage: image!)
        return uiimage.pngData()!
    }
    
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
        ViewOpenTurnKeyInfo(otkNpi: .constant(OtkNfcProtocolInterface()), btcBalance: .constant(0.0))
            .environmentObject(AppConfig())
    }
}
