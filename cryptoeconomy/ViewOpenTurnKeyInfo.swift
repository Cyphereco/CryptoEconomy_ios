//
//  ViewOpenTurnKeyInfo.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/4/9.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct ViewOpenTurnKeyInfo: View {
    var lockState = false
    var batteryLevel = 0
    var btcBalance: Double = 0.0
    var fiatBalance: Double = 0.0
    var btcAddress: String = "BTC Address"
    var note: String = ""
    @EnvironmentObject var appConfig: AppConfig

    var body: some View {
        VStack {
            HStack {
                Spacer()
                showLockState(state: lockState).foregroundColor(lockState ? .red : .green)
                showBatteryLevel(level: batteryLevel)
                Text("\(batteryLevel)%")
            }.padding()
            VStack {
                Text("\(AppTools.btcToFormattedString(self.btcBalance)) BTC").font(.title)
                Text("(~ \(AppTools.fiatToFormattedString(self.fiatBalance)) \(appConfig.getLocalCurrency().label))").font(.footnote)
            }.padding()
            VStack {
                Image(uiImage: UIImage(data: getQrCodeData(str: btcAddress))!).resizable().frame(width: 160, height: 160)
                Text(self.btcAddress).multilineTextAlignment(.center)
                Image("copy")
            }.padding()
            Spacer()
            HStack {
                Text("Note:")
                TextFieldWithBottomLine(textContent: self.note, textAlign: .leading, readOnly: true)
                Image("info").foregroundColor(.yellow)
            }.padding(20)
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
    
    func showBatteryLevel(level: Int) -> Image {
        switch batteryLevel {
            case 100:
                return Image("battery100")
            case 90:
                return Image("battery90")
            case 80:
                return Image("battery80")
            case 70:
                return Image("battery80")
            case 60:
                return Image("battery60")
            case 50:
                return Image("battery50")
            case 40:
                return Image("battery50")
            case 30:
                return Image("battery30")
            default:
                return Image("battery20")
        }
    }
}

struct ViewOpenTurnKeyInfo_Previews: PreviewProvider {
    static var previews: some View {
        ViewOpenTurnKeyInfo(
            lockState: true,
            batteryLevel: 40,
            btcBalance: 0.12345678,
            fiatBalance: 712.52,
            btcAddress: "1QEma6prBJscNqw7s3t8EGFcx3zF7mzWab",
            note: "My OTK")
            .environmentObject(AppConfig())
    }
}
