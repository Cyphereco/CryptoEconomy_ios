//
//  DialogSetPin.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/5/1.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI
import Combine

class PinCodeInput: ObservableObject {
    let didChange = PassthroughSubject<PinCodeInput, Never>()
    
    @Published var firstPin = "" { didSet {
        if self.firstPin.count > 8 {
            self.firstPin = String(self.firstPin.prefix(8))
        }
        self.didChange.send(self)
    }}

    @Published var secondPin = "" { didSet {
        if self.secondPin.count > 8 {
            self.secondPin = String(self.secondPin.prefix(8))
        }
        self.didChange.send(self)
    }}
    
    func validateInput() -> Bool {
        return (self.firstPin == self.secondPin) && (self.firstPin.count == 8)
    }
}

struct DialogSetPin: View {
    let showDialog: Bool
    let closeDialog: ()->Void

    @State var pin = ""
    var handler: (String) -> Void
    
    @ObservedObject var pinInput = PinCodeInput()

    @State var showFirstPin = false
    @State var showSecondPin = false
    @State var keyboardActive = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                GeometryReader { _ in
                    EmptyView()
                }
                .background(Color.gray.opacity(0.8))
                .opacity(self.showDialog ? 0.5 : 0.0)
                .animation(.easeInOut)
                .onTapGesture {
                    if self.keyboardActive {
                        UIApplication.shared.endEditing()
                    }
                    self.closeDialog()
                    self.pinInput.firstPin = ""
                    self.pinInput.secondPin = ""
                }

                VStack {
                    Text(AppStrings.setPinCode).font(.headline)
                    Text("Please enter a 8-digits nubmer.").padding()
                    
                    HStack {
                        if !self.showFirstPin {
                            SecureField("Enter PIN Code", text: self.$pinInput.firstPin)
                                .addUnderline().padding(.horizontal)
                            Image(systemName: "eye.fill").onTapGesture {
                                self.showFirstPin.toggle()
                            }
                        }
                        else {
                            TextField("Enter PIN Code", text: self.$pinInput.firstPin)
                            .addUnderline().padding(.horizontal)
                            Image(systemName: "eye.slash.fill").onTapGesture {
                                self.showFirstPin.toggle()
                            }
                        }
                    }.padding(.horizontal)
                    .keyboardType(.numberPad)

                    HStack {
                        if !self.showSecondPin {
                            SecureField("Confirm PIN Code", text: self.$pinInput.secondPin)
                            .addUnderline().padding(.horizontal)
                            Image(systemName: "eye.fill").onTapGesture {
                                self.showSecondPin.toggle()
                            }
                        }
                        else {
                            TextField("Confirm PIN Code", text: self.$pinInput.secondPin)
                            .addUnderline().padding(.horizontal)
                            Image(systemName: "eye.slash.fill").onTapGesture {
                                self.showSecondPin.toggle()
                            }
                        }
                    }.padding(.horizontal)
                    .keyboardType(.numberPad)

                    Button(action: {
                        self.closeDialog()
                        self.handler(self.pinInput.firstPin)
                        self.pinInput.firstPin = ""
                        self.pinInput.secondPin = ""
                    }){
                        Text("ok")
                    }.disabled(!self.pinInput.validateInput())
                }
                .padding()
                .setCustomDecoration(.backgroundNormal)
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                .frame(width: 320)
                .disabled(!self.showDialog)
                .opacity(self.showDialog ? 1 : 0)
                .animation(.easeInOut)
            }
       }.isKeyboardActive(keyboardActive: self.$keyboardActive)
    }
}

struct DialogSetPin_Previews: PreviewProvider {
    static var previews: some View {
        DialogSetPin(showDialog: true, closeDialog: {}, handler: {pin in })
    }
}
