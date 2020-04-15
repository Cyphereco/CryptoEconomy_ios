//
//  QRCodeGenerateView.swift
//  cryptoeconomy
//
//  Created by FuYuanChuang on 2020/4/8.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct QRCodeGenerateView: View {
    @State var inputString: String
    @State var width: CGFloat = 150
    @State var height: CGFloat = 150

    var body: some View {
        HStack {
            Spacer()
            if self.inputString != "" {
                Image(uiImage: UIImage(data: returnData(str: self.inputString))!)
                    .resizable()
                    .frame(width: self.width, height: self.height)
            }
            Spacer()
        }
    }
    
    func returnData(str: String) -> Data {
        let filter = CIFilter(name: "CIQRCodeGenerator")
        let data = str.data(using: .ascii, allowLossyConversion: false)
        filter?.setValue(data, forKey: "inputMessage")
        let image = filter?.outputImage
        let uiimage = UIImage(ciImage: image!)
        return uiimage.pngData()!
    }
}

struct QRCodeGenerateView_Previews: PreviewProvider {
    static var previews: some View {
        QRCodeGenerateView(inputString: "1QEma6prBJscNqw7s3t8EGFcx3zF7mzWab")
    }
}
