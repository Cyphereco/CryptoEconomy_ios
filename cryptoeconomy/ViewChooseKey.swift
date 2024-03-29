//
//  ViewChooseKey.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/4/26.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI
import Darwin

struct ViewChooseKey: View {
    @Binding var otkRequest: OtkRequest
    let closeSheet: ()->Void

    private let pasteboard = UIPasteboard.general

    @State var keyIndexes = ["", "", "", "", ""]
    @State var requireFocus = [true, false, false, false, false]
    @State var isShowingScanner = false
    @State var showBubble = false
    @State var bubbleMessage = ""
    
    @State var falseInput = false
    @State var keyboardActive = false
    @State var textHeight = CGFloat(0)

    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                TextView(placeholder: "", text: .constant(AppStrings.choose_key_desc), minHeight: self.textHeight, calculatedHeight: self.$textHeight, editable: false)
                .frame(height: self.textHeight)
                Spacer()
                Button(action: {
                    if let pasteString = self.pasteboard.string {
                        self.pastePath(path: pasteString)
                    }
                }){Image("paste")}.padding(.horizontal)

                Button(action: {
                    self.isShowingScanner = true
                    if self.keyboardActive {
                        UIApplication.shared.endEditing()
                    }
                }){Image("scan_qrcode")}
                
            }.padding()

            VStack {
                ForEach(0 ..< self.keyIndexes.count) { item in
                    TextField("\(AppStrings.level) \(item + 1) \(AppStrings.index)", text: self.$keyIndexes[item], onEditingChanged: {_ in
                        if self.keyIndexes[item].count > 0 {
                            self.falseInput = false
                            self.clearFocus()
                            if !self.validateKeyIndex(self.toInt(self.keyIndexes[item])){
                                self.bubbleMessage = "\(AppStrings.index_out_of_range): \(self.keyIndexes[item])"
                                self.showBubble = true
                                self.keyIndexes[item] = ""
                                self.requireFocus[item] = true
                                self.falseInput = true
                            }
                        }
                    })
                    .addUnderline()
                    .onTapGesture {
                        if !self.falseInput {
                            self.requireFocus[item] = true
                        }
                    }
                    .keyboardType(.numberPad)
                    .padding(.horizontal)
                        .introspectTextField() {textField in
                        if self.requireFocus[item] {
                            textField.becomeFirstResponder()
                        }
                    }
                }
                Text("*\(AppStrings.index_range): 0 ~ 2,147,483,647")
            }.keyboardResponsive()

            HStack {
                Spacer()
                Button(action: {
                    self.cancelRequest()
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
                    if self.validatePath() {
                        self.otkRequest.command = .setKey
                        self.otkRequest.data = "\(self.keyIndexes[0])"
                        self.otkRequest.data += ",\(self.keyIndexes[1])"
                        self.otkRequest.data += ",\(self.keyIndexes[2])"
                        self.otkRequest.data += ",\(self.keyIndexes[3])"
                        self.otkRequest.data += ",\(self.keyIndexes[4])"
                    }
                    self.closeSheet()
                }) {
                    HStack(alignment: .center){
                        Text("ok")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                    }
                    .frame(minWidth: 80)
                    .padding(12)
                    .opacity(!validatePath() ? 0.3 : 1)
                    .setCustomDecoration(.roundedButton)
                }
                .disabled(!validatePath())
            }.padding()

            Spacer()
        }
        .sheet(isPresented: self.$isShowingScanner){
            QRCodeScanner(closeScanner: {
                self.isShowingScanner = false
            }, completion: {result in
                self.isShowingScanner = false
                switch result {
                    case .success(let data):
                        self.pastePath(path: data)
                    case .failure(let error):
                        Logger.shared.warning("Scanning failed \(error)")
                }
            }).setCustomDecoration(.accentColor)
        }
        .setCustomDecoration(.accentColor)
        .onTapBackground {
            if self.keyboardActive {
                UIApplication.shared.endEditing()
            }
            self.clearFocus()
        }
        .bubbleMessage(message: self.$bubbleMessage, show: self.$showBubble)
        .isKeyboardActive(keyboardActive: self.$keyboardActive)
    }
    
    func cancelRequest() {
        self.otkRequest.command = .invalid
        self.otkRequest.data = ""
        self.closeSheet()
    }
    
    func clearFocus() {
        for i in 0...self.requireFocus.count - 1 {
            self.requireFocus[i] = false
        }
    }
    
    func pastePath(path: String) {
        print("Paste key path: \(path)")
        let strs = path.components(separatedBy: "/")
        if strs.count == 6 && strs[0] == "m" {
            for i in 1...self.keyIndexes.count {
                self.keyIndexes[i-1] = strs[i]
            }
        }
        
        if !self.validatePath() {
            for i in 0...self.keyIndexes.count - 1 {
                self.keyIndexes[i] = ""
            }
            self.bubbleMessage = AppStrings.invalid_path
            self.showBubble = true
        }
        else {
            if self.keyboardActive {
                UIApplication.shared.endEditing()
            }
        }
    }
    
    func toInt(_ idx: String) -> Int {
        return Int(idx) ?? -1
    }
    
    func validateKeyIndex(_ index: Int) -> Bool {
        return index > -1 && index < Int(pow(2.0, 31.0))
    }
    
    func validatePath() -> Bool {
        var i = 0
        for index in self.keyIndexes {
            if !validateKeyIndex(toInt(index)) {
                print("Invalid indexes[\(i)]: \(index)")
                return false
            }
            i += 1
        }
 
        return true
    }
}

struct ViewChooseKey_Previews: PreviewProvider {
    static var previews: some View {
        ViewChooseKey(otkRequest: .constant(OtkRequest()), closeSheet: {})
        .environmentObject(AppController())
    }
}
