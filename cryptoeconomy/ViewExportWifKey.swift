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
    @State var showOtkInfo = false
    @State var message = ""
    @State var showBubble = false

    let otkNpi = AppController.otkNpi

    var body: some View {
        VStack {
            HStack {
                Text(AppStrings.wallet_import_format_key).font(.headline)
                Spacer()
                CopyButton(copyString: self.otkNpi.otkData.wifKey){
                    self.message = AppStrings.wallet_import_format_key + AppStrings.copied
                    self.showBubble = true
                }
            }.padding()
            Text(self.otkNpi.otkData.wifKey)
                .lineLimit(5)
                .multilineTextAlignment(.leading)
                .padding()
            ImageQRCode(text: self.otkNpi.otkData.wifKey)
            Spacer()
        }
        .padding(.horizontal, 20.0)
        .setCustomDecoration(.accentColor)
        .bubbleMessage(message: self.$message, show: self.$showBubble)
    }
}

struct ViewExportWifKey_Previews: PreviewProvider {
    static var previews: some View {
        ViewExportWifKey()
    }
}
